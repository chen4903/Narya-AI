// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

contract Safe {
    receive() external payable {}

    function withdraw() external {
        payable(msg.sender).transfer(address(this).balance);
    }
}

contract SafeTest is Test {
    Safe safe;

    receive() external payable {}

    function setUp() public {
        safe = new Safe();
    }

    // 通过
    function test_pass(uint96 amount) public {
        payable(address(safe)).transfer(amount);
        uint256 preBalance = address(this).balance;
        safe.withdraw();
        uint256 postBalance = address(this).balance;
        assertEq(preBalance + amount, postBalance);
    }

    // 不通过:给测试合约的默认以太币数量是 2**96 wei（在 DappTools 中），
    // 所以我们必须将 amount 类型限制为 uint96 ，以确保我们不会尝试发送超过uint96的值
    function testFail_notPass(uint256 amount) public {
        payable(address(safe)).transfer(amount);
        uint256 preBalance = address(this).balance;
        safe.withdraw();
        uint256 postBalance = address(this).balance;
        assertEq(preBalance + amount, postBalance);
    }

    // 通过
    function testWithdraw(uint256 amount) public {
        vm.assume(amount < 0.1 ether); // 做假设
        payable(address(safe)).transfer(amount);
        uint256 preBalance = address(this).balance;
        safe.withdraw();
        uint256 postBalance = address(this).balance;
        assertEq(preBalance + amount, postBalance);
    }

}