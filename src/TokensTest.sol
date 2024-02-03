// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";

import {ERC20Mock} from "./ERC20Mock.sol";

contract TokensTest is Test {
    ERC20Mock public USDC = new ERC20Mock("USD Coin", "USDC");
    ERC20Mock public USDT = new ERC20Mock("Tether USD", "USDT");
    ERC20Mock public WBTC = new ERC20Mock("Wrapped BTC", "WBTC");
    ERC20Mock public WMATC = new ERC20Mock("Wrapped MATC", "WMATIC");

    constructor() {
        vm.label(address(USDC), "USDC");
        vm.label(address(USDT), "USDT");
        vm.label(address(WBTC), "WBTC");
        vm.label(address(WMATC), "WMATC");
    }
}
