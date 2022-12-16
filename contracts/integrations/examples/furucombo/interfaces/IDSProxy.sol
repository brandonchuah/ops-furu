// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IDSProxy {
    event LogSetAuthority(address indexed authority);

    function execute(address _target, bytes memory _data)
        external
        payable
        returns (bytes memory response);

    function setAuthority(address _authority) external;

    function owner() external view returns (address);
}
