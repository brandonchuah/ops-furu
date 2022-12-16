// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface ITaskBlacklist {
    function banTask(bytes32 _taskId) external;

    function unbanTask(bytes32 _taskId) external;

    function isValidTask(bytes32 _taskId) external view returns (bool);
}
