// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/StdInvariant.sol";

contract A {
    uint256 public shouldBeZero = 0;
    uint256 public hiddenValue = 999;
    
    function doStuff(uint256 _x) public {
        if(hiddenValue == 50){
            shouldBeZero = 1;
        }
        hiddenValue = _x;
    }
}

contract B is StdInvariant, Test{
    A a;

    function setUp() public{
        a = new A();
        // foundry会知道将随机调用这个a合约中的所有函数，并且保留状态
        targetContract(address(a));
    }

    function invariant_isAlwaysZero() public{
        // foudry随机调用a合约中的函数，保留状态，然后继续模糊测试
        // 比如第一次doStuff(50),将shouldBeZero设置为1，那么下次doStuff(any)就会使得下面的代码报错
        assert(a.shouldBeZero() == 0);
    }
}