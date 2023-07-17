// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Counter.sol";

contract CounterTest is Test {

    function setUp() public {
        console2.log("set up");
    }

    function testA() public pure{
         console2.log("testA");
    }

}

