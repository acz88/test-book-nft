// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./ERC4907.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Book is ERC4907 {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  constructor() ERC4907("Book", "BK") {}

  function mint(string memory _tokenURI, string[] memory _metadata) public {
    _tokenIds.increment();
    uint256 newTokenId = _tokenIds.current();
    _safeMint(msg.sender, newTokenId);
    _setTokenURI(newTokenId, _tokenURI);
    _setTokenMetadata(newTokenId, _metadata);
  }

  function setUser(uint256 tokenId, address user, uint64 expires) public virtual override {
    require(
      _isApprovedOrOwner(msg.sender, tokenId),
      "ERC721: transfer caller is not owner nor approved"
    );
    UserInfo storage info = _users[tokenId];
    info.user = user;
    info.expires = expires;
    emit UpdateUser(tokenId, user, expires);
  }

  function burn(uint256 tokenId) public {
    _burn(tokenId);
  }
}
