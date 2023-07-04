
//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CourseWave is Ownable{

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
    mapping(uint256 => mapping (uint256 => bool)) courseEnrollment;

    // student ID => course ID => marks
    mapping (uint256 => mapping (uint256=>uint256)) marks;

    uint256 latestStudentId;
    mapping (address=>Student) students;

    uint256 latestInstructorId;
    Instuctor[] instructors;

    event CreateCourse(
        uint256 courseId,
        uint256 createdAt
    );

    function checkInstructorExist(address addrs) internal view returns(bool){
        bool instructorExist = false;
        for (uint i = 0; i < instructors.length; i++) {
            if(instructors[i].instructorEthAddress == addrs){
                instructorExist = true;
                break;
            }
        }
        return instructorExist;
    }

    modifier isNotInstructor(address addressToCheck) {
        require(!checkInstructorExist(addressToCheck), "Already an instructor");
        _;
    }

    modifier isNotStudent(address addressToCheck) {
        require(students[addressToCheck].studentEthAddress != address(0), "Already a student");
        _;
    }

    modifier isInstructor(address addressToCheck) {
        require(checkInstructorExist(addressToCheck), "Not an instructor");
        _;
    }

    modifier isStudent(address addressToCheck) {
        require(students[addressToCheck].studentEthAddress == address(0), "Is not a student");
        _;
    }

    constructor(Instuctor[] memory _instructors) {
        instructors = _instructors;
    }

    function onBoardStudent(
        string calldata name
    ) external isNotStudent(msg.sender) { 
        students[msg.sender] = Student(
            latestStudentId,
            msg.sender,
            name
        );
        latestStudentId++;
    }

    function addInstrutor(
        string calldata name,
        address instructorAddress
    ) external onlyOwner isNotInstructor(instructorAddress)  {
        instructors[latestInstructorId] = Instuctor(
            latestInstructorId,
            instructorAddress,
            name
        );
        latestInstructorId++;
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

    function getCourses() external view returns(Course[] memory){
        
    }

    function getEnrolledStudents() external view returns(Student[] memory){
        
    }

    function getEnrolledCourses() external view returns(Course[] memory){
        
    }

    function getCertificates() external view returns(Course[] memory){
        
    }
 

}