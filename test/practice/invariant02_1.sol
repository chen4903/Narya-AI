// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./WETH.sol";

contract A  is Test{
    WETH public weth;

    function setUp() public{
        weth = new WETH();
    }

    function invariant_shouldBeAlwaysZero() public{
        assertEq(weth.totalSupply(), 0);
        // Running 1 test for test/invariant02.sol:A
        // [PASS] invariant_shouldBeAlwaysZero() (runs: 500, calls: 7500, reverts: 4279)
        // Test result: ok. 1 passed; 0 failed; 0 skipped; finished in 590.23ms
        // Ran 1 test suites: 1 tests passed, 0 failed, 0 skipped (1 total tests)
    }
}