// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Will {
    address owner;
    uint    fortune;
    bool    deceased;

    // payable = 함수가 이더를 보내고 받을 수 있게 함
    constructor() payable public {
        owner = msg.sender; // msg sender represents address that is being called
        fortune = msg.value; // msg value tells us how much ether is being sent
        deceased = false;
    }

    // create modifier so the only person who can cal the contract is the owner
    modifier onlyOwner {
        require(msg.sender == owner);
        _; // 조건에 맞는 사람만 함수를 실행
    }


    // create modifier so that we only allocate funds if frined's gramps deceased(돌아가셨을 경우에만 자산 배분)
    modifier mustBeDeceased {
        require(deceased == true);
        _; // 조건에 맞는 사람만 함수를 실행
    }

    // list of family wallets
    address payable[] familyWallets;

    // map through inheritance, key와 value를 가짐
    mapping(address => uint) inheritance;

    // set inheritance for each address
    function setInheritance(address payable wallet, uint amount) public onlyOwner {
        familyWallets.push(wallet);
        inheritance[wallet] = amount;
    }

    function payout() private mustBeDeceased {
        for(uint i=0; i<familyWallets.length; i++) {
            familyWallets[i].transfer(inheritance[familyWallets[i]]);
            // transfering the funds from contract address to receiver address
        }
    }

    // oracle switch simulation
    function hasDeceased() public onlyOwner {
        deceased = true;
        payout();
    }
}