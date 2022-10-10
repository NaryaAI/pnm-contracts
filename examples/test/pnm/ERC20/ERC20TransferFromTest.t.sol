// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@pwnednomore/contracts/PTest.sol";
import "src/Token.sol";

contract ERC20TransferFromTest is PTest {
    address alice = address(0x927);
    address agent;

    Token token;

    function setUp(address _agent) public override {
        agent = _agent;

        token = new Token();
        token.transfer(alice, 50);

        asAccountForNextCall(alice);
        token.approve(agent, 20);
    }

    function testTransferFrom(uint256 amount) public {
        uint256 aliceBalance = token.balanceOf(alice);
        uint256 agentBalance = token.balanceOf(agent);
        uint256 allowance = token.allowance(alice, agent);

        try token.transferFrom(alice, agent, amount) {
            assert(amount <= aliceBalance);
            assert(amount <= allowance);
            assert(token.balanceOf(alice) == aliceBalance - amount);
            assert(token.balanceOf(agent) == agentBalance + amount);
            assert(token.allowance(alice, agent) == allowance - amount);
        } catch {
            assert(token.balanceOf(alice) == aliceBalance);
            assert(token.balanceOf(agent) == agentBalance);
            assert(token.allowance(alice, agent) == allowance);
        }
    }
}
