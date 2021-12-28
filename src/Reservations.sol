//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "openzeppelin-contracts/access/Ownable.sol";

library Errors {
  string internal constant ReservationTaken = "Reservation already taken";
  string internal constant ReservationOwnerOnly = "Must be an owner to modify reservation";
}

/// @title Reservations
/// @notice Reserve a number of subdomains for later use and be able to transfer them to another owner
contract Reservations is Ownable {
  mapping(bytes32 => address) public s_reservations;

  constructor(address contractOwner) {
    s_reservations["admin"] = contractOwner;
    s_reservations["administrator"] = contractOwner;
    s_reservations["community"] = contractOwner;
    s_reservations["dao"] = contractOwner;
    s_reservations["dev"] = contractOwner;
    s_reservations["forum"] = contractOwner;
    s_reservations["forums"] = contractOwner;
    s_reservations["http"] = contractOwner;
    s_reservations["https"] = contractOwner;
    s_reservations["m"] = contractOwner;
    s_reservations["mail"] = contractOwner;
    s_reservations["me3"] = contractOwner;
    s_reservations["mod"] = contractOwner;
    s_reservations["moderator"] = contractOwner;
    s_reservations["news"] = contractOwner;
    s_reservations["press"] = contractOwner;
    s_reservations["shop"] = contractOwner;
    s_reservations["wiki"] = contractOwner;
    s_reservations["www"] = contractOwner;

    transferOwnership(contractOwner);
  }

  /// @notice Reserve a subdomain to a particular address
  /// @param subdomain The subdomain to reserve
  /// @param reserveOwner The address that will own the reservation
  function add (bytes32 subdomain, address reserveOwner) external onlyOwner {
    require(s_reservations[subdomain] == address(0), Errors.ReservationTaken);
    s_reservations[subdomain] = reserveOwner;
  }

  /// @notice Change the owner of a subdomain reservation. Only possible if you are the reservation owner or the contract owner
  /// @param subdomain The subdomain to update
  /// @param newOwner Who to change the owner to. Use address(0) to free the reservation
  function modify (bytes32 subdomain, address newOwner) external {
    bool hasAccess = (
      (s_reservations[subdomain] == address(msg.sender)) ||
      (owner() == address(msg.sender))
    );

    require(hasAccess, Errors.ReservationOwnerOnly);

    s_reservations[subdomain] = newOwner;
  }
}
