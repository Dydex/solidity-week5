// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.3;

import "./IERC20.sol";


contract schoolMgn {
    IERC20 public token;

    address constant tokenAddress = 0x1482717Eb2eA8Ecd81d2d8C403CaCF87AcF04927;

    struct Student {
        uint id;
        string name;
        uint level; 
        uint fee;
        bool paid; 
        uint timePaid;
    }

    struct Staff {
        uint staffid;
        string name;
        uint level;
        uint salary;
        bool paidSalary;
    }

    mapping(uint => uint) public levelFees;
    mapping(uint => uint) public levelSalary;
    mapping(address => uint) public schoolFees;

    Student[] public students;
    Staff[] public staffs;

    uint public studentId;
    uint public staffId;


    constructor(){
        token = IERC20(tokenAddress);

        levelFees[100] = 1000 * 10**18;
        levelFees[200] = 2000 * 10**18;
        levelFees[300] = 3000 * 10**18;
        levelFees[400] = 4000 * 10**18;

        levelSalary[100] = 100 * 10**18;
        levelSalary[200] = 200 * 10**18;
        levelSalary[300] = 300 * 10**18;
        levelSalary[400] = 400 * 10**18;
    }

    function registerStudent(string memory _name, uint _level) external {
      uint _fee = levelFees[_level];  

        require(msg.sender != address(0), "Invalid Address");
        require(token.balanceOf(msg.sender) >= _fee , "Insufficient Balance");
        require(token.transferFrom(msg.sender, address(this), _fee));

      studentId += 1;

      Student memory student = Student(studentId, _name, _level, _fee, true, block.timestamp );
      
      students.push(student);
    }

    function getAllStudents() external view returns(Student[] memory){
        return students;
    }

    function registerStaff(string memory _name, uint _level ) external {
       uint _salary = levelSalary[_level];

       staffId += 1;
        Staff memory staff = Staff(staffId, _name, _level, _salary, false);
        staffs.push(staff);
    }

    function getAllStaffs() external view returns(Staff[] memory) {
        return staffs;
    }
    
    function payStaff(uint _staffId, address _staffAddress) external  {
        require(_staffId > 0 && _staffId <= staffs.length, "Invalid staff ID");
               
        Staff storage staff = staffs[_staffId - 1];

        require(!staff.paidSalary, "Staff already paid");

        uint salary = staff.salary;

        require(_staffAddress != address(0), "Invalid Address" );

        require(token.balanceOf(address(this)) >= salary, "Insufficient balance");

        token.transfer(_staffAddress, salary);

        staff.paidSalary = true;
    }   
       
}