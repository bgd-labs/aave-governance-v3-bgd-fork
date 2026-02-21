// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {WithPayloadsManager} from '../../src/contracts/payloads/WithPayloadsManager.sol';
import {Ownable} from 'openzeppelin-contracts/contracts/access/Ownable.sol';
import {PayloadTest} from './utils/PayloadTest.sol';
import {Test} from 'forge-std/Test.sol';

contract WithPayloadsManagerTest is Test {
  WithPayloadsManager _withPayloadsManager;

  address _deployer = address(45);
  address _owner = address(55);
  address _payloadsManager = address(65);

  function setUp() public {
    vm.startPrank(_deployer);
    _withPayloadsManager = new WithPayloadsManager();

    // setup ad-hoc roles and remove initial roles from deployer
    _withPayloadsManager.addPayloadsManager(_payloadsManager);
    _withPayloadsManager.removePayloadsManager(_deployer);
    _withPayloadsManager.transferOwnership(_owner);
    vm.stopPrank();
  }

  function testInitialRoles() external {
    vm.prank(_deployer);
    WithPayloadsManager withPayloadsManager_ = new WithPayloadsManager();

    assertTrue(withPayloadsManager_.isPayloadsManager(_deployer));
    assertEq(withPayloadsManager_.owner(), _deployer);
    assertEq(withPayloadsManager_.guardian(), _deployer);
  }

  function testAddPayloadsManager(address payloadsManager) external {
    vm.prank(_owner);
    _withPayloadsManager.addPayloadsManager(payloadsManager);

    assertTrue(_withPayloadsManager.isPayloadsManager(payloadsManager));
  }

  function testAddPayloadsManager_invalidCaller(address caller, address payloadsManager) external {
    vm.assume(caller != _owner);
    vm.prank(caller);

    vm.expectRevert(bytes(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, caller)));
    _withPayloadsManager.addPayloadsManager(payloadsManager);
  }

  function testRemovePayloadsManager() external {
    assertTrue(_withPayloadsManager.isPayloadsManager(_payloadsManager));

    vm.prank(_owner);
    _withPayloadsManager.removePayloadsManager(_payloadsManager);
    assertFalse(_withPayloadsManager.isPayloadsManager(_payloadsManager));
  }

  function testRemovePayloadsManager_invalidPayloadsManager(address invalidPayloadsManager) external {
    vm.assume(invalidPayloadsManager != _payloadsManager);
    assertFalse(_withPayloadsManager.isPayloadsManager(invalidPayloadsManager));

    vm.prank(_owner);
    // removing invalid payloadsManager does not revert
    _withPayloadsManager.removePayloadsManager(invalidPayloadsManager);
    assertFalse(_withPayloadsManager.isPayloadsManager(invalidPayloadsManager));
  }

  function testRemovePayloadsManager_invalidCaller(address caller) external {
    vm.assume(caller != _owner);
    vm.prank(caller);

    vm.expectRevert(bytes(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, caller)));
    _withPayloadsManager.removePayloadsManager(_payloadsManager);
  }
}
