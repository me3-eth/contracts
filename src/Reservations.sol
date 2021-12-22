//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/access/Ownable.sol";

contract Reservations is Ownable {
  // All reservations
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

  function add (bytes32 subdomain, address reserveOwner) external onlyOwner {
    require(s_reservations[subdomain] == address(0), "Reservation already taken");
    s_reservations[subdomain] = reserveOwner;
  }
}
