// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./RugPull.sol";

// https://www.levi104.com/2023/07/14/08.PoC/02.A%20mythical%20wild%20animal/

contract Attack is Test{
    Mike mike;
    function setUp() public{
        mike = new Mike("Mike Wazowski Monsters Inc", "MIKE", 0xF7E0d99511eab452bCBBdC34285E25F10E28F79D, 462000000000);
        targetContract(address(this));
        targetSender(address(0xF7E0d99511eab452bCBBdC34285E25F10E28F79D));

        // 这个会检测出来存在rugPull风险
        // 因为从合约结构上来看，是没有增发的功能的，并且在没有其他人approve给owner的情况下，随机调用函数，他的余额肯定是0不变，
        // 如果变化了，就说明存在增发的后门
        // 验证：去掉increaseAllowance()之后，测试就通过了，证明了这个函数就是后门函数
        bytes4[] memory selectors = new bytes4[](5);
        selectors[0] = this.transferFrom.selector;
        selectors[1] = this.transfer.selector;
        selectors[2] = this.approve.selector;
        selectors[3] = this.Approve.selector;
        selectors[4] = this.increaseAllowance.selector; 
        targetSelector(
            FuzzSelector({addr: address(this), selectors: selectors})
        );
    }

    // 为什么地址都填0xF7E0d99511eab452bCBBdC34285E25F10E28F79D呢？
    // 因为如果存在增发可能的话，假设增发给owner，我们就将获利设置为owner的地址，然后检测owner地址的余额是否变化
    function increaseAllowance(uint256 amount) public{
        mike.increaseAllowance(address(0xF7E0d99511eab452bCBBdC34285E25F10E28F79D), amount);
    }
    function transfer(uint256 amount) public{
        mike.transfer(address(0xF7E0d99511eab452bCBBdC34285E25F10E28F79D), amount);
    }
    function approve(uint256 amount) public{
        mike.approve(address(0xF7E0d99511eab452bCBBdC34285E25F10E28F79D), amount);
    }
    function Approve(uint256 amount) public{
        mike.Approve(address(0xF7E0d99511eab452bCBBdC34285E25F10E28F79D), amount);
    }
    function transferFrom(address addr, uint256 amount) public{
        mike.transferFrom(addr, address(0xF7E0d99511eab452bCBBdC34285E25F10E28F79D), amount);
    }

    // 这是RugPull的PoC
    // function test_demo() public{
    //     console.log("Before Rug Pull", mike.balanceOf(0xF7E0d99511eab452bCBBdC34285E25F10E28F79D));
    //     vm.startBroadcast(address(0xF7E0d99511eab452bCBBdC34285E25F10E28F79D));
    //     mike.increaseAllowance(0xF7E0d99511eab452bCBBdC34285E25F10E28F79D, 1262000000000000000000000000000000);
    //     console.log("After Rug Pull", mike.balanceOf(0xF7E0d99511eab452bCBBdC34285E25F10E28F79D));
    //     vm.stopBroadcast();
    // }

    function invariant_rugPull() public{
        // 需要尝试若干次，因为invariant测试的时候，参数未必就是将owner的地址作为输入，他是随机的，因此测试发现问题也是随机事件
        // [fuzz]
        // runs = 5000
        require(mike.balanceOf(0xF7E0d99511eab452bCBBdC34285E25F10E28F79D) == 0);
    }
}

