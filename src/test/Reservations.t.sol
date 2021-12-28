//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../Reservations.sol";

contract User {
  Reservations internal r;

  function init (address _r) public {
    r = Reservations(_r);
  }

  function addReservation (bytes32 subdomain, address reserveOwner) public {
    r.add(subdomain, reserveOwner);
  }

  function modifyReservation (bytes32 subdomain, address newOwner) public {
    r.modify(subdomain, newOwner);
  }
}

contract ReservationsTest is DSTest {
  Reservations r;

  User internal reservationCreator;

  address constant signer = 0x71950741B6CC9414422230EC2Daf097a1936A06b;

  function setUp() public {
    reservationCreator = new User();
    r = new Reservations(address(reservationCreator));
    reservationCreator.init(address(r));
  }

  function testReservationsCreatedInConstructor() public {
    require(r.s_reservations("admin") == address(reservationCreator));
    require(r.s_reservations("www") == address(reservationCreator));
  }

  function testOwnershipTransferredFromSenderToChosen() public {
    require(r.owner() == address(reservationCreator));
  }

  function testAddNewReservation() public {
    reservationCreator.addReservation("youknow", signer);
    require(r.s_reservations("youknow") == signer, "Reservation not completed");
  }

  function testUnableToAddNewReservationWhenExisting() public {
    try reservationCreator.addReservation("admin", signer) {
      fail();
    } catch Error(string memory error) {
      assertEq(error, Errors.ReservationTaken, "Reservation should be taken");
    }
  }

  function testUnableToModifyReservationWhenNotOwner() public {
    try r.modify("admin", address(reservationCreator)) {
      fail();
    } catch Error(string memory error) {
      assertEq(error, Errors.ReservationOwnerOnly);
    }
  }

  function testReservationOwnerChanged(address newOwner) public {
    reservationCreator.modifyReservation("admin", newOwner);

    assertEq(r.s_reservations("admin"), newOwner);
  }
}
