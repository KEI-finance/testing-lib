// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./BaseTest.t.sol";
import "./WETH9Mock.t.sol";

contract WETHTest is BaseTest {
    WETH9Mock public immutable WETH = new WETH9Mock();

    constructor() {
        vm.label(address(WETH), 'WETH');
    }

    function dealWETH(address to, uint256 amount) internal {
        vm.deal(address(WETH), amount);
        deal(address(WETH), to, amount);
    }
}
