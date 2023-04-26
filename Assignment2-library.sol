// SPDX-License-Identifier: MIT
 
pragma solidity ^0.8.0;


library addsub{
    function add(uint a, uint b) internal returns(uint){
       return a+b;
    }

     function sub(uint a, uint b) internal returns(uint){
       return a-b;
    }
}



contract BankingSystem{

struct registerUser{
    string fname;
    string lname;
    uint mno;
    uint balance;
    address  addr;
}

    address  private Owner;

    // constructor () public  {
    //     Owner = msg.sender;
    // }


    // Register user
    mapping(address => registerUser) private authuser;
    function UserResis(string memory _fname, string memory _lname, uint _mno) public payable  {
        // authuser[msg.sender] = registerUser(_fname, _lname, _mno, _balance(msg.sender), _addr(msg.sender));
        authuser[msg.sender].fname= _fname;
        authuser[msg.sender].lname= _lname;
        authuser[msg.sender].mno= _mno;
        authuser[msg.sender].balance= msg.value;
        authuser[msg.sender].addr= msg.sender;
    }
    
    function getuser() public view returns(registerUser memory){
        return authuser[msg.sender];
        // return (authuser[msg.sender].fname, 
        // authuser[msg.sender].lname, 
        // authuser[msg.sender].mno, 
        // authuser[msg.sender].balance,
        // authuser[msg.sender].addr
        //  )
        // ;
    } 

    function deposit() public payable {
        require(authuser[msg.sender].addr == msg.sender,"You are not registered");
         authuser[msg.sender].balance = addsub.add(authuser[msg.sender].balance, msg.value);
    } 


    function withdraw(uint _amount) public returns(uint )  {
        require(_amount <= authuser[msg.sender].balance, " Add some money first");
        authuser[msg.sender].balance = addsub.sub(authuser[msg.sender].balance, _amount);
        payable(msg.sender).transfer(_amount);
        return authuser[msg.sender].balance;
    }
    

    function transfer(address _reciever , uint _amount) public payable {
        require(_amount <= authuser[msg.sender].balance, "Insufficient Funds ");
        authuser[msg.sender].balance = addsub.sub(authuser[msg.sender].balance, _amount);
        authuser[_reciever].balance = addsub.add(authuser[_reciever].balance, _amount);
        payable(_reciever).transfer(_amount);
        // payable(_reciever).send(_amount);
        // (bool success,) = _reciever.call{value:_amount}("");
        // require(success , "failed to send ether");
        
    }


}