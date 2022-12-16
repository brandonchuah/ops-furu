// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IDSProxyBlacklist {
    function banDSProxy(address _dsProxy) external;

    function unbanDSProxy(address _dsProxy) external;

    function isValidDSProxy(address _dsProxy) external view returns (bool);
}
