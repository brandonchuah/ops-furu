// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IExampleResolver {
    function onCreateTask(
        address dsProxy,
        bytes32 _taskId,
        bytes calldata resolverData
    ) external returns (bool);

    function onCancelTask(
        address dsProxy,
        bytes32 _taskId,
        bytes calldata resolverData
    ) external returns (bool);

    function onExec(
        address dsProxy,
        bytes32 _taskId,
        bytes calldata executionData
    ) external returns (bool);

    function checker(address dsProxy, bytes calldata resolverData)
        external
        view
        returns (bool canExec, bytes memory executionData);

    function action() external view returns (address);
}
