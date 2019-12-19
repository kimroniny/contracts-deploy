pragma solidity ^0.4.25;

import "./CharityInOut.sol";

contract Charity is CharityInOut {

    function donate(

        uint fundIndex

    ) onlyDonor public payable {

        require(
            fundIndex < funds.length, 
            "募捐项目索引号超出项目数量"
        );

        Fund storage fund = funds[fundIndex];

        require(
            now < fund.endTime && fund.target > fund.amount, 
            "该项目已经结束"
        );

        require(
            msg.value > 0,
            "捐赠金额不能为0"
        );

        // 获取募捐项目创建者的地址
        address target = address(uint160(fund.founder));

        // diff: 距募捐目标金额还有多少差距
        // amount: 最终转账数额
        uint diff = (fund.target-fund.amount) * 1 ether;
        uint amount = 0;
        if (diff >= msg.value) {
            target.transfer(msg.value);
            amount = msg.value;
        }else {
            target.transfer(diff);
            msg.sender.transfer(msg.value - diff);
            amount = diff; 
        }

        // 同步募捐项目、受捐者以及捐赠者的存储状态
        fund.amount += amount;
        donoreds[target].balance += amount;
        donors[msg.sender].balance -= amount;
        
        // 将当前募捐记录存储到该项目的record里
        fund.records[fund.records.length++] = Record(
            msg.sender,
            now,
            amount
        );
    }

    function () external payable {
        
    }
}