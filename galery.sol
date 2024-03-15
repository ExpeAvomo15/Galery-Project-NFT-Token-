// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts@4.4.2/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.4.2/access/Ownable.sol";

contract ArtToken is ERC721, Ownable {

    //----- INITIAL STATEMENTS ---
    //Smart Contract Constructor
    constructor (string memory _name, string memory _symbol) ERC721 (_name, _symbol){}

    uint256 COUNTER;
    uint256 public fee = 1 ether;

    struct Art{
        string name;
        uint256 id;
        uint256 dna;
        uint256 level;
        uint8 rarity;
    }

    Art [] public artWorks;
    event NewArtWork (address indexed  owner, uint256 id, uint256 dna);

    // --- HELP FUNCTIONS ---

    //Creating a new art work
    function _createRandomNumber (uint256 _mod)internal view returns (uint256){
        bytes32 hash_randomoNumber = keccak256(abi.encodePacked(msg.sender, block.timestamp));
        uint256 randNumber = uint256(hash_randomoNumber);
        return randNumber%_mod;
    }
    function _createArtWork (string memory _name) internal{
        uint256 randDna = _createRandomNumber(10**16);
        uint8 randRarity = uint8(_createRandomNumber(1000));
        Art memory newArtWork = Art (_name, COUNTER, randDna, 1, randRarity);
        artWorks.push(newArtWork);
        artWorks.push(newArtWork);
        _safeMint(msg.sender, COUNTER);
        emit NewArtWork(msg.sender, COUNTER, randDna);
        COUNTER++;

    }

    function updateFee (uint256 _fee) external onlyOwner returns(uint256){
        fee = _fee;
        return fee;
    }

    function infoSamrtContarct ()public view returns (address, uint256){
        address scAddr = address(this);
        uint256 scMoney = address(this).balance / 10**18;
        return (scAddr, scMoney);
    }

    function gerArtworks () public view returns (Art[]memory){
        return  artWorks;
    }

    function getOwnerArtWorks (address _owner) public view returns (Art[]memory){
        Art [] memory results = new Art[](balanceOf(_owner));
        uint256 counter_owner=0;
        for(uint256 i=0; i<artWorks.length; i++){
            if(ownerOf(i)==_owner){
                results[counter_owner] = artWorks[i];
                counter_owner++;
            }
        }
        return results;
    }

// ----- NFT TOKEN DEVELOPMENT ----
function createRandomArtWork (string memory _name) public  payable{
    require(msg.value>=fee);
    _createArtWork(_name);
}

//transfer benetifs from the smart contract to the owner
function withdraw () external payable onlyOwner{
    address payable _owner = payable (owner());
    _owner.transfer(address(this).balance);
}

//Level Up the level of the ArtWork
function levelUp (uint256 _artId) public{
    Art storage art = artWorks[_artId];
    art.level++;
}

}



