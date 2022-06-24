//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import { Base64 } from "./libraries/Base64.sol";

// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract CreatorNFT is ERC721URIStorage {

  event CreatorNFTMinted(address sender, uint256 tokenId);

  // We need to pass the name of our NFTs token and it's symbol.
  constructor(string memory _name, string memory _symbol) ERC721 (_name, _symbol) {
    console.log("initializing NFT Contract");
  }

  // A function our user will hit to get their NFT.
  function makeACreatorNFT() public {
     // Get the id of the name
     uint256 newItemId = uint256(keccak256(abi.encodePacked(name())));

     // Actually mint the NFT to the sender using msg.sender.
    _safeMint(msg.sender, newItemId);

    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "", "description": "", "image": ""}'
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
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    emit CreatorNFTMinted(msg.sender, newItemId);
  }
}