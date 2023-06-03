// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import { console } from "forge-std/console.sol";
import { IVotes } from "@openzeppelin/contracts/governance/utils/IVotes.sol";
import { stdStorage, StdStorage, Test } from "forge-std/Test.sol";
import { SafeMath } from "@openzeppelin/contracts/utils/math/SafeMath.sol";

import { Utils } from "./utils/Utils.sol";

import { SetupVesting } from "./SetupVesting.t.sol";
import { VestingSchedule } from "../src/lib/Types.sol";
import { Errors } from "../src/lib/Errors.sol";
import { Events } from "../src/lib/Events.sol";

contract VestingTest is SetupVesting {
    // using SafeMath for uint256;

    uint256 internal maxTransferAmount = 12e18;

    function setUp() public virtual override {
        SetupVesting.setUp();
        console.log("WhenTokenIsSetup");
    }

    // =============================================================== //
    // ========================= INITIALIZE ========================== //
    // =============================================================== //

    /// @dev Testing the initialization of the contract
    function testInitialize() public {
        // Arrange && Act
        setupVesting();

        // Assert
        assertEq(vesting.getToken(), address(token), "Token address mismatch");

        // Retrieve the schedule from the contract for comparison
        VestingSchedule memory actualSchedule = vesting.getSchedule();

        assertTrue(actualSchedule.initialized, "VestingSchedule not initialized");
        assertEq(actualSchedule.cliff, schedule.cliff, "Cliff value mismatch");
        assertEq(actualSchedule.start, schedule.start, "Start time mismatch");
        assertEq(actualSchedule.duration, schedule.duration, "Duration mismatch");
        assertEq(actualSchedule.slicePeriodSeconds, schedule.slicePeriodSeconds, "Slice period mismatch");
        assertTrue(actualSchedule.revocable == schedule.revocable, "Revocable flag mismatch");
        assertEq(actualSchedule.amountTotal, schedule.amountTotal, "Total amount mismatch");
        assertEq(actualSchedule.released, schedule.released, "Released amount mismatch");
        assertTrue(actualSchedule.revoked == schedule.revoked, "Revoked flag mismatch");

        assertEq(vesting.getWithdrawableAmount(), 1000 ether, "Withdrawable amount mismatch");
    }

    // =============================================================== //
    // =========================== REVOKE ============================ //
    // =============================================================== //

    /// Test for revoke() function
    function testRevoke() public {
        // Arange:
        setupVesting();

        // Act:
        vm.prank(dao);
        vesting.revoke(address(this));

        // Assert:
        assertEq(token.balanceOf(address(vesting)), 0);
        assertEq(token.balanceOf(address(this)), 1000 ether);
    }

    /// Test for revoke() function when not revocable
    function testRevoke_RevertWhenNotRevocable() public {
        // Arange:
        VestingSchedule memory nonRevokable = schedule;
        nonRevokable.revocable = false;
        token.mint(address(vesting), 1000 ether);
        vesting.initialize(dao, beneficiary, address(token), nonRevokable);

        // Act:
        vm.startPrank(dao);
        vm.expectRevert(Errors.VestingScheduleNotRevocable.selector);
        vesting.revoke(address(dao));
        // Assert:
    }

    // =============================================================== //
    // =========================== RELEASE =========================== //
    // =============================================================== //

    function testReleaseWithoutDelay() public {
        // Arrange
        setupVesting();
        uint256 amount = 100 gwei;
        uint256 releasableTokens = vesting.computeReleasableAmount();

        //Act
        vm.expectRevert(abi.encodeWithSelector(Errors.NotEnoughVestedTokens.selector, amount, releasableTokens));
        vesting.release(amount);
    }
    // /// Test for release() function

    function testRelease() public {
        // Arange:
        setupVesting();
        VestingSchedule memory schedule = vesting.getSchedule();
        uint256 initialBeneficiaryBalance = token.balanceOf(beneficiary);

        // Act:
        skip(1 days);
        uint256 releasableAmount = vesting.computeReleasableAmount();
        uint256 amount = releasableAmount / 1000;
        vesting.release(amount);
        VestingSchedule memory finalSchedule = vesting.getSchedule();

        // // Assert:
        console.log("Final Schedule", finalSchedule.released);
        assertEq(
            finalSchedule.released,
            schedule.released + amount,
            "Amount should be added to VestingSchedule released field"
        );
        assertEq(
            token.balanceOf(beneficiary),
            initialBeneficiaryBalance + amount,
            "Beneficary's balance should be increased by amount"
        );
    }

    /// Test for release() function with invalid amount
    function testReleaseWithInvalidAmount() public {
        // Arange:
        setupVesting();
        skip(1 days);

        // Act:
        /// Get the releasable amount
        uint256 releasableAmount = vesting.computeReleasableAmount();
        // pass an amount obviously greater
        uint256 amount = releasableAmount + 10;

        // Assert:
        vm.expectRevert(abi.encodeWithSelector(Errors.NotEnoughVestedTokens.selector, amount, releasableAmount));
        vesting.release(amount);
    }

    // // =============================================================== //
    // // ===================== TRANSFER VESTING ======================== //
    // // =============================================================== //

    // /// Test for transferVesting() function
    function testTransferVesting() public {
        // Arange:
        setupVesting();
        Utils utils = new Utils();
        address payable newBeneficiary = utils.getNextUserAddress();

        // Act:
        vm.prank(beneficiary);
        vesting.transferVesting(newBeneficiary);

        // Assert:
        assertEq(vesting.getBeneficiary(), newBeneficiary, "Beneficiary should be updated.");
    }

    // /// Test for transferVesting() function by non-beneficiary
    function testTransferVestingByNonBeneficiary() public {
        //  Arange:
        setupVesting();
        Utils utils = new Utils();
        address payable newBeneficiary = utils.getNextUserAddress();

        // Act:
        vm.expectRevert(abi.encodeWithSelector(Errors.OnlyBeneficiary.selector, address(this), beneficiary));
        vesting.transferVesting(newBeneficiary);
    }

    // // =============================================================== //
    // // =============== DELEGATE VESTED TOKENS ======================== //
    // // =============================================================== //

    // /// Test for delegateVestedTokens() function
    // function testDelegateVestedTokens() public {
    //     // Arange:
    //     setupVesting();
    //     Utils utils = new Utils();
    //     address user = utils.getNextUserAddress();

    //     // Act & Assert::
    //     vm.prank(beneficiary);
    //     vm.expectEmit(false, false, false, false);
    //     emit IVotes.DelegateVotesChanged(beneficiary, beneficiary, user);
    //     // address indexed delegator, address indexed fromDelegate, address indexed toDelegate
    //     vesting.delegateVestedTokens(user);
    // }

    // /// Test for delegateVestedTokens() function by non-beneficiary
    // function testDelegateVestedTokensByNonBeneficiary() public {
    //     // Arange:

    //     // Act:

    //     // Assert:
    // }

    // // =============================================================== //
    // // ======================== GET METHOD(S) ========================== //
    // // =============================================================== //

    // /// Test for getWithdrawableAmount() function
    function testGetWithdrawableAmount() public {
        // Arange:
        setupVesting();

        // Act:
        uint256 releasableAmount = vesting.computeReleasableAmount();
        uint256 vestingBalance = token.balanceOf(address(vesting));
        uint256 withdrawableAmount = vesting.getWithdrawableAmount();

        // Assert:
        assertEq(withdrawableAmount, vestingBalance - releasableAmount, "Withdrawable amount should match!");
    }

    // // =============================================================== //
    // // =============== COMPUTE RELEASABLE AMOUNT ===================== //
    // // =============================================================== //

    // /// Test for computeReleasableAmount() function
    function testComputeReleasableAmount() public {
        // Arange:
        setupVesting();
        uint256 initialReleasableAmount = vesting.computeReleasableAmount();
        VestingSchedule memory initialSchedule = vesting.getSchedule();
        // Act:

        skip(30 days);
        uint256 amountAfterCliff = vesting.computeReleasableAmount();

        skip(335 days);
        uint256 amountAfterDeadline = vesting.computeReleasableAmount();
        // Assert:
        assertEq(initialReleasableAmount, 0, "Should not be able to release any amount after initialize");
        assertTrue(amountAfterCliff > 0, "Some amount of vesting tokens must be released after cliff period");
        assertEq(
            amountAfterDeadline,
            initialSchedule.amountTotal - initialSchedule.released,
            "Can release all remaining tokens"
        );
    }

    // /// Test for computeReleasableAmount() function before the cliff
    function testComputeReleasableAmountBeforeCliff() public {
         // Arange:
            setupVesting();
            VestingSchedule memory schedule = vesting.getSchedule();
        // Assert:
        skip(schedule.cliff - 1 days);
        uint256 releasableAmount = vesting.computeReleasableAmount();

        // warp
        assertEq(releasableAmount, 0, "Should not be able to release any amount before cliff");
    }

    // // =============================================================== //
    // // ====================== CURRENT TIME =========================== //
    // // =============================================================== //

    // /// Test for getCurrentTime() function
    function testGetCurrentTime() public {
        // Arange:
        setupVesting();
        VestingSchedule memory schedule = vesting.getSchedule();
        // Act:
        uint256 currentTime = vesting.getCurrentTime();

        skip(30 days);
        uint256 twoDaysLater = vesting.getCurrentTime();

        skip(335 days);
        uint256 aYearLater = vesting.getCurrentTime();

        // Assert:
        assertEq(currentTime, schedule.start, "Current time should equal the schedule start time");
        assertEq(twoDaysLater, schedule.start + 2_592_000, "Current time should be 30 days later");
        assertEq(aYearLater, schedule.start + 31_536_000, "Current time should be 365 days later");
    }
}
