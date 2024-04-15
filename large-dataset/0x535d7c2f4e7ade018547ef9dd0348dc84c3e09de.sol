// SPDX-License-Identifier: MIT



pragma solidity ^0.7.3;





contract Ownable {



    address private owner;

    

    event OwnerSet(address indexed oldOwner, address indexed newOwner);

    

    modifier onlyOwner() {

        require(msg.sender == owner, "Caller is not owner");

        _;

    }

    

    constructor() {

        owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor

        emit OwnerSet(address(0), owner);

    }



    function changeOwner(address newOwner) public onlyOwner {

        emit OwnerSet(owner, newOwner);

        owner = newOwner;

    }



    function getOwner() external view returns (address) {

        return owner;

    }

}



library SafeMath {



    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        return div(a, b, "SafeMath: division by zero");

    }



    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b > 0, errorMessage);

        uint256 c = a / b;

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold



        return c;

    }



}



interface Token {

    function tokensSold(address buyer, uint256 amount) external  returns (bool success);

    function balanceOf(address _owner) external view returns (uint256 balance);

    function burn(uint256 _value) external returns (bool success);

}



contract VRGSale is Ownable{

    

    using SafeMath for uint256;

    

    uint256 public psalePrice;

    uint256 public csalePrice;

    uint256 public totalSold;

    address public tokenAddress;

    address payable public walletAddress;

    uint256 public privateSaleStart = 1608397200;

    uint256 public privateSaleEnd = 1608933600;

    uint256 public crowdSaleStart = 1609002000;

    uint256 public crowdSaleEnd = 1609711200;

    event TokensSold(address indexed to, uint256 amount);

    

    constructor() {

        psalePrice = uint256(25000000000000);

        csalePrice = uint256(30000000000000);

        walletAddress = 0x4514CFBB6C80a46fd64484c19d0442fa5cb80EF1;

        tokenAddress = address(0x0);

    }

    

    receive() external payable {

        buy();

    }

    

    function setToken(address _tokenAddress) onlyOwner public {

        require(tokenAddress == address(0x0), "Token is set");

        tokenAddress = _tokenAddress;

    }

    

    function buy() public payable {

        require(((block.timestamp > privateSaleStart) && (block.timestamp < privateSaleEnd)) || ((block.timestamp > crowdSaleStart) && (block.timestamp < crowdSaleEnd)), "Contract is not selling tokens");

        uint256 weiValue = msg.value;

        require(weiValue >= (10 ** 17));

        uint256 amount = 0;

        if ((block.timestamp > privateSaleStart) && (block.timestamp < privateSaleEnd)) {

            require(weiValue <= 10 ether, "Maximum amount on private sale is 10ETH");

            amount = weiValue.div(psalePrice) * (1 ether);

            require((amount + totalSold) <= (6000000 ether), "That quantity is not available");

        } else {

            require(weiValue <= 15 ether, "Maximum amount on crowdsale is 15ETH");

            amount = weiValue.div(csalePrice)  * (1 ether);

        }

        Token token = Token(tokenAddress);

        require(walletAddress.send(weiValue));

        require(token.tokensSold(msg.sender, amount));

        totalSold += amount;

        emit TokensSold(msg.sender, amount);

    }

    

    function burnUnsold() onlyOwner public {

        require(block.timestamp > crowdSaleEnd);

        Token token = Token(tokenAddress);

        uint256 amount = token.balanceOf(address(this));

        token.burn(amount);

    }

    

}
