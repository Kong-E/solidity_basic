// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Counter {
    // TX = 1) Invocation, 2) Payment
    // 1. DATA
    //  * value: private 컨트랙트 내에서만 호출 가능
    //  * owner: public
    // 2. ACTIONS
    //  * getValue: public
    //  * increment: public, payable = 컨트랙트 내에 있는 함수가 이더를 받을 수 있음
    //  * reset: public, 그런데 owner만 호출 가능
    //  * withdraw: owner만 호출 가능한 함수
    // 3. EVENTS
    //  * Reset 기록 한번에 조회할 수 있게
    uint private value = 0;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    event Reset(address owner, uint currentValue);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only Owner!");
        _;
    }

    modifier costs(uint amount) {
        require(msg.value >= amount * 1 ether);
        _;
    }
    
    function reset() public onlyOwner {
        emit Reset(msg.sender, value);
        value = 0;
    }

    function getValue() public view returns (uint) {
        return value;
        // view: 스토리지를 읽기만 함
        // pure: 스토리지를 읽지도 않고, 순수한 함수(연산 등)
        // constant
        // payable
    }

    function increment() public payable costs(1) {
        // 1) 전역 변수: msg.sender, msg.value
        // assert, revert(에러 촉발), require
        /* if (msg.value == 1 ether) {
        } else {
            revert("1 Ether")
        } 의 줄임말 = require*/
        value = value + 1;
    }

    function withdraw() public onlyOwner {
        // address.transfer == 실패했을 떄 revert, .send == 전송 실패했을 때 false만 리턴, .call{gas:, value:}
        payable(owner).transfer(address(this).balance); // 컨트랙트에 모았던 돈들이 나한테 옴.
    }
}