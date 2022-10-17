//SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

contract Consumer{
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
    function deposit() public payable{}
}

contract SmartContractWallet {

    address payable public owner;

    mapping(address => uint) public allowance;
    mapping(address => bool) public isAllowedToSend;

    mapping(address => bool) public guardians;
    address payable nextOwner;
    mapping(address => mapping(address => bool)) public nextOwnerGuardianVotedBool;
    mapping(address => uint) public pool;
    uint public guardiansResetCount;
    uint public constant confirmationsFromGuardiansForReset = 3;

    constructor() {
        owner = payable(msg.sender); //set the owner of the samart wallet
    }
    // set the guardians if you are the ownner
    function setGuardian(address _guardian, bool _isGuardian) public {
        require(msg.sender == owner, "You are not the owner, aborting");
        guardians[_guardian] = _isGuardian;
    }

    // create a simple voting to propose a new owner, yo be able to vote you need to be a guardian
    function proposeNewOwner(address payable _newOwner) public{
        require(guardians[msg.sender], "You are not a guardian of thos wallet, aborting");
        require(nextOwnerGuardianVotedBool[_newOwner][msg.sender] == false, "You already voted, aborting");
        nextOwnerGuardianVotedBool[_newOwner][msg.sender] = true;
        if(_newOwner != nextOwner){
            nextOwner = _newOwner;
            guardiansResetCount = 0;
        }
        //guardiansResetCount++;
        pool[_newOwner] +=1;
        //mapping(address =>mapping(address => uint)) public pool;

        if(pool[_newOwner] >= confirmationsFromGuardiansForReset){
            owner = nextOwner;
            nextOwner = payable(address(0));
        }
    }

    // get privilage to send money to another account and the amount
    function setAllowance(address _for, uint _amount) public{
        require(msg.sender == owner, "you are not the owner, aborting");
        allowance[_for] = _amount;

        if(_amount > 0){
            isAllowedToSend[_for] = true;
        }else{
            isAllowedToSend[_for] = false;
        }
    }
    //transfer to another oaccount
    function transfer(address payable _to, uint _amount, bytes memory _payload) public returns(bytes memory){
        //require(msg.sender == owner, "You are not the owner, aborting");
        if(msg.sender != owner){
            require(isAllowedToSend[msg.sender],"You are now allowed to send anything from this smart contract, aborting");
            require(allowance[msg.sender] >= _amount,"You are trying to send more than you are allowed to, aborting");

            allowance[msg.sender] -= _amount;
        }

        (bool sucess, bytes memory returnData) = _to.call{value: _amount}(_payload);
        require(sucess, "Aborting, call was not successful");
        return returnData;
    }

    receive() external payable{}

}
