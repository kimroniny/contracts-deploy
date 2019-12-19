/**
    创建：
        管理员
        捐赠者
        被捐赠者
    返回值：
        index

 */
pragma solidity ^0.4.25;

import "./CharityBasicInfo.sol";

contract CharityCreator is CharityBasicInfo {

    // 创建任何一个object时都要先判断其是否已经存在
    // 时间原因，tmd先不写了

    function createListenAccount(address _addr) onlyPlatform public {
        listenAccount = _addr;
    }

    function createAdmin(
        address addr,
        string memory name, 
        string memory phone, 
        string memory idCard        
    ) public returns (uint){
        admins[addr] = Admin(name, phone, idCard);
        adminAddrs.length++;
        adminAddrs[adminAddrs.length-1] = addr;
        return adminAddrs.length;
    }

    function createDonor(
        address addr,
        string memory name, 
        uint balance      
    ) onlyAdmin public returns (uint){
        donors[addr] = Donor(name, balance);
        donorAddrs.length++;
        donorAddrs[donorAddrs.length-1] = addr;
        return donorAddrs.length;
    }

    function createDonored(
        address addr,
        string memory name, 
        uint balance      
    ) onlyAdmin public returns (uint){
        donoreds[addr] = Donored(name, balance);
        donoredAddrs.length++;
        donoredAddrs[donoredAddrs.length-1] = addr;
        return donoredAddrs.length;
    }

    function createFund(
        string memory name,
        uint amount,
        uint target,
        uint startTime,
        uint endTime
    ) public returns (uint) {
        uint flag = identity(msg.sender);
        require(flag == 1 || flag == 0);
        funds.length++;        
        funds[funds.length-1].founder = msg.sender;
        funds[funds.length-1].name = name;
        funds[funds.length-1].typeOffounder = flag;
        funds[funds.length-1].amount = amount;
        funds[funds.length-1].target = target;
        funds[funds.length-1].startTime = startTime;
        funds[funds.length-1].endTime = endTime;
        uint index = ++fundIndexesOf[msg.sender].length;
        fundIndexesOf[msg.sender][index-1] = funds.length-1;
        return funds.length;
    }

}