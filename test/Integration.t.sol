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
            dao.hasPermission(address(marketMaker), address(hatcher), keccak256("HATCH_PERMISSION"), EMPTY_BYTES),
            "this contract can hatch"
        );

        // // Check USDC Balances
        // assertEq(externalToken.balanceOf(address(marketMaker)), 97_500 * TOKEN, "MARKET MAKER SHOULD HAVE $82,000 ");
        // assertEq(externalToken.balanceOf(address(dao)), 32_500 * TOKEN, "MARKET MAKER SHOULD HAVE $27,500");
        // assertEq(externalToken.balanceOf(address(marketMaker)), marketMaker.reserveBalance(), "RESERVE ==BALANCEOF");
    }

    function test_hatch(uint256 initialMint, uint256 initialDeposit) external {
        initialMint = bound(initialMint, 100, uint256(~uint128(0)));
        initialDeposit = bound(initialDeposit, 100, uint256(~uint128(0)));
        uint256 expectedPoolUSDC = (initialDeposit * 75) / 100;

        hatch(initialMint, initialDeposit);

        assertTrue(marketMaker.isHatched(), "MARKET MAKER SHOULD BE HATCHED");
        assertEq(governanceToken.totalSupply(), initialMint, "HATCH TOKENS SHOULD BE 100_000");
        assertEq(governanceToken.balanceOf(hatcher), initialMint, "HATCHER SHOULD HAVE 100K TOKENS");
        assertApproxEqRel(
            externalToken.balanceOf(address(marketMaker)), expectedPoolUSDC, 1, "MARKET MAKER SHOULD HAVE 75_000 TKN"
        );
        assertEq(externalToken.balanceOf(address(marketMaker)), marketMaker.reserveBalance(), "RESERVE == BALANCEOF");
    }

    function test_mint(uint256 depositAmount) external {
        depositAmount = bound(depositAmount, 1, uint256(~uint128(0)));
        hatch();
        externalToken.mint(alice, 42_000 ether);

        assertEq(governanceToken.balanceOf(alice), 0, "ALICE SHOULD HAVE 0 TKN");

        uint256 aliceExpected = expectedPurchaseReturn(42_000 ether);
        console2.log("Alice Expected", aliceExpected);
        vm.startPrank(alice);
        externalToken.approve(address(marketMaker), ~uint256(0));
        marketMaker.mint(42_000 ether);
        vm.stopPrank();
        console2.log("Alice Actual  ", governanceToken.balanceOf(alice));

        assertEq(governanceToken.balanceOf(alice), aliceExpected, "ALICE SHOULD HAVE THIS MANY TKN");
    }

    function test_burn(uint256 tokensToBurn) external {
        hatch();
        tokensToBurn = bound(tokensToBurn, 1, governanceToken.balanceOf(hatcher));
        vm.prank(hatcher);
        governanceToken.transfer(address(bob), tokensToBurn);

        uint256 bobExpected = expectedSaleReturn(tokensToBurn);
        console2.log("Bob Expected", bobExpected);
        vm.startPrank(bob);
        governanceToken.approve(address(marketMaker), ~uint256(0));
        marketMaker.burn(tokensToBurn);
        vm.stopPrank();
        console2.log("Bob Actual  ", externalToken.balanceOf(bob));
        assertApproxEqRelDecimal(externalToken.balanceOf(bob), bobExpected, 1, 16, "BOB SHOULD HAVE THIS MANY USDC");
    }
}
