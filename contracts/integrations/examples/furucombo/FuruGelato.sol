// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "../../OpsTaskCreator.sol";
import {
    EnumerableSet
} from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import {ResolverWhitelist} from "./ResolverWhitelist.sol";
import {DSProxyBlacklist} from "./DSProxyBlacklist.sol";
import {IDSProxy} from "./interfaces/IDSProxy.sol";
import {IExampleResolver} from "./interfaces/IExampleResolver.sol";

// solhint-disable max-line-length
// solhint-disable no-empty-blocks
contract FuruGelato is ResolverWhitelist, DSProxyBlacklist, OpsTaskCreator {
    using EnumerableSet for EnumerableSet.Bytes32Set;

    mapping(address => EnumerableSet.Bytes32Set) internal _dsProxyTasks;

    event LogTaskCreated(address indexed dsProxy, bytes32 indexed taskId);
    event LogTaskCancelled(address indexed dsProxy, bytes32 indexed taskId);
    event LogExecSuccess(address indexed dsProxy, bytes32 indexed taskId);

    /**
     * @param _ops Automate (fka Ops) contract address - https://docs.gelato.network/developer-products/gelato-ops-smart-contract-automation-hub/contract-addresses
     * @param _fundsOwner Furucombo's owner address. (Used for withdrawing funds deposited into Gelato Balance)
     */
    constructor(address _ops, address _fundsOwner)
        OpsTaskCreator(_ops, _fundsOwner)
    {}

    function createTask(address _resolverAddress, bytes calldata _resolverData)
        external
        onlyValidResolver(_resolverAddress)
        onlyValidDSProxy(msg.sender)
    {
        bytes32 taskId = _createTask(
            address(this),
            abi.encode(this.exec.selector),
            _getModuleData(_resolverAddress, _resolverData),
            address(0)
        );

        require(
            !_dsProxyTasks[msg.sender].contains(taskId),
            "FuruGelato: Duplicate task"
        );

        IExampleResolver(_resolverAddress).onCreateTask(
            msg.sender,
            taskId,
            _resolverData
        );

        emit LogTaskCreated(msg.sender, taskId);
    }

    function exec(
        address _dsProxy,
        address _resolverAddress,
        bytes32 _taskId,
        bytes calldata _executionData
    ) external onlyValidResolver(_resolverAddress) onlyValidDSProxy(_dsProxy) {
        IExampleResolver(_resolverAddress).onExec(
            msg.sender,
            _taskId,
            _executionData
        );

        address action = IExampleResolver(_resolverAddress).action();

        try IDSProxy(_dsProxy).execute(action, _executionData) {} catch {
            revert("FuruGelato: exec: execute failed");
        }

        emit LogExecSuccess(_dsProxy, _taskId);
    }

    function cancelTask(address _resolverAddress, bytes calldata _resolverData)
        external
    {
        bytes32 taskId = _getTaskId(
            msg.sender,
            address(this),
            this.exec.selector,
            _getModuleData(_resolverAddress, _resolverData),
            address(0)
        );

        require(
            _dsProxyTasks[msg.sender].contains(taskId),
            "FuruGelato: Task not found"
        );

        IExampleResolver(_resolverAddress).onCancelTask(
            msg.sender,
            taskId,
            _resolverData
        );

        _cancelTask(taskId);

        emit LogTaskCancelled(msg.sender, taskId);
    }

    /**
     * @dev More info about ModuleData: https://docs.gelato.network/developer-services/automate/methods-for-submitting-your-task/smart-contract#moduledata
     * Time Module can be used here as well (equivalent to Furucombo's TaskTimer resolver - https://polygonscan.com/address/0x968fb295708f314386b1aa96cd3caf74207c1eda#code)
     */

    function _getModuleData(
        address _resolverAddress,
        bytes calldata _resolverData
    ) private view returns (ModuleData memory) {
        ModuleData memory moduleData = ModuleData({
            modules: new Module[](2),
            args: new bytes[](2)
        });

        moduleData.modules[0] = Module.RESOLVER;
        moduleData.modules[1] = Module.PROXY;

        moduleData.args[0] = _resolverModuleArg(
            _resolverAddress,
            abi.encodeCall(
                IExampleResolver.checker,
                (msg.sender, _resolverData)
            )
        );
        moduleData.args[1] = _proxyModuleArg();

        return moduleData;
    }
}
