# Kei Finance Testing Library

A comprehensive testing library for Ethereum smart contracts, featuring pre-configured setups for Uniswap V2/V3 testing environments.

## Features

- Pre-configured Uniswap V2 and V3 testing environments
- Mock ERC20 tokens and WETH implementations
- Base testing utilities for common testing scenarios
- Foundry-compatible testing framework

## Installation

```
yarn add @kei.fi/testing-lib
```

## Usage

### Basic Test Setup

Inherit from the base test contracts to access testing utilities:

```
import {BaseTest} from "@kei.fi/testing-lib/BaseTest.sol";

contract MyTest is BaseTest {
    function testSomething() public {
        // Your test code here
    }
}
```

### Uniswap Testing

For Uniswap-specific testing, use the pre-configured environments:

```
import {UniswapTest} from "@kei.fi/testing-lib/UniswapTest.sol";

contract MyUniswapTest is UniswapTest {
    function testUniswapInteraction() public {
        // Access pre-deployed Uniswap contracts
        // uniswapV2Factory, uniswapV2Router02, uniswapV3Factory, etc.
    }
}
```

## Key Components

1. **Base Testing**
   - BaseTest.sol: Core testing utilities
   - TokensTest.sol: Mock ERC20 token implementations
   - WETHTest.sol: WETH9 mock implementation

2. **Uniswap Integration**
   - UniswapV2Test.sol: Uniswap V2 testing environment
   - UniswapV3Test.sol: Uniswap V3 testing environment
   - Pre-deployed pools and routers

3. **Deployment Scripts**
   - BaseDeployScript.sol: Base deployment utilities
   - Configurable deployment environments

## Development

### Prerequisites

- Foundry
- Node.js
- Yarn

### Setup

1. Clone the repository
2. Install dependencies:
```
yarn install
```

3. Run tests:
```
forge test
```

## License

MIT License

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.