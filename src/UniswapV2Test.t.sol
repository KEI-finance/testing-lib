// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "test/mocks/WETH9Mock.sol";

import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";

import "./BaseTest.t.sol";

contract UniswapV2Test is BaseTest {
    WETH9Mock immutable WETH;
    IUniswapV2Factory immutable UNISWAP_V2_FACTORY;
    IUniswapV2Router02 immutable UNISWAP_V2_ROUTER;
    address immutable FEE_TO_SETTER;

    constructor() {
        FEE_TO_SETTER = makeAddr("FEE_TO_SETTER");
        WETH = new WETH9Mock();
        UNISWAP_V2_FACTORY = IUniswapV2Factory(
            _deployArtifact(
                "/node_modules/@uniswap/v2-core/build/UniswapV2Factory.json",
                ".evm.bytecode.object",
                abi.encode(FEE_TO_SETTER),
                0
            )
        );

        UNISWAP_V2_ROUTER = IUniswapV2Router02(
            _deployArtifact(
                "/node_modules/@uniswap/v2-periphery/build/UniswapV2Router02.json",
                ".evm.bytecode.object",
                abi.encode(UNISWAP_V2_FACTORY, address(WETH)),
                0
            )
        );

        vm.label(address(WETH), "WETH");
        vm.label(address(UNISWAP_V2_ROUTER), "UNISWAP_V2_ROUTER");
        vm.label(address(UNISWAP_V2_FACTORY), "UNISWAP_V2_FACTORY");
        vm.label(FEE_TO_SETTER, "FEE_TO_SETTER");
    }

    function dealWETH(address to, uint256 amount) internal {
        vm.deal(address(WETH), amount);
        deal(address(WETH), to, amount);
    }
}
