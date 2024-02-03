// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, stdJson} from "forge-std/Test.sol";

import {Create2} from "@openzeppelin/contracts/utils/Create2.sol";

contract BaseTest is Test {
    using stdJson for string;

    address ALICE = makeAddr("ALICE");
    address BOB = makeAddr("BOB");
    address FRED = makeAddr("FRED");

    constructor() {
        vm.deal(ALICE, 10 ether);
        vm.deal(FRED, 10 ether);
        vm.deal(BOB, 10 ether);
    }

    function _deployArtifact(string memory file, bytes memory args, bytes32 salt) internal returns (address) {
        return _deployArtifact(file, ".bytecode", args, salt);
    }

    function _deployArtifact(string memory file, string memory key, bytes memory args, bytes32 salt)
        internal
        returns (address)
    {
        string memory root = vm.projectRoot();
        string memory path = string.concat(root, file);
        string memory json = vm.readFile(path);

        return Create2.deploy(0, salt, abi.encodePacked(json.readBytes(key), args));
    }
}
