pragma  solidity ^0.4.25;

contract Class{

    struct student {
        //information includes student name and marks
        string name;
        uint marks;}
    
    //Currently we allocate each valid Student user on information submission a Unique id(i.e uuid)
    uint public uuid = 1;// uuid =0 is special case stores for checking empty inputs
    address class_proctor; //naming for Contract Owner
    
    /* Events */
    
    event show_details_event(string _name, uint _marks);
    
    /*
    Mappings to be using:
        1. array : It maps user wallet address with after unique id
        2. users : It maps student's uuid with their information */
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