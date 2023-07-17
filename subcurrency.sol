// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Coin {
    // the keyword public it's making the variables
    // here accessible from other contracts
    address public minter;
    mapping(address => uint) public balances;

    event Sent(address from, address to, uint amount);

    // only runs when we deploy contract
    constructor() {
        minter = msg.sender;
    }

    // make new coins and send them to an address
    // only the owner can send these coins
    function mint(address receiver, uint amount) public {
        require(msg.sender == minter);
        balances[receiver] += amount;
    }

    //send any amount of coins
    // to an existing address

    error insufficientBalance(uint requested, uint available);

    function send(address receiver, uint amount) public payable {
        // require amount to be greater than x and then run this
        if (amount > balances[msg.sender])
            revert insufficientBalance({
                requested: amount,
                available: balances[msg.sender]
            });
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}