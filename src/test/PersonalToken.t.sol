// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13;

import {console} from "forge-std/console.sol";
import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";

import {Utils} from "./utils/Utils.sol";
import {LiquidToken} from "../tokens/LiquidToken.sol";
import {BaseSetup} from "./BaseSetup.t.sol";
import {CurveParameters} from "../lib/Types.sol";

contract LiquidTokenTest is BaseSetup {
    uint256 internal maxTransferAmount = 12e18;

    function setUp() public virtual override {
        BaseSetup.setUp();
        console.log("WhenTokenIsSetup");
    }

    function testSetup() public returns (bool) {
        assertEq(token.name(), "Khalid Coin");
        assertEq(token.reserveBalance(), 100e18);
        assertEq(token.symbol(), "KK");
        assertEq(token.getOwner(), owner);

        CurveParameters memory curve = token.getCurveParameters();
        assertEq(curve.fundingRate, 3000);
        assertEq(curve.exitFee, 420);
        assertEq(curve.reserveRatio, 300000, "reserveRatio");

        assertEq(token.totalSupply(), 1000e18, "totalSupply");
        assertEq(token.balanceOf(owner), 1000e18, "ownerBalance");

        return true;
    }

    function testCanMint() public returns (bool) {
        console.log("WhenMinting");
        assertEq(token.reserveBalance(), 100e18);
        assertEq(token.balanceOf(alice), 0);

        vm.startPrank(alice);
        token.mint{value: 1e18}();
        vm.stopPrank();

        // assertEq(token.balanceOf(alice), 27);
        // assertEq(token.totalSupply(), 1027);
        return true;
    }
}
