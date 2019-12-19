pragma solidity ^0.4.25;

import "./CharityGetter.sol";

contract CharityInOut is CharityGetter {

    // 充值操作：用户将现实货币打到平台账户，平台将代币转移给用户
    // 操作人：admin
    // from: platform
    // to: donor / donored
    function topUp(address _addr) onlyPlatform payable public returns (uint) {
        _addr.transfer(msg.value);
        donors[_addr].balance += msg.value;
        return msg.sender.balance;
    }

    // 提现操作：将代币从用户转移到平台，平台将现实货币发送到用户银行卡账户
    // 操作人： 捐款人、被捐款人
    // from: donor / donored
    // to: platform
    function withDraw() payable public returns (uint) {
        uint flag = identity(msg.sender);
        require(flag == 0 || flag == 2);
        platform.transfer(msg.value);
        if (flag == 0) { // donored
            donoreds[msg.sender].balance -= msg.value;
            return donoreds[msg.sender].balance;
        }else if (flag == 2) { // donor
            donors[msg.sender].balance -= msg.value;
            return donors[msg.sender].balance;
        }
    }

}