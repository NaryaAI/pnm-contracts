// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@pwnednomore/contracts/Agent.sol";
import "src/Token.sol";

contract ERC20TransferFromTest is Agent {
    address alice = address(0x927);
    Token token;

    function setUp() public {
        address owner = address(0x1);
        vm.startPrank(owner);
        token = new Token();
        token.transfer(alice, 50);
        vm.stopPrank();

        vm.prank(alice);
        token.approve(address(this), 20);
    }

    function testTransferFrom(uint256 amount) public {
        vm.assume(amount <= 20); // remove this in PNM engine.

        uint256 aliceBalance = token.balanceOf(alice);
        uint256 agentBalance = token.balanceOf(address(this));
        uint256 allowance = token.allowance(alice, address(this));

        token.transferFrom(alice, address(this), amount);

        assert(amount <= allowance);
        assert(token.balanceOf(alice) == aliceBalance - amount);
        assert(token.balanceOf(address(this)) == agentBalance + amount);
        assert(token.allowance(alice, address(this)) == allowance - amount);
    }
}
