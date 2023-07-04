
//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "hardhat/console.sol";

contract CourseWave {

    struct Student{
        uint256 id;
        address studentEthAddress;
        string name;
    }

    struct Instuctor{
        uint256 id;
        address instructorEthAddress;
        string name;
    }

    struct Course{
        uint128 id;
        string name;
        uint128 instructorId;
        string description;
        uint256 duration;
        uint256 stakingAmount;
    }

    uint256 latestCourseId;
    // instructorIDs => Course[]
    mapping(uint256 => Course[]) courses;

    // courseID => student IDs
    mapping(uint256 => uint256[]) courseEnrollment;

    // student ID => course ID => marks
    mapping (uint256 => mapping (uint256=>uint256)) marks;

    mapping (address=>Student) students;

    uint256 latestInstructorId;
    Instuctor[] instructors;

    event CreateCourse(
        uint256 courseId,
        uint256 createdAt
    );

    constructor(Instuctor[] memory _instructors) {
        instructors = _instructors;
    }

     function onBoardStudent(
        string calldata name
    ) external { 
        
    }

    function addInstrutor(

    ) external {
        
    }

    function createCourse(
        string calldata name,
        string calldata description,
        uint256 duration,
        uint256 stakingAmount
    ) external {
        
    }



    function stake() internal {
        
    }

    function enrollCourse(

    ) external {
        
    }

    function assignMarks() external {
        
    }

    function issueCertificate() external {
        
    }

    function distributeStakes() external {
        
    }

    function distributeStake() external {
        
    }
    
    

}