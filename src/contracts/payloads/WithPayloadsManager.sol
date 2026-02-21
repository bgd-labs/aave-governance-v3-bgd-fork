// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IWithPayloadsManager} from './interfaces/IWithPayloadsManager.sol';
import {OwnableWithGuardian} from 'aave-delivery-infrastructure/contracts/old-oz/OwnableWithGuardian.sol';
import {AccessControlEnumerable} from 'openzeppelin-contracts/contracts/access/extensions/AccessControlEnumerable.sol';
import {WithPayloadsManagerLegacyStorage} from './WithPayloadsManagerLegacyStorage.sol';
import {Errors} from '../libraries/Errors.sol';

/**
 * @title WithPayloadsManager
 * @author BGD Labs
 * @dev Contract module which provides a basic access control mechanism, where
 * there are accounts (owner, guardian, and payloads manager) which can be granted
 * exclusive access to specific functions.
 * @notice By default, all the roles (owner, guardian, payloadsManager) will be assigned to the one that deploys the contract. This
 * can later be changed with appropriate functions.
 */
contract WithPayloadsManager is OwnableWithGuardian, IWithPayloadsManager, WithPayloadsManagerLegacyStorage, AccessControlEnumerable {
  /// @inheritdoc IWithPayloadsManager
  bytes32 public constant PAYLOADS_MANAGER_ROLE = keccak256('PAYLOADS_MANAGER');

  constructor() {
    _grantRole(PAYLOADS_MANAGER_ROLE, _msgSender());
  }

  modifier onlyPayloadsManager() {
    require(hasRole(PAYLOADS_MANAGER_ROLE, _msgSender()), Errors.ONLY_BY_PAYLOADS_MANAGER);
    _;
  }

  modifier onlyPayloadsManagerOrGuardian() {
    require(
      hasRole(PAYLOADS_MANAGER_ROLE, _msgSender()) || _msgSender() == guardian(),
      Errors.ONLY_BY_PAYLOADS_MANAGER_OR_GUARDIAN
    );
    _;
  }

  /// @inheritdoc IWithPayloadsManager
  function addPayloadsManager(address payloadsManager) external onlyOwner {
    _grantRole(PAYLOADS_MANAGER_ROLE, payloadsManager);
  }

  /// @inheritdoc IWithPayloadsManager
  function removePayloadsManager(address payloadsManager) external onlyOwner {
    _revokeRole(PAYLOADS_MANAGER_ROLE, payloadsManager);
  }

  /// @inheritdoc IWithPayloadsManager
  function isPayloadsManager(address payloadsManager) external view returns (bool) {
    return hasRole(PAYLOADS_MANAGER_ROLE, payloadsManager);
  }
}
