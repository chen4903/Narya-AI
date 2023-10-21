// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

contract A  {
    bool public flag = false;
    uint256 public x = 0;

    function func_1() external{}
    function func_2() external{
        x = 1;
    }
    function func_3() external{}
    function func_4() external{}
    function func_5() external{
        if(x == 1){
            flag = true;
        }
        
    }

}

contract B is Test{
    A public a;
    function setUp() public{
        a = new A();
        targetContract(address(a));
    }

    function invariant_flag() public{
        assertEq(a.flag(), false); // a合约的方法会被随意调用，然后测试
    }
}