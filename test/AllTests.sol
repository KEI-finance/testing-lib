// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {UniswapTest} from "src/UniswapTest.sol";
import {ERC1820Test} from "src/ERC1820Test.sol";

contract AllTests is UniswapTest, ERC1820Test {
    function test_create() external {
        assertGt(ERC1820Address.code.length, 0);
    }
}
