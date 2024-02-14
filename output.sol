
pragma solidity ^0.4.24;

contract Whitelist {
    address public owner;
    address public checker;
    mapping(address => bool) public whitelist;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function setChecker(address _checker) public onlyOwner {
        checker = _checker;
    }

    function approve(address _wallet) public onlyOwner {
        whitelist[_wallet] = true;
    }

    function revoke(address _wallet) public onlyOwner {
        whitelist[_wallet] = false;
    }

    function isApproved(address _wallet) public view returns (bool) {
        return whitelist[_wallet];
    }

    function changeOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }
}
