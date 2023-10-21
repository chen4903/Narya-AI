// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./WETH.sol";
import "forge-std/Base.sol";
import "forge-std/StdCheats.sol";
import "forge-std/StdUtils.sol";

contract Handler is CommonBase, StdCheats, StdUtils{
    WETH public weth;
    uint256 public wethBalance;

    constructor(WETH _weth){
        weth = _weth;
    } 

    receive() external payable{}

    function sendToFallback(uint256 _amount) public{
        _amount = bound(_amount, 0, address(this).balance);
        wethBalance += _amount;
        (bool ok,) = address(weth).call{value: _amount}("");
        require(ok, "sendToFallback failed");
    }
    function deposit(uint256 _amount) public{
        _amount = bound(_amount, 0, address(this).balance);
        wethBalance += _amount;
        weth.deposit{value: _amount}();
    }
    function withdraw(uint256 _amount) public{
        _amount = bound(_amount, 0, weth.balanceOf(address(this)));
        wethBalance -= _amount;
        weth.withdraw(_amount);
    }
    function fail() public{
        revert("fail");
    }
}

contract WETH_Handler_Based_Invariant_Test is Test{
    WETH public weth;
    Handler public handler;

    function setUp() public{
        weth = new WETH();
        handler = new Handler(weth);

        deal(address(handler), 100*1e18);

        targetContract(address(handler));

        bytes4[] memory selectors = new bytes4[](3);
        selectors[0] = Handler.deposit.selector;
        selectors[1] = Handler.withdraw.selector;
        selectors[2] = Handler.sendToFallback.selector;
        // 写这个之前，必须写targetContract(address(handler));
        targetSelector(
            FuzzSelector({addr: address(handler), selectors: selectors})
        );
    }

    function invariant_eth_balance() public {
        assertGe(address(weth).balance, handler.wethBalance());
    }
}


