// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import "forge-std/Script.sol";

import "../src/BtcPrism.sol";
import "../src/BtcTxVerifier.sol";

contract DeployBtcPrism is Script {
    /**
     * @notice Deploys BtcPrism and BtcTxVerifier, tracking either mainnet or
     *         testnet Bitcoin.
     */
    function run(bool mainnet) external {
        vm.broadcast();

        // Deploy BtcPrism
        BtcPrism prism;
        if (mainnet) {
            // ...tracking Bitcoin mainnet, starting at block 739000
            prism = new BtcPrism(
                739000,
                hex"00000000000000000001059a330a05e66e4fa2d1a5adcd56d1bfefc5c114195d",
                1654182075,
                hex"206a0917", // nBits of period 366
                1653490985, // time of block 737856, first of period 366
                false
            );
        } else {
            // ...tracking Bitcoin testnet, starting at block 2315360
            prism = new BtcPrism(
                2315360,
                hex"0000000000000022201eee4f82ca053dfbc50d91e76e9cbff671699646d0982c",
                1659901500,
                hex"c0233719",
                0, // unused: testnet difficulty is unchecked
                true
            );
        }

        // Deploy the transaction verifier
        new BtcTxVerifier(prism);

        vm.stopBroadcast();
    }
}
