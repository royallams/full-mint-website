// SPDX-License-Identifier: UNLICENSED

pragma solidity  ^0.8.4;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';// will allow us to define functions that only the owner can use


contract RoboPunksNFT is ERC721, Ownable{// get all the base functionality
    uint256 public mintPrice;// Gas cost.. use less and change less
    uint256 public totalSupply;//current no of NFTS minted
    uint256 public maxSupply;// Max number of NFTS 
    uint256 public maxPerWallet;//Max mint per wallet
    bool public isPublicMintEnabled;// controls the minting possibility
    string internal baseTokenUri;// where is the image
    address payable public withdrawWallet;
    mapping(address=> uint256) public walletMints;// Keep track of how many each wallet has minted to avoid extra


// ERC721 takes name and symbol
    constructor() payable ERC721('RoboPunks','RP'){
        mintPrice = 0.02 ether;//slightly cheaper than other intilization
        totalSupply = 0;
        maxSupply = 1000;
        maxPerWallet = 3;
    }


    // This can be only called by the owner of the contract .. like the admin..
    // possible due to inherti from ownable 
    function setIsPublicMintEnabled(bool isPublicMintEnabled_) external onlyOwner {
        isPublicMintEnabled = isPublicMintEnabled
    }


}