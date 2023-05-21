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
        // Hatch the market maker by sending $100,000 to the market maker.tx
        // the expected behaviour is for the $75k to go to the market maker where
        // 25K will go to the DAO as 25% theta has been set. The hatcher will choose
        // get all the initial tokens. Remember this should be another contract with
        // its own logic as to how to distribute these DAO tokens. The Hatcher chould
        // have no extra powers after the hatch.

        // Prank the hatcher and deploy the funding
        vm.startPrank(hatcher);
        console2.log("Hatcher $", externalToken.balanceOf(hatcher));
        externalToken.approve(address(marketMaker), 100_000 * TOKEN);
        marketMaker.hatch({ initialSupply: 100_000 * TOKEN, fundingAmount: 100_000 * TOKEN, hatchTo: hatcher });
        vm.stopPrank();

        // validate the hatch
        assertEq(governanceToken.totalSupply(), 100_000 * TOKEN, "HATCH TOKENS SHOULD BE 100_000");
        assertEq(governanceToken.balanceOf(hatcher), 100_000 * TOKEN, "HATCHER SHOULD HAVE 100K TOKENS");
        assertEq(externalToken.balanceOf(address(marketMaker)), 75_000 * TOKEN, "MARKET MAKER SHOULD HAVE 75_000 TKN");
        // ***TODO***: this is a great one for an invariant test
        // assertEq(externalToken.balanceOf(address(marketMaker)), marketMaker.reserveBalance(), "RESERVE == BALANCEOF");


        // assertTrue(marketMaker.isHatched(), "MARKET MAKER SHOULD BE HATCHED");

        // console2.log("===== continuous minting ======");
        // externalToken.approve(address(marketMaker), 10_000 * TOKEN);
        // marketMaker.mint(10_000 * TOKEN);
        // assertEq(externalToken.balanceOf(address(marketMaker)), 17_500 * TOKEN, "MARKET MAKER SHOULD HAVE 17_500USDC");
        // assertEq(externalToken.balanceOf(address(dao)), 17_500 * TOKEN, "MARKET MAKER SHOULD HAVE 17_500USDC");
        //
        // assertEq(externalToken.balanceOf(address(marketMaker)), marketMaker.reserveBalance(), "RESERVE == BALANCEOF");
    }
}
