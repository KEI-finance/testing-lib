// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";

import "./WETHTest.sol";

contract UniswapV3Test is WETHTest {
    IUniswapV3Factory public immutable uniswapV3Factory;
    ISwapRouter public immutable swapRouter;

    constructor() {
        uniswapV3Factory = IUniswapV3Factory(
            _deployArtifact(
                "/node_modules/@uniswap/v3-core/artifacts/contracts/UniswapV3Factory.sol/UniswapV3Factory.json",
                ".bytecode",
                "0x",
                0
            )
        );

        swapRouter = ISwapRouter(
            _deployArtifact(
                "/node_modules/@uniswap/v3-periphery/artifacts/contracts/SwapRouter.sol/SwapRouter.json",
                ".bytecode",
                abi.encode(address(uniswapV3Factory), address(weth)),
                0
            )
        );

        vm.label(address(swapRouter), "swapRouter");
        vm.label(address(uniswapV3Factory), "uniswapV3Factory");
    }
}
