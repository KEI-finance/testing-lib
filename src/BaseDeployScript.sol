// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import {Script} from "forge-std/Script.sol";
import {stdJson} from "forge-std/StdJson.sol";

abstract contract BaseDeployScript is Script {
    using stdJson for string;

    bytes32 salt;
    address public deployer;
    mapping(string => address) public deployment;

    modifier record() {
        vm.startBroadcast(deployer);

        _;

        // only record deployments on non testnets
        vm.stopBroadcast();
    }

    function setUp() public virtual {
        uint256 privateKey;
        if (block.chainid == 31337) {
            (, privateKey) = makeAddrAndKey("DEPLOYER");
        } else {
            privateKey = vm.envUint(string.concat("PRIVATE_KEY"));
        }
        deployer = vm.rememberKey(privateKey);
    }

    function getAddress(string memory name) internal view returns (address) {
        return getAddress(name, "", salt);
    }

    function getAddress(string memory name, bytes32 _salt) internal view returns (address) {
        return getAddress(name, "", _salt);
    }

    function getAddress(string memory name, bytes memory args) internal view returns (address) {
        return getAddress(name, args, salt);
    }

    function getAddress(string memory name, bytes memory args, bytes32 _salt) internal view returns (address) {
        bytes32 hash = hashInitCode(vm.getCode(name), args);
        return vm.computeCreate2Address(_salt, hash);
    }

    function deploy(string memory name) internal returns (address addr) {
        return deploy(name, "", true, salt);
    }

    function deploy(string memory name, bytes32 _salt) internal returns (address addr) {
        return deploy(name, "", true, _salt);
    }

    function deploy(string memory name, bool deployIfMissing) internal returns (address addr) {
        return deploy(name, "", deployIfMissing, salt);
    }

    function deploy(string memory name, bool deployIfMissing, bytes32 _salt) internal returns (address addr) {
        return deploy(name, "", deployIfMissing, _salt);
    }

    function deploy(string memory name, bytes memory args) internal returns (address addr) {
        return deploy(name, args, true, salt);
    }

    function deploy(string memory name, bytes memory args, bytes32 _salt) internal returns (address addr) {
        return deploy(name, args, true, _salt);
    }

    function deploy(string memory name, bytes memory args, bool deployIfMissing, bytes32 _salt)
        internal
        returns (address addr)
    {
        addr = getAddress(name, args, _salt);
        deployment[name] = addr;

        if (addr.code.length == 0) {
            require(deployIfMissing, string.concat("MISSING_CONTRACT_", name));

            bytes memory bytecode = abi.encodePacked(vm.getCode(name), args);

            assembly {
                addr := create2(0, add(bytecode, 0x20), mload(bytecode), _salt)
                if iszero(extcodesize(addr)) { revert(0, 0) }
            }
        }
    }

    function loadJson() internal returns (string memory key, string memory json) {
        string memory root = vm.projectRoot();
        string memory path = string.concat(root, "/config.json");
        json = vm.readFile(path);

        string[] memory envs = new string[](3);
        envs[0] = string.concat(".", vm.envOr(string("ENV"), string("local")));
        envs[1] = ".develop";
        envs[2] = "";

        string[] memory chains = new string[](2);
        chains[0] = string.concat(".", vm.toString(block.chainid));
        chains[1] = ".11155111";

        bool found = false;
        for (uint256 i = 0; i < envs.length; i++) {
            for (uint256 j = 0; j < chains.length; j++) {
                key = string.concat(envs[i], chains[j]);
                if (vm.keyExists(json, key)) {
                    found = true;
                    break;
                }
            }

            if (found) {
                break;
            }
        }

        if (!found) {
            revert(string.concat("CONFIG_NOT_FOUND: environment ", envs[0], " chain ", chains[0]));
        }

        if (vm.keyExists(json, string.concat(key, ".salt"))) {
            salt = bytes32(json.readUint(string.concat(key, ".salt")));
        }
    }
}
