// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.17 <0.9.0;

import { console2 } from "forge-std/console2.sol";

import { IBondedToken } from "../src/interfaces/IBondedToken.sol";
import { IntegrationBase } from "./IntegrationBase.sol";
import { Events } from "../src/lib/Events.sol";

/// @dev If this is your first time with Forge, see the "Writing Tests" tutorial in the Foundry Book.
/// https://book.getfoundry.sh/forge/writing-tests

contract Integration is IntegrationBase {
    /// @dev An optional function invoked before each test case is run.
    function setUp() public virtual override {
        super.setUp();
    }

    /// @dev Basic test. Run it with `-vvv` to see the console log.
    function test_protocol() external {
        console2.log("===== initial setup ======");
        console2.log("DAO Address", address(dao));
        console2.log("Market Maker Address", address(marketMaker));
        console2.log("Governance Token Address", address(governanceToken));
        console2.log("Voting Address", address(voting));
        console2.log("USDC Address", address(externalToken));
        console2.log("Hatch Admin Address", address(hatchAdmin));

        assertFalse(marketMaker.isHatched(), "MARKET MAKER SHOULD NOT BE HATCHED");
        assertEq(address(marketMaker.bondedToken()), (address(governanceToken)), "BONDED TOKEN");
        assertEq(governanceToken.totalSupply(), 0, "HATCH TOKENS SHOULD BE 0");
        assertTrue(
            dao.hasPermission(address(marketMaker), address(this), keccak256("HATCH_PERMISSION"), EMPTY_BYTES),
            "this contract can hatch"
        );

           console2.log("===== hatching ======");
        // mint tokens to the hatch admin which is this contract
        externalToken.mint(address(this), 100_000 * TOKEN);
        externalToken.transfer(address(marketMaker), 10_000 * TOKEN);

        vm.prank(address(marketMaker));
        governanceToken.mint(address(marketMaker), 10_000);

        // expect the hatch to emit a hatch event
        // vm.expectEmit(true, false, false, true, address(marketMaker));
        // emit Events.Hatch(address(this), 10_000 * TOKEN);
        // ***MINTING IS BROKEN IN HATCH***
        marketMaker.hatch(address(0), 10_000 * TOKEN);

        // validate the hatch
        assertEq(governanceToken.totalSupply(), 10_000, "HATCH TOKENS SHOULD BE 10_000");
        assertEq(externalToken.balanceOf(address(marketMaker)), 10_000 * TOKEN, "MARKET MAKER SHOULD HAVE 10_000 USDC");
        assertEq(externalToken.balanceOf(address(marketMaker)), marketMaker.reserveBalance(), "RESERVE == BALANCE OF");
        assertTrue(marketMaker.isHatched(), "MARKET MAKER SHOULD BE HATCHED");

        console2.log("===== continuous minting ======");
        externalToken.approve(address(marketMaker), 10_000 * TOKEN);
          marketMaker.mint(10_000 * TOKEN);
        assertEq(externalToken.balanceOf(address(marketMaker)), 20_000 * TOKEN, "MARKET MAKER SHOULD HAVE 10_000 USDC");
        assertEq(externalToken.balanceOf(address(marketMaker)), marketMaker.reserveBalance(), "RESERVE == BALANCE OF");
    }
}
