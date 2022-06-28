//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "hardhat/console.sol";
import { Base64 } from "./libraries/Base64.sol";
import { CreatorNFT } from "./CreatorNFT.sol";
import { PoapNFT } from "./PoapNFT.sol";

contract Factory {
    CreatorNFT private _creatorNFTContract;

    mapping (uint256 => PoapNFT) public collections; //a mapping that contains different ERC721 collection contracts deployed

    constructor () {
      _deployCreatorNFT();
    }

    function _deployCreatorNFT() private {
      _creatorNFTContract = new CreatorNFT();
    }

    function createCreatorNFT(string memory _name, string memory _symbol, string memory _description, string memory _imageUri) public {
      uint256 _id = _creatorNFTContract.makeACreatorNFT(_name, _description, _imageUri);
      _deployPoapNFT(_id, _name, _symbol, _description, _imageUri);
    }
    
    function setCreatorNFTActive(uint256 _id, bool _isActive) public {
      _creatorNFTContract.setActive(_id, _isActive);
    }
    
    function getCreatorNFTActive(uint256 _id) public view {
      _creatorNFTContract.active(_id);
    }
    
    function _deployPoapNFT(uint _id, string memory _contractName, string memory _symbol, string memory _description, string memory _imageUri) private returns (address) {
        PoapNFT poapContract = new PoapNFT(_contractName, _symbol, _description, _imageUri);
        collections[_id] = poapContract;

        return address(poapContract);
    }

    function mintERC721(uint _id) public {
      collections[_id].makeAPoapNFT();
    }

    // /*
    // Helper functions below retrieve contract data given an ID or name and index in the tokens array.
    // */
    // function getCountERC721byIndex(uint256 _index, uint256 _id) public view returns (uint amount) {
    //     return tokens[_index].balanceOf(indexToOwner[_index], _id);
    // }

    // function getCountERC721byName(uint256 _index, string calldata _name) public view returns (uint amount) {
    //     uint id = getIdByName(_index, _name);
    //     return tokens[_index].balanceOf(indexToOwner[_index], id);
    // }

    // function getIdByName(uint _index, string memory _name) public view returns (uint) {
    //     return tokens[_index].nameToId(_name);
    // }

    // function getNameById(uint _index, uint _id) public view returns (string memory) {
    //     return tokens[_index].idToName(_id);
    // }

    // function getERC721byIndexAndId(uint _index, uint _id)
    //     public
    //     view
    //     returns (
    //         address _contract,
    //         address _owner,
    //         string memory _uri,
    //         uint supply
    //     )
    // {
    //     ERC721Token token = tokens[_index];
    //     return (address(token), token.owner(), token.uri(_id), token.balanceOf(indexToOwner[_index], _id));
    // }
}