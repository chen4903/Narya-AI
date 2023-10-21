// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

contract ContainerDeployScript is Script {
    function run() public {
        console2.log("run");
        uint256 deployerPrivateKey = vm.envUint("privatekey");

        vm.startBroadcast(deployerPrivateKey);
        
        vm.stopBroadcast();
    }
}

