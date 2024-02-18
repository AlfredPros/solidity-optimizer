// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// Some codes here are not optimized for readability purpose
interface IERC20 {
    function approve(address spender, uint value) external;
    function transfer(address to, uint value) external;
    function transferFrom(address from, address to, uint value) external;
    function allowanced(address tokenOwner, address spender) external view returns (uint);
    function balanceOf(address user) external view returns (uint);
    function totalSupply() external view returns (uint);
}

// roughly 32 minutes for the basic ERC20
// Took 1 hour (+30 mins) to finish everything (with a little bit of looking up)
// +- 15 minutes for safeMath and testing
// +- 15 minutes for interface and bug fixing
contract erc20 is IERC20 {
    string public name = "AlfredKuhlmanToken";
    string public symbol = "AKT";
    uint public totalSupply = 1000;
    mapping(address => uint) allUser;
    mapping(address => mapping(address => uint)) allowance;
    address public owner;
    uint public moneyStore = 0;  // Optional

    constructor () {
        owner = msg.sender;
        allUser[msg.sender] = totalSupply;
    }

    function safeSub(uint a, uint b) pure private returns(uint c) {  // Optional
        require(a > b);
        c = a - b;
    }
    function safeAdd(uint a, uint b) pure private returns(uint c) {  // Optional
        c = a + b;
        require(c >= a);
    }

    function ownerSupply() public view returns(uint) {
        return allUser[owner];
    }

    function balanceOf(address user) public view returns (uint) {
        return allUser[user];
    }

    function allowanced(address tokenOwner, address spender) public view returns (uint) {
        if (tokenOwner == spender) revert();  // Not necessary
        return allowance[tokenOwner][spender];
    }

    function transfer(address to, uint value) public {
        if (allUser[msg.sender] < value || msg.sender == to) revert();
        allUser[msg.sender] -= value;
        allUser[to] = safeAdd(allUser[to], value);
    }

    function approve(address spender, uint value) public {
        if (allUser[msg.sender] < value || msg.sender == spender) revert();
        allowance[msg.sender][spender] = value;
    }

    function transferFrom(address from, address to, uint value) public {
        if (allowance[from][msg.sender] < value || allUser[from] < value) revert();
        allUser[from] -= value;
        allowance[from][msg.sender] -= value;
        allUser[to] = safeAdd(allUser[to], value);
    }

    function burn(uint value) public {
        if (msg.sender == owner) revert();
        if (allUser[msg.sender] < value) revert();
        allUser[msg.sender] -= value;
        totalSupply -= value;
    }

    function burnFrom(address from, uint value) public {
        if (msg.sender == owner) revert();
        if (allowance[from][msg.sender] < value || allUser[from] < value) revert();
        allUser[from] -= value;
        allowance[from][msg.sender] -= value;
        totalSupply -= value;
    }

    function buy() public payable {
        if (msg.sender == owner) revert();
        if (msg.value % 1 ether != 0 || msg.value < 1 ether) revert();
        
        moneyStore = safeAdd(moneyStore, msg.value);
        uint buyValue = (msg.value/1 ether) * 5;
        if (allUser[owner] < buyValue) revert();

        allUser[msg.sender] = safeAdd(allUser[msg.sender], buyValue);
        allUser[owner] -= buyValue;
    }

    function transferOwner(address ownerTo) public {
        if (msg.sender != owner) revert();
        allUser[ownerTo] = safeAdd(allUser[ownerTo], allUser[owner]);
        allUser[owner] = 0;
        owner = ownerTo;
    }

    function retrieve() public payable {
        if (msg.sender != owner || address(this).balance == 0) revert();
        payable(msg.sender).transfer(address(this).balance);
        moneyStore = 0;
    }

}