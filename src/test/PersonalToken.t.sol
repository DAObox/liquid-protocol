// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13;

// import {console} from "forge-std/console.sol";
// import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";

// import {Utils} from "./utils/Utils.sol";
// import {LiquidToken} from "../tokens/LiquidToken.sol";
// import {BaseSetup} from "./BaseSetup.t.sol";
// import {CurveParameters} from "../lib/Types.sol";

// contract LiquidTokenTest is BaseSetup {
//     uint256 internal maxTransferAmount = 12e18;

//     function setUp() public virtual override {
//         BaseSetup.setUp();
//         console.log("WhenTokenIsSetup");
//     }

//     function testSetup() public returns (bool) {
//         assertEq(token.name(), "Khalid Coin");
//         assertEq(token.reserveBalance(), 0);
//         assertEq(token.symbol(), "KK");
//         assertEq(token.getOwner(), owner);

//         CurveParameters memory curve = token.getCurveParameters();
//         assertEq(curve.fundingRate, 3000);
//         assertEq(curve.exitFee, 420);
//         assertEq(curve.reserveRatio, 300000, "reserveRatio");

//         assertEq(token.totalSupply(), 0, "totalSupply");
//         assertEq(token.balanceOf(owner), 0, "ownerBalance");

//         openTrading();

//         assertEq(token.reserveBalance(), 100 ether);
//         return true;
//     }

//     function testCanMint() public returns (bool) {
//         console.log("WhenMinting");
//         assertEq(token.reserveBalance(), 0);
//         assertEq(token.balanceOf(alice), 0);

//         address[] memory seedAddresses;
//         uint256[] memory values;

//         seedAddresses[0] = owner;
//         values[0] = 100e18;

//         openTrading();

//         vm.startPrank(alice);
//         token.mint{value: 1 ether}();
//         vm.stopPrank();

//         // assertEq(token.balanceOf(alice), 27);
//         // assertEq(token.totalSupply(), 1027);
//         return true;
//     }

//     // function testCanBurn() public {
//     //     console.log("WhenBurning");
//     //     vm.prank(owner);
//     //     _setUpTrading();

//     //     uint256 initialAliceBalance = token.balanceOf(alice);
//     //     uint256 burnAmount = initialAliceBalance / 2;

//     //     vm.startPrank(alice);
//     //     token.burn(burnAmount);
//     //     vm.stopPrank();

//     //     uint256 expectedAliceBalance = initialAliceBalance - burnAmount;
//     //     assertEq(token.balanceOf(alice), expectedAliceBalance);
//     // }

//     // function testCanSponsoredMint() public {
//     //     console.log("WhenSponsoredMinting");
//     //     vm.prank(owner);
//     //     _setUpTrading();

//     //     uint256 initialOwnerBalance = token.balanceOf(owner);
//     //     uint256 sponsoredMintAmount = 1 ether;

//     //     vm.startPrank(alice);
//     //     token.sponsoredMint{value: sponsoredMintAmount}();
//     //     vm.stopPrank();

//     //     uint256 expectedOwnerBalance = initialOwnerBalance + token.calculateMint(sponsoredMintAmount);
//     //     assertEq(token.balanceOf(owner), expectedOwnerBalance);
//     // }

//     // function testCanSponsoredBurn() public {
//     //     console.log("WhenSponsoredBurning");
//     //     vm.prank(owner);
//     //     _setUpTrading();

//     //     uint256 initialAliceBalance = token.balanceOf(alice);
//     //     uint256 sponsoredBurnAmount = initialAliceBalance / 2;

//     //     vm.startPrank(alice);
//     //     token.sponsoredBurn(sponsoredBurnAmount);
//     //     vm.stopPrank();

//     //     uint256 expectedAliceBalance = initialAliceBalance - sponsoredBurnAmount;
//     //     assertEq(token.balanceOf(alice), expectedAliceBalance);
//     // }

//     // function _setUpTrading() internal {
//     //     address[] memory seedAddresses = new address[](1);
//     //     uint256[] memory values = new uint256[](1);
//     //     seedAddresses[0] = owner;
//     //     values[0] = 100 ether;
//     //     token.openTrading{value: 1 ether}(seedAddresses, values);

//     //     vm.startPrank(alice);
//     //     token.mint{value: 1 ether}();
//     //     vm.stopPrank();
//     // }
// }
