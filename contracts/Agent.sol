// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./forge-std/Test.sol";

struct Call {
    address to;
    bytes callData;
}

contract Agent is Test {
    event RevertedCall(bytes4 selector, uint256 index);

    bytes4 internal constant MAIN = bytes4(0x41414141);
    bytes4 internal constant FALLBACK = bytes4(0x00000000);
    bytes4 internal constant ON_ERC721_RECEIVED = bytes4(0x150b7a02);

    function main(Call[] calldata calls) external {
        uint256 i;
        for (i = 0; i < calls.length; i++) {
            (bool success, ) = calls[i].to.call(calls[i].callData);
            if (success) {
                this.check();
            } else {
                emit RevertedCall(MAIN, i);
                return;
            }
        }
    }

    function _callback(bytes4 selector, Call[] calldata calls) internal {
        uint256 i;
        for (i = 0; i < calls.length; i++) {
            (bool success, ) = calls[i].to.call(calls[i].callData);
            if (!success) {
                emit RevertedCall(selector, i);
                return;
            }
        }
    }

    function onERC721Received(Call[] calldata calls) external returns (bytes4) {
        _callback(ON_ERC721_RECEIVED, calls);
        return ON_ERC721_RECEIVED;
    } 

    function fallback(Call[] calldata calls) external payable {
        _callback(FALLBACK, calls);
    }

    function callback(bytes4 selector, Call[] calldata calls) external {
        _callback(selector, calls);
    }

    function check() external virtual {}
}
