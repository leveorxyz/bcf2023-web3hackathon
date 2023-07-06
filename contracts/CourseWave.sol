
//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.17;
import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/ierc20.sol";
import "./interfaces/ierc721.sol";

contract CourseWave is Ownable{

    struct Student{
        uint256 id;
        address studentEthAddress;
        string name;
    }

    struct Instructor{
        uint128 id;
        address instructorEthAddress;
        string name;
    }

    struct Course{
        uint128 id;
        uint128 instructorId;
        string name;
        string description;
        uint256 duration;
        uint256 stakingAmount;
    }
    

    address erc20Address;
    address nftAddress;

    uint128 latestCourseId;
    // instructor id => Course[]
    mapping(uint128 => Course[]) courses;

    // courseID => student addresses
    mapping(uint128 => address[]) courseEnrollment;


    // student ID => course ID => marks
    mapping (address => mapping (uint128=>uint256)) marks;

    uint256 latestStudentId;
    mapping (address=>Student) students;

    uint128 latestInstructorId;
    Instructor[] instructors;

    event CreateCourse(
        uint256 courseId,
        uint256 createdAt
    );
  
    // student address => course id => staking amount
    mapping(address => mapping (uint128=>uint256)) stakingAmounts;

    function getInstructorId(address addrs) internal view returns(uint128){
        uint128 instructorId = 999999999999;
        for (uint i = 0; i < instructors.length; i++) {
            if(instructors[i].instructorEthAddress == addrs){
                instructorId = instructors[i].id;
                break;
            }
        }
        return instructorId;
    }

    modifier courseExist(uint128 courseIdToCheck) {
        require(courseIdToCheck<latestCourseId, "Course ID do not exist");
        _;
    }

    modifier isNotInstructor(address addressToCheck) {
        require(getInstructorId(addressToCheck) == 999999999999, "Already an instructor");
        _;
    }

    modifier isNotStudent(address addressToCheck) {
        require(students[addressToCheck].studentEthAddress == address(0), "Already a student");
        _;
    }

    modifier isInstructor(address addressToCheck) {
        require(getInstructorId(addressToCheck) != 999999999999, "Not an instructor");
        _;
    }

    modifier isStudent(address addressToCheck) {
        require(students[addressToCheck].studentEthAddress != address(0), "Is not a student");
        _;
    }


    constructor(address _erc20Address, address _nftAddress) {
        // instructors = _instructors;
        // for (uint i = 0; i < _instructors.length; i++) {
        //     instructors[i] = _instructors[i];
        //     latestInstructorId++;
        // }

        erc20Address = _erc20Address;
        nftAddress = _nftAddress;
    }

    function onBoardStudent(
        string calldata name
    ) external isNotStudent(msg.sender) { 
        // students[msg.sender] = Student(
        //     latestStudentId,
        //     msg.sender,
        //     name
        // );
        Student storage student = students[msg.sender];

        student.name = name;
        student.id = latestStudentId;
        student.studentEthAddress = msg.sender;
        latestStudentId++;
    }

    function addInstrutor(
        string calldata name,
        address instructorAddress
    ) external onlyOwner isNotInstructor(instructorAddress)  {
        // instructors[latestInstructorId] = Instructor(
        //     latestInstructorId,
        //     instructorAddress,
        //     name
        // );
        instructors.push(
            Instructor(
            latestInstructorId,
            instructorAddress,
            name
          )
        );

        // Instructor storage instructor = instructors[
        //     instructors.length
        // ];
        // instructor.name = name;
        // instructor.id = latestInstructorId;
        // instructor.instructorEthAddress =instructorAddress;
        latestInstructorId++;
    }

    function getAllInstructor() external view returns(Instructor[] memory){
        return instructors;
    }

    function createCourse(
        string calldata name,
        string calldata description,
        uint256 duration,
        uint256 stakingAmount
    ) external {
        uint128 instructorID = getInstructorId(msg.sender);
        require(instructorID != 999999999999, "Instructor do not exist");
        courses[instructorID].push(Course(
            latestCourseId,
            instructorID,
            name,
            description,
            duration,
            stakingAmount
        ));

        emit CreateCourse(
            latestCourseId,
            block.timestamp
        );

        latestCourseId++;
    }

    function stake(
        address studentAddress,
        uint128 courseId,
        uint256 amount
    ) internal {
        stakingAmounts[studentAddress][courseId] = amount;
    }

    function getCourse(
        uint128 courseId,
        uint128 instructorId
    ) public view returns (Course memory) {
         Course[] memory allCourses = courses[instructorId];
         for (uint i = 0; i < allCourses.length; i++) {
            if(allCourses[i].id == courseId){
                return allCourses[i];
            }
         }
         revert("Course not found");
    }

    function enrollCourse(
        uint128 courseId,
        uint128 instructorId
    ) external payable courseExist(courseId) isStudent(msg.sender){
        Course memory course = getCourse(courseId, instructorId);
        require(msg.value == course.stakingAmount, "Staking amount not corrcet");
        courseEnrollment[courseId].push(msg.sender);
        stake(msg.sender, courseId, msg.value);
    }

    function assignMarks(
        uint128 courseId,
        address studentAddress,
        uint256 number
    ) external isInstructor(msg.sender) {
        marks[studentAddress][courseId] = number;        
    }

    function issueCertificate(
        address studentAddress
    ) external isInstructor(msg.sender) isStudent(studentAddress){
        IERC721(nftAddress).safeMint(studentAddress);
    }

    function distributeStakes() external{
        uint128 instructorID = getInstructorId(msg.sender);
        require(instructorID != 999999999999, "Instructor do not exist");
        Course[] memory allCourses = courses[instructorID];
        for (uint i = 0; i < allCourses.length; i++) {
            uint128 courseId = allCourses[i].id;
            address[] memory studentAddresses = courseEnrollment[courseId];
            for (uint j = 0; j < studentAddresses.length; i++) {
                address studetAddress = studentAddresses[j];
                if(marks[studetAddress][courseId] > 0){
                     bool sent = payable(studentAddresses[j]).send(stakingAmounts[studetAddress][courseId]);
                     require(sent, "Failed to send Ether");
                     stakingAmounts[studetAddress][courseId] = 0;
                }
            }
        }
    }

    function distributeStake(
        uint128 courseId
    ) external isStudent(msg.sender){
        if(marks[msg.sender][courseId] > 0){
            bool sent = payable(msg.sender).send(stakingAmounts[msg.sender][courseId]);
            require(sent, "Failed to send Ether");
        }
    }

    function getCourses(
        uint128 instructorId
    ) external view returns(Course[] memory){
        return courses[instructorId];        
    }

    function getEnrolledStudents(
        uint128 courseId
    ) external view returns(Student[] memory){
        address[] memory allStudentAddresses = courseEnrollment[courseId];
        uint256 numberOfStudents = allStudentAddresses.length;
        Student[] memory allStudentsEnrolled = new Student[](numberOfStudents);
        for (uint i = 0; i < allStudentAddresses.length; i++) {
            allStudentsEnrolled[i] = students[allStudentAddresses[i]];
        }
        return allStudentsEnrolled;
    }

    function getTotalCertificates(
    ) external view isStudent(msg.sender) returns(uint256){
        return IERC721(nftAddress).balanceOf(msg.sender);
    }

    function getStudent(
        address studentAddress
    ) external view isStudent(studentAddress) returns(Student memory){
        return students[studentAddress];
    }
 
}