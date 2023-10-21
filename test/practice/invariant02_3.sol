// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "./WETH.sol";
import "forge-std/Base.sol";
import "forge-std/StdCheats.sol";
import "forge-std/StdUtils.sol";
import {Handler} from "./invariant02_2.sol";

contract ActorManager is CommonBase, StdCheats, StdUtils{
    Handler[] public handlers;
    constructor(Handler[] memory _handlers) {
        handlers = _handlers;
    }

    function sendToFallback(uint256 handlerIndex, uint256 _amount) public{
        uint index = bound(handlerIndex,0, handlers.length - 1);
        handlers[index].sendToFallback(_amount);
    }

    function deposit(uint256 handlerIndex, uint256 _amount) public{
        uint index = bound(handlerIndex,0, handlers.length - 1);
        handlers[index].deposit(_amount);
    }

    function withdraw(uint256 handlerIndex, uint256 _amount) public{
        uint index = bound(handlerIndex,0, handlers.length - 1);
        handlers[index].withdraw(_amount);
    }
}

contract WETH_Multi_Handler_Invariant_Tests is Test{
    WETH public weth;
    ActorManager public manager;
    Handler[] public handlers;

    function setUp() public{
        weth = new WETH();
        for(uint256 i = 0; i < 3; i++){
            handlers.push(new Handler(weth));
            deal(address(handlers[i]), 100*1e18);
        }
        manager = new ActorManager(handlers);
        targetContract(address(manager));
    }

    function invariant_eth_balance() public {
        uint256 total = 0;
        for(uint256 i = 0; i < handlers.length - 1;i++){
            total += handlers[i].wethBalance();
        }
        console.log("ETH total", total / 1e18);
        assertEq(address(weth).balance, total);
    }
}




