# dapp.school

<a href="https://hakkerska.github.io/"> Click!!! here for demo.</a>

A simple dapp using ethereum blockchain for marks management. This dapp is only for education purpose and cannot be used for real life applications. For one please contact me on my email and for tutorials on "How to build smart contract using solidity" do subscribe to my youtube channel @ <a href="https://www.youtube.com/channel/UC8hfIQCICRpu-6UW28waDzw">Subscribe Here</a>

Here in the dapp we have a proctor (a person who can manage the students data) and students (who can see or add their details to the blockchain)

For simplicity we have taken only student name and marks as details which we are going to be stored on blockchain.


Requirements - 
- Remix browser
- Metamask 
- Test network (can use ganache or any network like rinkeby/ropston etc) 
- Editor
- Xampp
- Web3.js 

Here i have use remix to deploy my smartcontract to test network and later on rinkeby network but you can even use truffle to do so (then you did not need xampp and remix).
if you are beginer i will suggest you to go with remix. :)


Let's see what's here inside the smart contract.



    pragma  solidity ^0.4.25;  //Version of Solidity

    contract Class{


// A sturture which will hold the details of student which are name of student and his marks. You can customise it as per your need.


    struct student {
        string name;
        uint marks;
        }
    

// Each student will have a unique id, which will be allocated on the basis of FCFS i.e. first student will get id = 1, second will get 2 and so on. 
    
    uint public uuid = 1;       // uuid =0 is special case stores for checking empty inputs
    address class_proctor;      //naming for Contract Owner
    
/* Events */
    

    event show_details_event(string _name, uint _marks);
    
/*
Mappings to be used:
1. array : It maps user wallet address with after unique id
2. users : It maps student's uuid with their information 
*/    
    
    
    mapping(address => uint) array;
    mapping(uint => student) users;
    mapping(address => bool) onlyOnce;
    
    
//when contract deploys
    
    constructor() public{
        class_proctor = msg.sender; // storing Contract owwner address 
        }
    
   
    modifier onlyOwner() {
        // Allows only class_proctor or admin acess
        require(msg.sender == class_proctor, "UnAuthorized Owner!! ");
        _; }
    
    
    modifier checkdetails(uint marks, string _name) {
        // Checks for valid Inputs --- i.e. Valid name(non-empty string) and valid marks( b/w 0-100)
        bytes memory temp_name = bytes(_name);
        require( temp_name.length !=0, "Name Column is Empty!! ");
        require(marks <= 100, "Marks must be between 0-100 ");
        _; }
        
    modifier check_uuid(uint id){
        //uuid =0 is special case that is reserved to check for empty argument (in case of remix only)
        require(id !=0, "Please don't let the Inputs empty");
        _;}
        
    modifier checkonlyOnce() {
        require(msg.sender != class_proctor, "You can not perform this task.");
        require(onlyOnce[msg.sender] == false, "Already Registered");
        _;
    }    
    
    modifier notadmin() {
        require(msg.sender != class_proctor, "Only students can see their details");
        _;
    }
    
    function add_details(string _name, uint _marks) public checkonlyOnce() checkdetails(_marks,_name) returns(uint) {
        /*
        It is called by student in-order to fill their academic related information in contract.
        The User wiil get a Unique Id after information submission
        The User info  wiil be added into only after valid submission..  */
        users[uuid] = student(_name,_marks);
        array[msg.sender] = uuid;
        onlyOnce[msg.sender] = true;
        return uuid++; }
        
    
    function show_details() external notadmin()
    //returns(string, uint)
    {
        /* 
        It allows valid student to acess his/her info if submitted
        Check for Valid Student based on wallet he/she users. */
        uint userId = array[msg.sender];
        emit show_details_event(users[userId].name,users[userId].marks);
        //return (users[userId].name, users[userId].marks);
        }

    
    function admin_showStudent(uint id) external onlyOwner() check_uuid(id)
    //returns(string, uint)
    {
        //Admin Acess to display Student details using valid uuid
        if (id > uuid-1){
            revert("Invalid UUID for student"); }
            emit show_details_event(users[id].name,users[id].marks);
        //return (users[id].name, users[id].marks); 
        }
    
    }



    