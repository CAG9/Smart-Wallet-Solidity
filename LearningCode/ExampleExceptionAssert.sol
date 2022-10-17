//SPDX-License-Identifier: MIT
pragma solidity 0.7.0;


contract ExampleExceptionAssert{
    //assert is to chech invariance; invariance are state that our contract of variable should never reach
    mapping(address => uint8) public balanceReceived;

    function receiveMoney() public payable{
        //will take all our gas and enter to a panic code 
        assert(msg.value == uint8(msg.value));
        balanceReceived[msg.sender] += uint8(msg.value);
    }

    function withdrawMoney(address payable _to, uint8 _amount) public {
        require(_amount <= balanceReceived[msg.sender], "Not enough fund, aborting!");
        balanceReceived[msg.sender] -= _amount;
        _to.transfer(_amount);
    }

}
