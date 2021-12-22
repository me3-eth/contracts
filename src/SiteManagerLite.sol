//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/access/Ownable.sol";
import "@ensdomains/ens-contracts/contracts/resolvers/PublicResolver.sol";
import "@ensdomains/ens-contracts/contracts/registry/ENS.sol";

contract SiteManagerLite is Ownable {
  // Reference to a registry that matches the ENS interface
  ENS private immutable s_ens;

  // The domain to create subdomains from, this contract needs to be the owner
  // or an operator of the node
  bytes32 private immutable s_manageNode;

  // Resolver to use when creating subdomains
  PublicResolver public s_defaultResolver;

  // Indicate when a new subdomain is registered, what it is, and by whom
  event SubdomainRegistered (address owner, bytes32 indexed label);

  constructor(ENS _registryAddr, PublicResolver _resolverAddr, bytes32 _manageNode) {
    s_ens = _registryAddr;
    s_defaultResolver = _resolverAddr;
    s_manageNode = _manageNode;
  }

  function setDefaultResolver (PublicResolver resolver) external onlyOwner {
    s_defaultResolver = resolver;
  }

  /**
    * Create a subnode for the managed node and update the resolver with
    * the contenthash for the site.
    * Finally, set the owner of the subnode to be the `msg.sender`.
    */
  function subdomainRegister (bytes32 label, bytes32 fullDomain, bytes calldata hash) external {
    require(hash.length > 0, "Must have a contenthash");

    // Create the subdomain through this contract so that the contract is the owner, temporarily
    s_ens.setSubnodeRecord(s_manageNode, label, address(this), address(s_defaultResolver), 500);

    // Point to website
    s_defaultResolver.setContenthash(fullDomain, hash);

    // Transfer ownership of subdomain to sender
    s_ens.setSubnodeOwner(s_manageNode, label, msg.sender);

    emit SubdomainRegistered(msg.sender, label);
  }
}
