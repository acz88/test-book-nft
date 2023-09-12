// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Book is ERC721, Ownable{
    /// @dev baseTokenURI is the URI for metadata (e.g. IPFS)
    string private baseTokenURI;
    /// @dev tokenOwner is the (current) owner of the NFT. After expiry of the loan period this should be defaulted to the zero address (or some other address, maybe the marketplace?)
    address private tokenOwner;
    /// @dev expiryDate is when access to the NFT should run out. How to technically work this out I am as yet unsure.
    uint256 public expiryDate;
    /// @dev these variables are the 'metadata', author, title, year of publication etc.
    string[] public metadata;


    /// @dev This constructor creates an ERC721 token, and attributtes it to an owner and sets up the expiration date, the metadata and the content itself.
    /// @notice _title and _media are only used in the ERC721 setup, and can be appended to metadata if it is empty.
    /// @param _title is the title of the book
    /// @param _media is the media type, say book, poem, movie etc.
    constructor(string memory _baseTokenURI, uint256 _expiryDate, string memory _title, string memory _media, string[] memory _metadata, address _owner) ERC721(_title, _media) {
        baseTokenURI = _baseTokenURI;
        expiryDate = _expiryDate;
        metadata = _metadata;
        tokenOwner = _owner;
    }


    /// @dev modifier to determine whether a user has read access to a book.
    /// @notice this checks access in this order: 1) if you are the owner, 2) if your access has expired. This might need some work, as if time expires I believe that the first condition will fail every time, and so if your loan ends instead of receiving the second message, you'll receive the first.
    modifier hasReadAccess() {
        require(msg.sender == tokenOwner, "You don't own this asset.");
        require(block.timestamp < expiryDate, "Access expired. Please return to the interface to renew");
        _;
    }

    function accessBookContent() public view returns(string memory) {
        return baseTokenURI;
    }
}