// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IWithPayloadsManager
 * @author BGD Labs
 * @notice interface containing the methods definitions of the IWithPayloadsManager contract
 */
interface IWithPayloadsManager {
  /**
   * @notice Returns the identifier of the PayloadsManager role
   * @return The id of the PayloadsManager role
   */
  function PAYLOADS_MANAGER_ROLE() external view returns (bytes32);

  /**
   * @notice Grants the PayloadsManager role to the given address
   * @dev Only callable by the contract owner
   * @param payloadsManager The address to be granted the PayloadsManager role
   */
  function addPayloadsManager(address payloadsManager) external;

  /**
   * @notice Revokes the PayloadsManager role from the given address
   * @dev Only callable by the contract owner
   * @param payloadsManager The address to have the PayloadsManager role removed
   */
  function removePayloadsManager(address payloadsManager) external;

  /**
   * @notice Checks whether the given address holds the PayloadsManager role
   * @param payloadsManager The address to check
   * @return True if the address has the PayloadsManager role, false otherwise
   */
  function isPayloadsManager(address payloadsManager) external view returns (bool);
}
