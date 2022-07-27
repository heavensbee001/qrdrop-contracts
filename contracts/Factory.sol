//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "hardhat/console.sol";
import { Base64 } from "./libraries/Base64.sol";
import { CreatorNFT } from "./CreatorNFT.sol";
import { PoapNFT } from "./PoapNFT.sol";

contract Factory {
    CreatorNFT private _creatorNFTContract;

    mapping (uint256 => PoapNFT) public collections; //a mapping that contains different ERC721 collection contracts deployed
    mapping (address => uint256[]) public ownerToCreatorNFTId; //a mapping that contains different ERC721 collection contracts deployed

    event NewCreatorNFTMinted(address sender, uint256 tokenId);
    event NewBadgeNFTMinted(address sender, uint256 tokenId);

    constructor () {
      _deployCreatorNFT();
    }

    function _deployCreatorNFT() private {
      _creatorNFTContract = new CreatorNFT();
    }

    function createCreatorNFT(string memory _name, string memory _symbol, string memory _description, string memory _imageUri) public{
      uint256 _id = _creatorNFTContract.makeACreatorNFT(_name, _description, _imageUri);
      ownerToCreatorNFTId[msg.sender].push(_id);
      _deployPoapNFT(_id, _name, _symbol, _description, _imageUri); 

      emit NewCreatorNFTMinted(tx.origin, _id);
    }
    
    function setCreatorNFTActive(uint256 _id, bool _isActive) public {
      _creatorNFTContract.setActive(_id, _isActive);
    }
    
    function getCreatorNFT(uint256 _id) public view returns(string memory){
      return _creatorNFTContract.tokenURI(_id);
    }

    function getCreatorNFTActive(uint256 _id) public view returns(bool){
      return _creatorNFTContract.active(_id);
    }

    function getAddressCreatorNFTs(address owner) public view returns(uint256[] memory) {
      return ownerToCreatorNFTId[owner];
    }

    function isCreator(uint256 _id, address _address) public view returns(bool) {
      return _creatorNFTContract.ownerOf(_id) == _address;
    }
    
    function _deployPoapNFT(uint _id, string memory _contractName, string memory _symbol, string memory _description, string memory _imageUri) private returns (address) {
        PoapNFT poapContract = new PoapNFT(_contractName, _symbol, _description, _imageUri);
        collections[_id] = poapContract;

        return address(poapContract);
    }

    function makeAPoapNFT(uint _id) public {
      require(address(collections[_id]) != address(0), "There's no NFT collection with this id");
      collections[_id].makeAPoapNFT();
    }

    function getCollection(uint256 _id) public view returns(PoapNFT) {
      return collections[_id];
    }

    function getAddressNFTInCollection(uint256 _id, address _address) public view returns(uint256) {
      return getCollection(_id).getOwnerTokenId(_address);
    }
}