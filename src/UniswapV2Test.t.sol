// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";

import "./BaseTest.t.sol";
import "./WETHTest.sol";

contract UniswapV2Test is WETHTest {
    address public immutable FEE_TO_SETTER;

    IUniswapV2Factory public immutable uniswapV2Factory;
    IUniswapV2Router02 public immutable uniswapV2Router02;

    constructor() {
        FEE_TO_SETTER = makeAddr("FEE_TO_SETTER");
        uniswapV2Factory = IUniswapV2Factory(
            _deployArtifact(
                "/node_modules/@uniswap/v2-core/build/UniswapV2Factory.json",
                ".evm.bytecode.object",
                abi.encode(FEE_TO_SETTER),
                0
            )
        );

        uniswapV2Router02 = IUniswapV2Router02(
            _deployArtifact(
                "/node_modules/@uniswap/v2-periphery/build/UniswapV2Router02.json",
                ".evm.bytecode.object",
                abi.encode(uniswapV2Factory, address(weth)),
                0
            )
        );

        vm.label(address(uniswapV2Router02), "uniswapV2Router02");
        vm.label(address(uniswapV2Factory), "uniswapV2Factory");
        vm.label(FEE_TO_SETTER, "FEE_TO_SETTER");
    }
}
