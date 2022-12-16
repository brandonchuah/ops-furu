// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import {LibTaskId} from "../../../libraries/LibTaskId.sol";
import {LibDataTypes} from "../../../libraries/LibDataTypes.sol";
import {IDSProxyBlacklist} from "./interfaces/IDSProxyBlacklist.sol";
import {IFuruGelato} from "./interfaces/IFuruGelato.sol";
import {ITaskBlacklist} from "./interfaces/ITaskBlacklist.sol";

contract ExampleResolver {
    address public immutable action;
    address public immutable furuGelato;

    constructor(address _action, address _furuGelato) {
        action = _action;
        furuGelato = _furuGelato;
    }

    function onCreateTask(
        address _dsProxy,
        bytes32 _taskId,
        bytes calldata _resolverData
    ) external returns (bool) {
        _dsProxy;
        _taskId;
        _resolverData;
        return true;
    }

    function onCancelTask(
        address _dsProxy,
        bytes32 _taskId,
        bytes calldata _resolverData
    ) external returns (bool) {
        _dsProxy;
        _taskId;
        _resolverData;
        return true;
    }

    function onExec(
        address _dsProxy,
        bytes32 _taskId,
        bytes calldata _executionData
    ) external returns (bool) {
        _dsProxy;
        _taskId;
        _executionData;
        return true;
    }

    function checker(address _dsProxy, bytes calldata _resolverData)
        external
        view
        returns (bool, bytes memory)
    {
        // Verify if _dsProxy is valid
        require(
            IDSProxyBlacklist(furuGelato).isValidDSProxy(_dsProxy),
            "Creator not valid"
        );

        // Verify if _resolverData is valid
        require(_isValidResolverData(_resolverData), "Data not valid");

        // Verify if the task is valid
        bytes32 taskId = LibTaskId.getTaskId(
            _dsProxy,
            furuGelato,
            IFuruGelato.exec.selector,
            _getModuleData(_dsProxy, _resolverData),
            address(0)
        );

        require(
            ITaskBlacklist(furuGelato).isValidTask(taskId),
            "Task not valid"
        );

        /**
         * @dev Build execution data. Will be called by DSProxy
         * IDSProxy(_proxy).execute(action, executionData)
         */
        bytes memory executionData = _resolverData;

        return (
            true,
            abi.encodeCall(
                IFuruGelato.exec,
                (_dsProxy, address(this), taskId, executionData)
            )
        );
    }

    /**
     * @dev Build ModuleData to be used for reconstructing taskId
     * ModuleData returned here must match
     * ModuleData defined during task creation (FuruGelato.createTask)
     */
    function _getModuleData(address _taskCreator, bytes calldata _resolverData)
        private
        view
        returns (LibDataTypes.ModuleData memory)
    {
        LibDataTypes.ModuleData memory moduleData = LibDataTypes.ModuleData({
            modules: new LibDataTypes.Module[](2),
            args: new bytes[](2)
        });

        moduleData.modules[0] = LibDataTypes.Module.RESOLVER;
        moduleData.modules[1] = LibDataTypes.Module.PROXY;

        moduleData.args[0] = _resolverModuleArg(
            address(this),
            abi.encodeCall(this.checker, (_taskCreator, _resolverData))
        );
        moduleData.args[1] = _proxyModuleArg();

        return moduleData;
    }

    function _isValidResolverData(bytes calldata _resolverData)
        private
        pure
        returns (bool)
    {
        _resolverData;
        return true;
    }

    function _resolverModuleArg(
        address _resolverAddress,
        bytes memory _resolverData
    ) private pure returns (bytes memory) {
        return abi.encode(_resolverAddress, _resolverData);
    }

    function _proxyModuleArg() private pure returns (bytes memory) {
        return bytes("");
    }
}
