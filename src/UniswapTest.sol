// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {UniswapV2Test} from "./UniswapV2Test.sol";
import {UniswapV3Test} from "./UniswapV3Test.sol";

contract UniswapTest is UniswapV2Test, UniswapV3Test {}
