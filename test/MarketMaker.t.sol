// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import { Clones } from "@openzeppelin/contracts/proxy/Clones.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { console } from "forge-std/console.sol";

import { GovernanceBurnableERC20 } from "../src/core/GovernanceBurnableERC20.sol";
import { IntegrationBase } from "./IntegrationBase.sol";
import { MarketMaker } from "../src/core/MarketMaker.sol";

contract MarketMakerTest is IntegrationBase {
    using Clones for address;

    IERC20 public immutable external_token = IERC20(createNamedUser("EXTERNAL_TOKEN"));

    function setUp() public virtual override {
        super.setUp();
    }

    function Initialize_Market_Maker() external {
        MarketMaker marketMakerClone = MarketMaker(address(marketMaker).clone());
        marketMakerClone.initialize(dao, governanceToken, external_token, curveParams);
        // console.log("Market Clone Token: ", marketMakerClone.externalToken());
        // console.log("External_Token: ", external_token);
        // assertEq(marketMakerClone.externalToken(), external_token);
    }
}
