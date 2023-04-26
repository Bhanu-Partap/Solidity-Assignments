// SPDX-License-Identifier: MIT
 
pragma solidity ^0.8.0;


contract studentRegis{

    uint studentCount;

struct studentsDetails{
    string firstName;
    string lastName;
    uint age;
    uint mNo; 
    address addr;   
    uint id;
    bool registered;
    studentSubjects[]  subjects;
    
}

struct studentSubjects{
    string subject;
    uint marks;
}

   
    mapping(uint =>studentsDetails) public Detailsregis;
    function enterDetails(string memory fName, string memory lName, uint _age,  uint _mNo, address _addr, uint _id, bool _registered ) public {
        require(Detailsregis[_id].addr==address(0),"You are already registered");
        Detailsregis[_id].firstName=fName;
        Detailsregis[_id].lastName=lName;
        Detailsregis[_id].age=_age;
        Detailsregis[_id].mNo=_mNo;
        Detailsregis[_id].addr=_addr;
        Detailsregis[_id].id=_id;
        Detailsregis[_id].registered=_registered;
        studentCount++;
    }

    //Enter marks and Subjects in an array

    function setMarks(uint _id, string memory _subject, uint marks) public    {
        require(Detailsregis[_id].registered == true , "you are not registered");
        Detailsregis[_id].subjects.push(studentSubjects(_subject, marks));
    }

    //  Display the Subjects and Marks in an array

    function showsubjectsandmarks(uint _id) public view returns(studentSubjects[] memory){
            return Detailsregis[_id].subjects;
    }

    function particularsubject(uint _id, uint index) public view returns(string memory, uint){
        return (Detailsregis[_id].subjects[index].subject,Detailsregis[_id].subjects[index].marks);
    }

    function percentagetomarks(uint _id) public view returns (uint){
        uint sum;
        uint percentage;
        uint length =Detailsregis[_id].subjects.length;
        for(uint i=0;i<length;i++){
            sum+= Detailsregis[_id].subjects[i].marks;
        }
        percentage =(sum /length)*100;
        return percentage;
    }
    
  
    function CountStudent() public view returns(uint){
        return studentCount;
    }


    
}


