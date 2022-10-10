// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@pwnednomore/contracts/PTest.sol";
import "src/Token.sol";

contract ERC20BalanceTest is PTest {
    Token token;

    address user;

    address public agent;

    function setUp(address _agent) public override {
        user = address(0x927);
        agent = _agent;

        token = new Token();
        token.transfer(user, 50);
    }

    function invariantBalanceShouldNotChange() public view {
        // User fund should be safe
        assert(token.balanceOf(user) == 50);
        // Hacker should not gain any fund in any way
        assert(token.balanceOf(agent) == 0);
    }
}