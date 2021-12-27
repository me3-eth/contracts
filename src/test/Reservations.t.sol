//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../Reservations.sol";

contract ReservationsTest {
  Reservations r;

  address constant newOwner = 0x95a647B3d8a3F11176BAdB799b9499C671fa243a;
  address constant signer = 0x71950741B6CC9414422230EC2Daf097a1936A06b;

  function setUp() public {
    r = new Reservations(newOwner);
  }

  function testReservationsCreatedInConstructor() public {
    require(r.s_reservations("admin") == 0x95a647B3d8a3F11176BAdB799b9499C671fa243a);
    require(r.s_reservations("www") == 0x95a647B3d8a3F11176BAdB799b9499C671fa243a);
  }

  function testOwnershipTransferredFromSenderToChosen() public {
    // Using the address from setUp as new owner
    require(r.owner() == 0x95a647B3d8a3F11176BAdB799b9499C671fa243a);
  }

  function testAddNewReservation() public {
    r.add("youknow", signer);
    require(r.s_reservations("youknow") == signer, "Reservation not completed");
  }

  function testFailWhenReservationTaken() public {
    try r.add("admin", signer) {
      revert();
    } catch Error(string memory error) {
      require(keccak256(abi.encode(error)) == keccak256("Reservation already taken"), "Unexpected error occurring");
    }
  }
}
