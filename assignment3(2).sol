// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract ASSignment3 is ERC721, Ownable {
    uint256 public constant MAX_supply = 1000;
    // uint256 public constant PRE_salesupply;
    // uint256 public constant PRICE = 1 ether;
    uint256 public preSaleLimit;
    uint256 public preSaleStart;
    uint256 preSaleEnd;
    uint256 public preSaleClaimed;
    uint256 public publicSaleStart;
    uint256 public publicSaleClaimed;
    bool public preSaleOpen;
    bool public publicSaleOpen;
    address[] public verifiedUsers;
    uint256 id;

    constructor(uint256 _preSaleLimit) ERC721("STAKE", "NSX") {
        preSaleLimit = _preSaleLimit;
        preSaleOpen = true;
        preSaleEnd = block.timestamp + 60 seconds;
    }

    function user(address addr) public onlyOwner {
        verifiedUsers.push(addr);
    }

    function preMint() public payable {
        uint256 i;
        require(msg.value > 1 ether, "Have to pay the charge fees");
        require(msg.sender == verifiedUsers[i], "Not a Verified User");
        require(id < preSaleLimit,"");
        for (i = 0; i < verifiedUsers.length; i++) {
            // require(msg.sender == verifiedUsers[i], "Not a Verified User");
            id++;
            _mint(msg.sender, id);
            preSaleClaimed += 1;
        }
    }

    function publicMint() public payable {
        require(msg.value >= 1 ether, "Have to pay the charge fees");
        require(preSaleEnd > block.timestamp, "Public Sale Not Started");
        _safeMint(msg.sender, id);
        publicSaleClaimed += 1;
    }

    function endPublicSale() public onlyOwner {
        publicSaleOpen = false;
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(owner()).transfer(balance);
    }
}
