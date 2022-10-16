//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract ContractOne{

    mapping(address => uint) public addressBalances;

    function deposit() public payable{
        addressBalances[msg.sender] += msg.value;
    }
}

contract ContractTwo {

    receive() external payable{}

    function depositContractOne(address _contractOne) public {
        // what if we do not know if the contract one is a smart contract
        // how to encode a call that actually call the right function
        //ContractOne one = ContractOne(_contractOne)
        // first 4 bytesfirts 8 hex value, they define what kinf of function is going to be called
        //one.deposit{value: 10, gas: 100000}();

        //bytes memory payload = abi.encodeWithSignature("deposit()");
        (bool success, ) = _contractOne.call{value: 10, gas: 100000}("");//this is how you can call any kind of function of a smart contract with specific call data
        require(success);

        //what if we do  not know anythong about the smart contract

    }



}

