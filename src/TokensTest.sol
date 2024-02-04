// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";

import {ERC20Mock} from "./ERC20Mock.sol";
import {ERC20Mock} from "./ERC20Mock.sol";

contract TokensTest is Test {
    IERC20 public USDC = IERC20(address(new ERC20Mock("USD Coin", "USDC")));
    IERC20 public USDT = IERC20(address(new ERC20Mock("Tether USD", "USDT")));
    IERC20 public WBTC = IERC20(address(new ERC20Mock("Wrapped BTC", "WBTC")));
    IERC20 public WMATC = IERC20(address(new ERC20Mock("Wrapped MATC", "WMATIC")));

    constructor() {
        vm.label(address(USDC), "USDC");
        vm.label(address(USDT), "USDT");
        vm.label(address(WBTC), "WBTC");
        vm.label(address(WMATC), "WMATC");
    }
}
