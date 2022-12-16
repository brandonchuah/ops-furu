// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IFuruGelato {
    function createTask(address _resolverAddress, bytes calldata _resolverData)
        external;

    function exec(
        address _proxy,
        address _resolverAddress,
        bytes32 _taskId,
        bytes calldata _executionData
    ) external;
}
