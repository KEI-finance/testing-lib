// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {ISwapRouter} from "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import {IUniswapV3Factory} from "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";
import {INonfungiblePositionManager} from "./interfaces/INonfungiblePositionManager.sol";
import {IQuoter} from "@uniswap/v3-periphery/contracts/interfaces/IQuoter.sol";
import {TickMath} from "./libraries/TickMath.sol";

import {WETHTest} from "./WETHTest.sol";
import {TokensTest} from "./TokensTest.sol";

contract UniswapV3Test is WETHTest, TokensTest {
    using Math for uint256;
    using SafeCast for uint256;

    IUniswapV3Factory public immutable uniswapV3Factory;
    ISwapRouter public immutable uniswapV3Router;
    IQuoter public immutable uniswapV3Quoter;
    INonfungiblePositionManager public immutable uniswapV3PositionManager;

    address public immutable USDC_WETH;
    address public immutable USDT_WETH;
    address public immutable USDT_WBTC;
    //    address public immutable USDC_WBTC;
    address public immutable WETH_WBTC;

    constructor() {
        uniswapV3Factory = IUniswapV3Factory(
            _deployArtifact(
                "/node_modules/@uniswap/v3-core/artifacts/contracts/UniswapV3Factory.sol/UniswapV3Factory.json",
                ".bytecode",
                "0x",
                0
            )
        );

        uniswapV3Router = ISwapRouter(
            _deployArtifact(
                "/node_modules/@uniswap/v3-periphery/artifacts/contracts/SwapRouter.sol/SwapRouter.json",
                ".bytecode",
                abi.encode(address(uniswapV3Factory), address(WETH)),
                0
            )
        );

        uniswapV3Quoter = IQuoter(
            _deployArtifact(
                "/node_modules/@uniswap/v3-periphery/artifacts/contracts/lens/Quoter.sol/Quoter.json",
                ".bytecode",
                abi.encode(address(uniswapV3Factory), address(WETH)),
                0
            )
        );

        //        address tokenDescriptor = _deployArtifact(
        //            "/node_modules/@uniswap/v3-periphery/artifacts/contracts/NonfungibleTokenPositionDescriptor.sol/NonfungibleTokenPositionDescriptor.json",
        //            ".bytecode",
        //            abi.encode(address(WETH), bytes32('TEST')),
        //            0
        //        );

        uniswapV3PositionManager = INonfungiblePositionManager(
            _deployArtifact(
                "/node_modules/@uniswap/v3-periphery/artifacts/contracts/NonfungiblePositionManager.sol/NonfungiblePositionManager.json",
                ".bytecode",
                abi.encode(address(uniswapV3Factory), address(WETH), address(0)),
                0
            )
        );

        vm.label(address(uniswapV3Router), "uniswapV3Router");
        vm.label(address(uniswapV3Factory), "uniswapV3Factory");
        vm.label(address(uniswapV3Quoter), "uniswapV3Quoter");
        vm.label(address(uniswapV3PositionManager), "uniswapV3PositionManager");

        // Fee ranges from 500, 3000, 10_0000

        (USDC_WETH,,,,) = addUniswapV3Liquidity(address(USDC), address(WETH), 500, 1_000e18, 2_000_000e18);

        (USDT_WETH,,,,) = addUniswapV3Liquidity(address(USDT), address(WETH), 500, 1_000e18, 2_000_000e18);

        //        (USDC_WBTC,,,,) = addUniswapV3Liquidity(address(USDC), address(WBTC), 500, 1_000e18, 45_000_000e18);

        (USDT_WBTC,,,,) = addUniswapV3Liquidity(address(USDT), address(WBTC), 500, 1_000e18, 45_000_000e18);

        (WETH_WBTC,,,,) = addUniswapV3Liquidity(address(WETH), address(WBTC), 10_000, 1_000e18, 20_000e18);
    }

    function addUniswapV3Liquidity(address tokenA, address tokenB, uint24 fee, uint256 reservesA, uint256 reservesB)
        internal
        returns (address pool, uint256 tokenId, uint128 liquidity, uint256 amount0, uint256 amount1)
    {
        INonfungiblePositionManager.MintParams memory params;

        {
            (params.token0, params.amount0Desired, params.token1, params.amount1Desired) =
                (tokenA < tokenB) ? (tokenA, reservesA, tokenB, reservesB) : (tokenB, reservesB, tokenA, reservesA);

            pool = uniswapV3PositionManager.createAndInitializePoolIfNecessary(
                params.token0, params.token1, fee, calculateSqrtPriceX96(params.amount0Desired, params.amount1Desired)
            );

            int24 tickSpacing = uniswapV3Factory.feeAmountTickSpacing(fee);
            params.deadline = block.timestamp;
            params.recipient = address(this);
            params.fee = fee;
            params.deadline = block.timestamp;
            params.tickLower = (TickMath.MIN_TICK / tickSpacing) * tickSpacing;
            params.tickUpper = (TickMath.MAX_TICK / tickSpacing) * tickSpacing;
        }

        deal(params.token0, address(this), params.amount0Desired);
        deal(params.token1, address(this), params.amount1Desired);

        IERC20(params.token0).approve(address(uniswapV3PositionManager), params.amount0Desired);
        IERC20(params.token1).approve(address(uniswapV3PositionManager), params.amount1Desired);

        (tokenId, liquidity, amount0, amount1) = uniswapV3PositionManager.mint(params);
    }

    function calculateSqrtPriceX96(uint256 reserves0, uint256 reserves1) internal pure returns (uint160 sqrtPriceX96) {
        require(reserves0 > 0, "Token1 amount must be greater than 0");

        // Calculate price ratio of token0 to token1 with 18 decimal places
        uint256 priceRatio = (reserves1 * 1e18) / reserves0;

        // Convert price ratio to 96-bit precision fixed-point number
        uint256 priceRatioX96 = priceRatio.sqrt() * 2 ** 96 / uint256(1e18).sqrt();

        // Calculate square root of the price ratio in 96-bit precision
        sqrtPriceX96 = priceRatioX96.toUint160();
    }
}
