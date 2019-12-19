pragma solidity ^0.4.25;

contract CharityBasicInfo {
    struct Admin {
        string name;
        string phone;
        string idCard;
    }

    struct Donor {
        string name;
        uint balance;
    }

    struct Donored {
        string name;
        uint balance;
    }

    struct Fund {
        address founder;
        string name;
        uint typeOffounder; // 0: 捐赠者创建的，1: 受捐者创建的
        uint amount; // 已经筹到的金额
        uint target;
        uint startTime;
        uint endTime;
        Record[] records; //该项目被捐赠的记录
    }

    struct Record {
        address donor;
        uint timestamp;
        uint amount;
    }

    mapping (address => Admin) public admins;
    mapping (address => Donor) public donors;
    mapping (address => Donored) public donoreds;
    mapping (address => uint[]) public fundIndexesOf;

    address[] public adminAddrs;
    address[] public donorAddrs;
    address[] public donoredAddrs;

    Fund[] public funds;

    address public platform;
    address public listenAccount;

    // 0: 受捐人
    // 1: 管理员
    // 2: 捐款人
    function identity(address _addr) internal view returns (uint) {
        
        uint i = 0;

        for (i = 0; i < donoredAddrs.length; i++){
            if (donoredAddrs[i] == _addr) return 0;
        }

        for (i = 0; i < adminAddrs.length; i++){
            if (adminAddrs[i] == _addr) return 1;
        }

        for (i = 0; i < donorAddrs.length; i++){
            if (donorAddrs[i] == _addr) return 2;
        }

        if (_addr == listenAccount) return 3;
        
        return 404;
    } 

    modifier onlyPlatform() {
        require(msg.sender == platform);
        _;
    }

    modifier onlyAdmin(){
        require(identity(msg.sender) == 1);
        _;
    }

    modifier onlyDonored(){
        require(identity(msg.sender) == 0);
        _;
    }

    modifier onlyDonor(){
        require(identity(msg.sender) == 2);
        _;
    }

    modifier onlyAdminandLA(){
        uint flag = identity(msg.sender);
        require(flag==1 || flag==3);
        _;
    }


    constructor () public {
        platform = msg.sender;
    }

}