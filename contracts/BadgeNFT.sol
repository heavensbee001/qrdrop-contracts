//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";
import { Base64 } from "./libraries/Base64.sol";

// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract BadgeNFT is ERC721URIStorage, Ownable {
  // Magic given to us by OpenZeppelin to help us keep track of tokenIds.
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  string private _uri;

  mapping (address=>uint) private _ownerToTokenId;

  event NewBadgeNFTMinted(address sender, uint256 tokenId);

  // We need to pass the name of our NFTs token and it's symbol.
  constructor(string memory _name, string memory _symbol, string memory _description, string memory _imageUri) ERC721 (_name, _symbol) {
    console.log("initializing Badge NFT Contract");
    _tokenIds.increment();

    // store Badge uri 
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "', _name,'","description": "', _description,'","image": "', _imageUri,'"}'
                )
            )
        )
    );

    _uri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );
    
  }

  // sender should be able to mint a Badge only if it has not a token on the same contract
  modifier uniquePerSoul () {
    require(_ownerToTokenId[tx.origin] == 0, "This address already has a token");
    _;
  }

  // A function our user will hit to get their NFT.
  function makeABadgeNFT() public onlyOwner uniquePerSoul {
     // Get the current tokenId, this starts at 0.
    uint256 newItemId = _tokenIds.current();

     // Actually mint the NFT to the sender using tx.origin.
    _safeMint(tx.origin, newItemId);
    _ownerToTokenId[tx.origin] = _tokenIds.current();
    
    // Set the NFTs data.
    _setTokenURI(newItemId, _uri);
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, tx.origin);

    // Increment the counter for when the next NFT is minted.
    _tokenIds.increment();

    emit NewBadgeNFTMinted(tx.origin, newItemId);
  }

  // revert all transfer methods to make tokens soulbound
  function transferFrom() public pure {
    revert('This token is not transferable');
  }
  function safeTransferFrom() public pure {
    revert('This token is not transferable'); 
  }
  function approve() public pure {
    revert('This token is not transferable'); 
  }
  function getApproved() public pure {
    revert('This token is not transferable'); 
  }

  function getTokensNumber() public view returns(uint256) {
    return _tokenIds.current();
  }

  function getOwnerTokenId(address owner) public view returns(uint256) {
    return _ownerToTokenId[owner];
  }
}