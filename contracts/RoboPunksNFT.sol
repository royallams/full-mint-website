// SPDX-License-Identifier: UNLICENSED

pragma solidity  ^0.8.4;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';//nft
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

  //  [ adress | Mint Counts  ]
  //  [   21332 | 3           ]
  //  [   13213 | 5           ]



// ERC721 takes name and symbol
    constructor() payable ERC721('RoboPunks','RP'){
        mintPrice = 0.02 ether;//slightly cheaper than other intilization
        totalSupply = 0;
        maxSupply = 1000;
        maxPerWallet = 5;
    }


    // This can be only called by the owner of the contract .. like the admin..
    // possible due to inherti from ownable 
    //Set Enable Status
    function setIsPublicMintEnabled(bool isPublicMintEnabled_) external onlyOwner {
        isPublicMintEnabled = isPublicMintEnabled_;
    }


    //Set Image
    function setBaseTokenURI(string calldata baseTokenURI_) external onlyOwner{
        baseTokenUri = baseTokenURI_;
    } 



    string result_image_details =tokenURI(6994);//called opensea
    



    //Get Image
    function tokenURI(uint token_id_) public view override returns(string memory){

        require(_exists(token_id_), "Token doest not exist");
        return string(
            abi.encodePacked(baseTokenUri, Strings.toString(token_id_),".json")
            // For Eg: www.outdoorfeels.com/1.json (BaseURI+/+TokenId+.json)
            //www.outdoorfeels.com/2.json

        );
    }


    //Withdraw money to  owners wallet..
    function withdraw() external onlyOwner{
        (bool success,) = withdrawWallet.call{ value: address(this).balance}('');
        require(success, 'withdraw failed');
        
    }


    function mint(uint256 quantity_) public payable{
        require(isPublicMintEnabled , "Minting not enabled");
        require(msg.value == mintPrice*quantity_, "Wrong Mint Value ");
        require(totalSupply + quantity_<=maxSupply, "Sold out");
        require(walletMints[msg.sender] + quantity_ <=maxPerWallet, "Exceeded Max wallet limit");
    
        for(uint256 i=0 ; i<quantity_;i++){
            uint256 newTokenId = totalSupply+1;
            totalSupply++;
            _safeMint(msg.sender, newTokenId);//MAIN MINTING IS DONE HERE...

        }
    }
    




}

// wallet      |   Minting done
// 0x12123412  |   4
// 0x12313123  |   5
// 0x12314141  |   1

