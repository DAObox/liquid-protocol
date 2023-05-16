// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13;

import {console} from "forge-std/console.sol";
import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";

import {Utils} from "./utils/Utils.sol";

import {SetupVesting} from "./SetupVesting.t.sol";
import {VestingSchedule} from "../lib/Types.sol";
import {Errors} from "../lib/Errors.sol";

contract VestingTest is SetupVesting {
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

    /// Test for release() function
    function testRelease() public {
        // Arange:

        // Act:

        // Assert:
    }

    /// Test for release() function with invalid amount
    function testReleaseWithInvalidAmount() public {
        // Arange:

        // Act:

        // Assert:
    }

    // =============================================================== //
    // ===================== TRANSFER VESTING ======================== //
    // =============================================================== //

    /// Test for transferVesting() function
    function testTransferVesting() public {
        // Arange:

        // Act:

        // Assert:
    }

    /// Test for transferVesting() function by non-beneficiary
    function testTransferVestingByNonBeneficiary() public {
        // Arange:

        // Act:

        // Assert:
    }

    // =============================================================== //
    // =============== DELEGATE VESTED TOKENS ======================== //
    // =============================================================== //

    /// Test for delegateVestedTokens() function
    function testDelegateVestedTokens() public {
        // Arange:

        // Act:

        // Assert:
    }

    /// Test for delegateVestedTokens() function by non-beneficiary
    function testDelegateVestedTokensByNonBeneficiary() public {
        // Arange:

        // Act:

        // Assert:
    }

    // =============================================================== //
    // ======================== GET METHODS ========================== //
    // =============================================================== //

    /// Test for getToken() function
    function testGetToken() public {
        // Arange:

        // Act:

        // Assert:
    }

    /// Test for getSchedule() function
    function testGetSchedule() public {
        // Arange:

        // Act:

        // Assert:
    }

    /// Test for getWithdrawableAmount() function
    function testGetWithdrawableAmount() public {
        // Arange:

        // Act:

        // Assert:
    }

    // =============================================================== //
    // =============== COMPUTE RELEASABLE AMOUNT ===================== //
    // =============================================================== //

    /// Test for computeReleasableAmount() function
    function testComputeReleasableAmount() public {
        // Arange:

        // Act:

        // Assert:
    }

    /// Test for computeReleasableAmount() function before the cliff
    function testComputeReleasableAmountBeforeCliff() public {
        // Arange:

        // Act:

        // Assert:
    }

    /// Test for computeReleasableAmount() function after the vesting period
    function testComputeReleasableAmountAfterVestingPeriod() public {
        // Arange:

        // Act:

        // Assert:
    }

    /// Test for computeReleasableAmount() function during the vesting period
    function testComputeReleasableAmountDuringVestingPeriod() public {
        // Arange:

        // Act:

        // Assert:
    }

    // =============================================================== //
    // ====================== CURRENT TIME =========================== //
    // =============================================================== //

    /// Test for getCurrentTime() function
    function testGetCurrentTime() public {
        // Arange:

        // Act:

        // Assert:
    }
}
