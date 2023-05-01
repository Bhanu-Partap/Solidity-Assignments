// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "hardhat/console.sol";

contract ASSignment3 is ERC721URIStorage, Ownable {
    uint256 public constant MAX_supply = 10;
    uint256 public publicSaleLimit = 5;
    uint256 public preSaleLimit;
    uint256 preSaleEnd;
    uint256 public preSaleClaimed;
    uint256 publicSaleStart;
    uint256 public publicSaleClaimed;
    bool preSaleOpen;
    bool publicSaleOpen;
    address[] public verifiedUsers;
    uint256 id;

    constructor(uint256 _preSaleLimit) ERC721("STAKE", "NSX") {
        preSaleLimit = _preSaleLimit;
        preSaleOpen = true;
        preSaleEnd = block.timestamp + 120;
    }

    function user(address addr) public onlyOwner {
        verifiedUsers.push(addr);
    }

    function preMint(uint256 _quantity, string memory uri) public payable {
        uint256 i;
        address _address;

        for (i = 0; i < verifiedUsers.length; i++) {
            if (msg.sender == verifiedUsers[i]) {
                _address = verifiedUsers[i];
            }
        }
        require(msg.sender == _address, "Not a Verified User");
        require(preSaleLimit > preSaleClaimed, " Stock Out");
        require(
            msg.value >= 1 ether * _quantity,
            "Have to pay the correct amount"
        );
        for (i = 0; i < _quantity; i++) {
            id++;
            _mint(msg.sender, id);
            preSaleClaimed += 1;
            _setTokenURI(
                id,
                string(abi.encodePacked(uri, Strings.toString(id), ".json"))
            );
            console.log(tokenURI(id));
        }
    }

    function publicMint(uint256 _quantity, string memory uri) public payable {
        require(publicSaleClaimed < MAX_supply, "Stock out");
        require(preSaleEnd < block.timestamp, "Public Sale Not Started");
        require(publicSaleClaimed < publicSaleLimit, "Stock Out ");
        if (preSaleClaimed < preSaleLimit) {
            uint256 preSaleLeft = preSaleLimit - preSaleClaimed;
            publicSaleLimit += preSaleLeft;
            preSaleLimit -= preSaleLeft;
        }
        require(msg.value >= 1 ether * _quantity, "Not sufficient amount");
        for (uint256 i = 0; i < _quantity; i++) {
            id++;
            _safeMint(msg.sender, id);
            publicSaleClaimed += 1;
            _setTokenURI(
                id,
                string(abi.encodePacked(uri, Strings.toString(id), ".json"))
            );
        }
    }

    function endPublicSale() public onlyOwner {
        require(publicSaleOpen, "Public sale has not started.");
        publicSaleOpen = false;
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(owner()).transfer(balance);
    }
}
