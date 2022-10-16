//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract Sender {
    receive() external payable{}

    function withdrawTransfer(address payable _to) public {
        _to.transfer(10);
    }

    function withdrawSend(address payable _to) public {
        _to.send(10);
    }
}


contract ReceiverNoAction{
    function balance() public view returns(uint){
        return address(this).balance;
    }

    receive() external payable{}
}

contract ReceiverAction{
    uint public balanceReceived;
    receive() external payable{
        balanceReceived += msg.value; // run out of gas
    }

    function balance() public view returns(uint){
        return address(this).balance;
    }
//trnasfer thorug an error when transfer fail, send function wiil return a boolean
//send is a low level function bool
//external function call if we know the samrt contract
// low level calls if we dont know the samrt contract



}
