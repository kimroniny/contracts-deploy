pragma solidity ^0.4.25;

import "./CharityCreator.sol";


contract CharityGetter is CharityCreator {
    
    // 通过address从mapping admins中获取admin信息
    function getAdminByAddr(address _addr) public view returns (
        string memory name, 
        string memory phone, 
        string memory idCard
    ){
        Admin memory admin = admins[_addr];
        return (
            admin.name,
            admin.phone, 
            admin.idCard
        );
    }

    // 通过address从mapping donors中获取donor信息
    function getDonorByAddr(address _addr) onlyAdminandLA public view returns (
        string memory name, 
        uint balance 
    ){
        Donor memory donor = donors[_addr];
        return (
            donor.name, 
            donor.balance
        );
    }

    function getAllDonors() onlyAdminandLA public view returns (address[] memory) {
        return donorAddrs;
    }

    // 通过address从mapping donoreds中获取donored信息
    function getDonoredByAddr(address _addr) onlyAdminandLA public view returns (
        string memory name, 
        uint balance 
    ){
        Donored memory donored = donoreds[_addr];
        return (
            donored.name, 
            donored.balance
        );
    }

    function getAllDonoreds() onlyAdminandLA public view returns (address[] memory) {
        return donoredAddrs;
    }

    // 通过donored的区块链地址address从mapping fundIndexesOf中获取该受捐人所有的项目
    function getFundIndexesByDonored(address _addr) public view returns (uint[] memory) {
        return fundIndexesOf[_addr];
    }

    // 通过受捐人的index从funds中获取fund的基本信息
    // 因为不能返回二级数组，所以record使用其他方式获得
    function getFundByIndex(uint index) public view returns (
        string memory name,
        uint typeOffounder,
        uint amount,
        uint target,
        uint startTime,
        uint endTime
    ) {
        require(index < funds.length);
        Fund memory fund = funds[index];
        return (
            fund.name, 
            fund.typeOffounder,
            fund.amount, 
            fund.target, 
            fund.startTime, 
            fund.endTime
        );
    }

    // 获得募捐项目被捐款记录的数量
    // 方便后面获取对应记录时，判断recordIndex是否在合法范围内
    function getRecLenOfFundByIndex(uint index) public view returns (uint) {
        require(index < funds.length);
        return funds[index].records.length;
    }


    // 通过fundIndex获取fund对应的记录长度len
    // 使用require判断recordIndex是否小于len，然后再从funds[fundIndex]的records中获取对应的记录
    function getRecordByIndex(uint fundIndex, uint recordIndex) public view returns (
        address donor,
        uint timestamp,
        uint amount
    ) {
        uint len = this.getRecLenOfFundByIndex(fundIndex);
        require(len > recordIndex);
        Record memory record = funds[fundIndex].records[recordIndex];
        return (
            record.donor, 
            record.timestamp,
            record.amount
        );
    }


}