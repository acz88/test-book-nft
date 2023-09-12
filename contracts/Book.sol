// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Book is ERC721, Ownable{
    struct UserInfo {
        address user; // address of user role
        uint64 expires; // unix timestamp, user expires
    }

    mapping(uint256 => UserInfo) internal _users;

    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {}


    /// @dev modifier to determine whether a user has read access to a book.
    /// @notice this checks access in this order: 1) if you are the owner, 2) if your access has expired. This might need some work, as if time expires I believe that the first condition will fail every time, and so if your loan ends instead of receiving the second message, you'll receive the first.
    modifier hasReadAccess(uint256 tokenID) {
        require(msg.sender == _users[tokenID].user, "You don't own this asset.");
        require(block.timestamp < _users[tokenID].expires, "Access expired. Please return to the interface to renew.");
        _;
    }

    /// @dev This gives access to the URI, so long as the address making the request has read access.
    function accessBookContent(uint256 tokenID) public view hasReadAccess(tokenID) returns(uint256) {
        return tokenID;
    }
}