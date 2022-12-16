// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

import "./OpsReady.sol";

/**
 * @dev Inherit this contract to allow your smart contract
 * to be a task creator and create tasks.
 */
abstract contract OpsTaskCreator is OpsReady {
    using SafeERC20 for IERC20;

    address public immutable fundsOwner;
    ITaskTreasuryUpgradable public immutable taskTreasury;

    constructor(address _ops, address _fundsOwner)
        OpsReady(_ops, address(this))
    {
        fundsOwner = _fundsOwner;
        taskTreasury = ops.taskTreasury();
    }

    /**
     * @dev
     * Withdraw funds from this contract's Gelato balance to fundsOwner.
     */
    function withdrawFunds(uint256 _amount, address _token) external {
        require(
            msg.sender == fundsOwner,
            "Only funds owner can withdraw funds"
        );

        taskTreasury.withdrawFunds(payable(fundsOwner), _token, _amount);
    }

    function _depositFunds(uint256 _amount, address _token) internal {
        uint256 ethValue = _token == ETH ? _amount : 0;
        taskTreasury.depositFunds{value: ethValue}(
            address(this),
            _token,
            _amount
        );
    }

    function _createTask(
        address _execAddress,
        bytes memory _execDataOrSelector,
        ModuleData memory _moduleData,
        address _feeToken
    ) internal returns (bytes32) {
        return
            ops.createTask(
                _execAddress,
                _execDataOrSelector,
                _moduleData,
                _feeToken
            );
    }

    function _cancelTask(bytes32 _taskId) internal {
        ops.cancelTask(_taskId);
    }

    function _resolverModuleArg(
        address _resolverAddress,
        bytes memory _resolverData
    ) internal pure returns (bytes memory) {
        return abi.encode(_resolverAddress, _resolverData);
    }

    function _timeModuleArg(uint256 _startTime, uint256 _interval)
        internal
        pure
        returns (bytes memory)
    {
        return abi.encode(uint128(_startTime), uint128(_interval));
    }

    function _proxyModuleArg() internal pure returns (bytes memory) {
        return bytes("");
    }

    function _singleExecModuleArg() internal pure returns (bytes memory) {
        return bytes("");
    }

    function _getTaskId(
        address taskCreator,
        address execAddress,
        bytes4 execSelector,
        ModuleData memory moduleData,
        address feeToken
    ) internal pure returns (bytes32 taskId) {
        if (_shouldGetLegacyTaskId(moduleData.modules)) {
            bytes32 resolverHash = _getResolverHash(moduleData.args[0]);

            taskId = _getLegacyTaskId(
                taskCreator,
                execAddress,
                execSelector,
                feeToken == address(0),
                feeToken,
                resolverHash
            );
        } else {
            taskId = keccak256(
                abi.encode(
                    taskCreator,
                    execAddress,
                    execSelector,
                    moduleData,
                    feeToken
                )
            );
        }
    }

    function _getLegacyTaskId(
        address taskCreator,
        address execAddress,
        bytes4 execSelector,
        bool useTaskTreasuryFunds,
        address feeToken,
        bytes32 resolverHash
    ) internal pure returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    taskCreator,
                    execAddress,
                    execSelector,
                    useTaskTreasuryFunds,
                    feeToken,
                    resolverHash
                )
            );
    }

    function _shouldGetLegacyTaskId(Module[] memory _modules)
        private
        pure
        returns (bool)
    {
        uint256 length = _modules.length;

        if (
            (length == 1 && _modules[0] == Module.RESOLVER) ||
            (length == 2 &&
                _modules[0] == Module.RESOLVER &&
                _modules[1] == Module.TIME)
        ) return true;

        return false;
    }

    function _getResolverHash(bytes memory resolverModuleArg)
        private
        pure
        returns (bytes32)
    {
        return keccak256(resolverModuleArg);
    }
}
