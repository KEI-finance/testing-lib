// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./BaseTest.t.sol";
import "./WETH9Mock.t.sol";

contract WETHTest is BaseTest {
    WETH9Mock public immutable weth = new WETH9Mock();

    constructor() {
        vm.label(address(weth), "WETH");
    }

    function dealWETH(address to, uint256 amount) internal {
        vm.deal(address(weth), amount);
        deal(address(weth), to, amount);
    }
}
