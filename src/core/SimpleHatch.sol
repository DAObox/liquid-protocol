// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { IVotes } from "@openzeppelin/contracts/governance/utils/IVotes.sol";
import { Clones } from "@openzeppelin/contracts/proxy/Clones.sol";
import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { PluginCloneable, IDAO } from "@aragon/core/plugin/PluginCloneable.sol";

import { MarketMaker } from "./MarketMaker.sol";
import { Vesting } from "./Vesting.sol";
import { Errors } from "../lib/Errors.sol";
import { VestingSchedule, HatchStatus, HatchParameters } from "../lib/Types.sol";
import { Modifiers } from "../modifiers/SimpleHatch.sol";

// TODO
contract SimpleHatch is PluginCloneable, Modifiers {
    using Address for address;
    using Clones for address;

    address internal _vestingBase;

    HatchParameters internal _params;

    VestingSchedule internal _schedule;

    mapping(address => uint256) internal _contributions;

    event Contribute(address indexed contributor, uint256 amount);

    event Refund(address indexed contributor, uint256 amount);

    constructor() {
        _vestingBase = address(new Vesting());
    }

    function initialize(
        IDAO dao_,
        HatchParameters memory params_,
        VestingSchedule memory schedule_
    )
        external
        initializer
    {
        // validate enough tokens have been sent to the contract
        __PluginCloneable_init(dao_);
        _params = params_;
        _schedule = schedule_;
    }

    function contribute(uint256 _amount) external validateContribution(_params, _amount) {
        IERC20 token = IERC20(_params.externalToken);
        token.transferFrom(msg.sender, address(this), _amount);
        _contributions[msg.sender] += _amount;

        emit Contribute(msg.sender, _amount);
    }

    function refund() external validateRefund(_params, _contributions[msg.sender]) {
        IERC20 token = IERC20(_params.externalToken);
        uint256 amount = _contributions[msg.sender];
        _contributions[msg.sender] = 0;

        token.transferFrom(msg.sender, address(this), amount);

        emit Refund(msg.sender, amount);
    }

    function claimVesting() external {
        Vesting vesting = Vesting(_vestingBase.clone());
        VestingSchedule memory schedule = _schedule;

        uint256 amount = _contributions[msg.sender] * _params.initialPrice;
        _contributions[msg.sender] = 0;

        IERC20(address(_params.bondedToken)).transfer(address(vesting), amount);

        vesting.initialize(address(dao()), msg.sender, address(_params.bondedToken), schedule);
    }

    function hatch() external {
        //
    }

    function cancel() external {
        //
    }
}
