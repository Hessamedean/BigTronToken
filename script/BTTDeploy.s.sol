// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {BigTronToken} from "../src/BigTronToken.sol";

contract DeployBIGToken is Script {
    uint256 public constant INITIAL_SUPPLY = 1000000000000000000 ether;

    function run() external returns (BigTronToken) {
        vm.startBroadcast();
        BigTronToken btt = new BigTronToken();
        vm.stopBroadcast();
        return btt;
    }
}
