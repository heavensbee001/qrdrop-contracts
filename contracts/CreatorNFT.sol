//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import "hardhat/console.sol";
import { Base64 } from "./libraries/Base64.sol";

// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract CreatorNFT is ERC721URIStorage {

  mapping(uint256 => bool) private _tokenActive;

  event NewCreatorNFTMinted(address sender, uint256 tokenId);
  event TokenActiveUpdated(uint256 tokenId, bool active);

  // We need to pass the name of our NFTs token and it's symbol.
  constructor() ERC721 ("Poap Creator NFT", "PCN") {
    console.log("initializing NFT Contract");
  }

  // A function our user will hit to get their NFT.
  function makeACreatorNFT(
    string memory name,
    string memory description,
    string memory imageUri
  ) public returns(uint256) {
     // Get the id of the name
     uint256 newItemId = uint256(keccak256(abi.encodePacked(name)));

     // Actually mint the NFT to the sender using tx.origin.
    _safeMint(tx.origin, newItemId);

    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": ',name,', "description": ',description,', "image": ',imageUri,'}'
                )
            )
        )
    );

    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(string(abi.encodePacked("https://nftpreview.0xdev.codes/?code=", finalTokenUri)));
    console.log("--------------------\n");
    // Set the NFTs data.
    _setTokenURI(newItemId, finalTokenUri);
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, tx.origin);

    emit NewCreatorNFTMinted(tx.origin, newItemId);

    setActive(newItemId, true);

    return newItemId;
  }

  // set token as active to enable PoapNFTs minting
  function setActive(uint256 id, bool isActive) public {
    require(ownerOf(id) == tx.origin, "CreatorNFT: Address is not the owner of the token");
    require(_exists(id), "CreatorNFT: Token does not exist");

    _tokenActive[id] = isActive;
    emit TokenActiveUpdated(id, _tokenActive[id]);
  }

  function active(uint256 id) public view returns (bool) {
    require(_exists(id), "CreatorNFT: Token does not exist");
    
    return _tokenActive[id];
  }
}