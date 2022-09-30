// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Notice that if target contract uses hardhat console
// it could conflict with our Agent contract's console.
// You have two options:
// 1. Use our console version everywhere
// 2. Use explicit symbol import here like `import {Symbol} from "contract";`
import "@pwnednomore/contracts/Agent.sol";
import {VulnerableDoor} from "src/VulnerableDoor.sol";

contract BasicTest is Agent {
    VulnerableDoor target;

    function setUp() public {
        target = new VulnerableDoor();
    }

    function invariant() external {
        require(!target.stolen(), "stolen");
        console.log("Test success");
    }
}