// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";

import "./WETHTest.sol";

contract UniswapV3Test is WETHTest {
    IUniswapV3Factory public immutable UNISWAP_V3_FACTORY;
    ISwapRouter public immutable SWAP_ROUTER;

    constructor() {
        UNISWAP_V3_FACTORY = IUniswapV3Factory(
            _deployArtifact(
                "/node_modules/@uniswap/v3-core/artifacts/contracts/UniswapV3Factory.sol/UniswapV3Factory.json",
                ".bytecode",
                "0x",
                0
            )
        );

        SWAP_ROUTER = ISwapRouter(
            _deployArtifact(
                "/node_modules/@uniswap/v3-periphery/artifacts/contracts/SwapRouter.sol/SwapRouter.json",
                ".bytecode",
                abi.encode(address(UNISWAP_V3_FACTORY), address(WETH)),
                0
            )
        );

        vm.label(address(SWAP_ROUTER), "SWAP_ROUTER");
        vm.label(address(UNISWAP_V3_FACTORY), "UNISWAP_V3_FACTORY");
    }
}
