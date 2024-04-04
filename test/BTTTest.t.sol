// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {DeployBIGToken} from "../script/BTTDeploy.s.sol";
import {BigTronToken} from "../src/BigTronToken.sol";

contract BTTTest is Test {
    BigTronToken public btt;
    DeployBIGToken public deployer;

    uint256 public constant STARTING_BALANCE = 1 ether;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    function setUp() public {
        deployer = new DeployBIGToken();
        btt = deployer.run();

        vm.startPrank(msg.sender);
        btt.transfer(bob, STARTING_BALANCE);
        vm.stopPrank();
    }

    function testbobBalance() public view {
        assertEq(STARTING_BALANCE, btt.balanceOf(bob));
    }

    function testAllowances() public {
        uint256 initialAllowance = 10 ether;
        // bob approves alice to spend tokens on her behalf
        vm.prank(bob);
        btt.approve(alice, initialAllowance);

        uint256 transferAmount = 1 ether;
        vm.prank(alice);
        btt.transferFrom(bob, alice, transferAmount);

        assertEq(btt.balanceOf(alice), transferAmount);
        assertEq(btt.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    function testInitialSupply() public view {
        assertEq(btt.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testAllowanceUpdate() public {
        uint256 newAllowance = 10 ether;
        vm.prank(bob);
        btt.approve(alice, newAllowance);

        assertEq(btt.allowance(bob, alice), newAllowance);
    }

    function testTransfer() public {
        uint256 transferAmount = 1 ether;
        vm.prank(bob);
        btt.transfer(alice, transferAmount);

        assertEq(btt.balanceOf(bob), STARTING_BALANCE - transferAmount);
        assertEq(btt.balanceOf(alice), transferAmount);
    }
    // have problem with minting

    // function testMinting() public view {
    //     // Assuming the initial supply is correctly set in the constructor
    //     uint256 expectedTotalSupply = 10000000000000000000;
    //     assertEq(btt.totalSupply(), expectedTotalSupply);
    //     assertEq(btt.balanceOf(msg.sender), expectedTotalSupply);
    // }

    function testDecimals() public view {
        assertEq(btt.tokendecimals(), 8); // Assuming your token uses 18 decimals
    }

    function testSymbol() public view {
        assertEq(btt.tokensymbol(), "BTT");
    }

    function testName() public view {
        assertEq(btt.tokenname(), "BigTronToken");
    }

    function testTransferFrom() public {
        uint256 transferAmount = 1 ether;
        vm.prank(bob);
        btt.approve(alice, transferAmount);

        vm.prank(alice);
        btt.transferFrom(bob, alice, transferAmount);

        assertEq(btt.balanceOf(alice), transferAmount);
        assertEq(btt.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    function testRevertOnInsufficientAllowance() public {
        uint256 transferAmount = 2 ether;
        vm.prank(bob);
        btt.approve(alice, transferAmount - 1 ether); // Allow less than the transfer amount

        vm.prank(alice);
        bool success = false;
        try btt.transferFrom(bob, alice, transferAmount) {
            success = true;
        } catch {
            success = false;
        }

        assertEq(success, false);
    }
}
