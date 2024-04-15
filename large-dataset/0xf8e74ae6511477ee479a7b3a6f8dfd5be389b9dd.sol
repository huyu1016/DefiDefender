// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol



pragma solidity ^0.4.24;





/**

 * @title ERC20Basic

 * @dev Simpler version of ERC20 interface

 * See https://github.com/ethereum/EIPs/issues/179

 */

contract ERC20Basic {

  function totalSupply() public view returns (uint256);

  function balanceOf(address _who) public view returns (uint256);

  function transfer(address _to, uint256 _value) public returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);

}



// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol



pragma solidity ^0.4.24;







/**

 * @title ERC20 interface

 * @dev see https://github.com/ethereum/EIPs/issues/20

 */

contract ERC20 is ERC20Basic {

  function allowance(address _owner, address _spender)

    public view returns (uint256);



  function transferFrom(address _from, address _to, uint256 _value)

    public returns (bool);



  function approve(address _spender, uint256 _value) public returns (bool);

  event Approval(

    address indexed owner,

    address indexed spender,

    uint256 value

  );

}



// File: openzeppelin-solidity/contracts/math/SafeMath.sol



pragma solidity ^0.4.24;





/**

 * @title SafeMath

 * @dev Math operations with safety checks that throw on error

 */

library SafeMath {



  /**

  * @dev Multiplies two numbers, throws on overflow.

  */

  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {

    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the

    // benefit is lost if 'b' is also tested.

    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522

    if (_a == 0) {

      return 0;

    }



    c = _a * _b;

    assert(c / _a == _b);

    return c;

  }



  /**

  * @dev Integer division of two numbers, truncating the quotient.

  */

  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {

    // assert(_b > 0); // Solidity automatically throws when dividing by 0

    // uint256 c = _a / _b;

    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold

    return _a / _b;

  }



  /**

  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).

  */

  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {

    assert(_b <= _a);

    return _a - _b;

  }



  /**

  * @dev Adds two numbers, throws on overflow.

  */

  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {

    c = _a + _b;

    assert(c >= _a);

    return c;

  }

}



// File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol



pragma solidity ^0.4.24;









/**

 * @title SafeERC20

 * @dev Wrappers around ERC20 operations that throw on failure.

 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,

 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.

 */

library SafeERC20 {

  function safeTransfer(

    ERC20Basic _token,

    address _to,

    uint256 _value

  )

    internal

  {

    require(_token.transfer(_to, _value));

  }



  function safeTransferFrom(

    ERC20 _token,

    address _from,

    address _to,

    uint256 _value

  )

    internal

  {

    require(_token.transferFrom(_from, _to, _value));

  }



  function safeApprove(

    ERC20 _token,

    address _spender,

    uint256 _value

  )

    internal

  {

    require(_token.approve(_spender, _value));

  }

}



// File: contracts/Utils/Ownable.sol



pragma solidity ^0.4.24;



/**

 * @title Ownable

 * @dev The Ownable contract has an owner address, and provides basic authorization control

 * functions, this simplifies the implementation of "user permissions".

 */

contract Ownable {

  address public owner;





  event OwnershipRenounced(address indexed previousOwner);

  event OwnershipTransferred(

    address indexed previousOwner,

    address indexed newOwner

  );





  /**

   * @dev The Ownable constructor sets the original `owner` of the contract to the sender

   * account.

   */

  constructor() public {

    owner = msg.sender;

  }



  /**

   * @dev Throws if called by any account other than the owner.

   */

  modifier onlyOwner() {

    require(msg.sender == owner, "msg.sender not owner");

    _;

  }



  /**

   * @dev Allows the current owner to relinquish control of the contract.

   * @notice Renouncing to ownership will leave the contract without an owner.

   * It will not be possible to call the functions with the `onlyOwner`

   * modifier anymore.

   */

  function renounceOwnership() public onlyOwner {

    emit OwnershipRenounced(owner);

    owner = address(0);

  }



  /**

   * @dev Allows the current owner to transfer control of the contract to a newOwner.

   * @param _newOwner The address to transfer ownership to.

   */

  function transferOwnership(address _newOwner) public onlyOwner {

    _transferOwnership(_newOwner);

  }



  /**

   * @dev Transfers control of the contract to a newOwner.

   * @param _newOwner The address to transfer ownership to.

   */

  function _transferOwnership(address _newOwner) internal {

    require(_newOwner != address(0), "_newOwner == 0");

    emit OwnershipTransferred(owner, _newOwner);

    owner = _newOwner;

  }

}



// File: contracts/Utils/Destructible.sol



pragma solidity ^0.4.24;





/**

 * @title Destructible

 * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.

 */

contract Destructible is Ownable {

  /**

   * @dev Transfers the current balance to the owner and terminates the contract.

   */

  function destroy() public onlyOwner {

    selfdestruct(owner);

  }



  function destroyAndSend(address _recipient) public onlyOwner {

    selfdestruct(_recipient);

  }

}



// File: contracts/Interfaces/IBadERC20.sol



pragma solidity ^0.4.24;



/**

 * @title Bad formed ERC20 token interface.

 * @dev The interface of the a bad formed ERC20 token.

 */

interface IBadERC20 {

    function transfer(address to, uint256 value) external;

    function approve(address spender, uint256 value) external;

    function transferFrom(

      address from,

      address to,

      uint256 value

    ) external;



    function totalSupply() external view returns (uint256);



    function balanceOf(

      address who

    ) external view returns (uint256);



    function allowance(

      address owner,

      address spender

    ) external view returns (uint256);



    event Transfer(

      address indexed from,

      address indexed to,

      uint256 value

    );

    event Approval(

      address indexed owner,

      address indexed spender,

      uint256 value

    );

}



// File: contracts/Utils/SafeTransfer.sol



pragma solidity ^0.4.24;





/**

 * @title SafeTransfer

 * @dev Transfer Bad ERC20 tokens

 */

library SafeTransfer {

/**

   * @dev Wrapping the ERC20 transferFrom function to avoid missing returns.

   * @param _tokenAddress The address of bad formed ERC20 token.

   * @param _from Transfer sender.

   * @param _to Transfer receiver.

   * @param _value Amount to be transfered.

   * @return Success of the safeTransferFrom.

   */



  function _safeTransferFrom(

    address _tokenAddress,

    address _from,

    address _to,

    uint256 _value

  )

    internal

    returns (bool result)

  {

    IBadERC20(_tokenAddress).transferFrom(_from, _to, _value);



    assembly {

      switch returndatasize()

      case 0 {                      // This is our BadToken

        result := not(0)            // result is true

      }

      case 32 {                     // This is our GoodToken

        returndatacopy(0, 0, 32)

        result := mload(0)          // result == returndata of external call

      }

      default {                     // This is not an ERC20 token

        revert(0, 0)

      }

    }

  }



  /**

   * @dev Wrapping the ERC20 transfer function to avoid missing returns.

   * @param _tokenAddress The address of bad formed ERC20 token.

   * @param _to Transfer receiver.

   * @param _amount Amount to be transfered.

   * @return Success of the safeTransfer.

   */

  function _safeTransfer(

    address _tokenAddress,

    address _to,

    uint _amount

  )

    internal

    returns (bool result)

  {

    IBadERC20(_tokenAddress).transfer(_to, _amount);



    assembly {

      switch returndatasize()

      case 0 {                      // This is our BadToken

        result := not(0)            // result is true

      }

      case 32 {                     // This is our GoodToken

        returndatacopy(0, 0, 32)

        result := mload(0)          // result == returndata of external call

      }

      default {                     // This is not an ERC20 token

        revert(0, 0)

      }

    }

  }



  function _safeApprove(

    address _token,

    address _spender,

    uint256 _value

  )

  internal

  returns (bool result)

  {

    IBadERC20(_token).approve(_spender, _value);



    assembly {

      switch returndatasize()

      case 0 {                      // This is our BadToken

        result := not(0)            // result is true

      }

      case 32 {                     // This is our GoodToken

        returndatacopy(0, 0, 32)

        result := mload(0)          // result == returndata of external call

      }

      default {                     // This is not an ERC20 token

        revert(0, 0)

      }

    }

  }

}



// File: contracts/Utils/Pausable.sol



pragma solidity ^0.4.24;







/**

 * @title Pausable

 * @dev Base contract which allows children to implement an emergency stop mechanism.

 */

contract Pausable is Ownable {

  event Pause();

  event Unpause();



  bool public paused = false;





  /**

   * @dev Modifier to make a function callable only when the contract is not paused.

   */

  modifier whenNotPaused() {

    require(!paused, "The contract is paused");

    _;

  }



  /**

   * @dev Modifier to make a function callable only when the contract is paused.

   */

  modifier whenPaused() {

    require(paused, "The contract is not paused");

    _;

  }



  /**

   * @dev called by the owner to pause, triggers stopped state

   */

  function pause() public onlyOwner whenNotPaused {

    paused = true;

    emit Pause();

  }



  /**

   * @dev called by the owner to unpause, returns to normal state

   */

  function unpause() public onlyOwner whenPaused {

    paused = false;

    emit Unpause();

  }

}



// File: contracts/Interfaces/MakerDAO.sol



pragma solidity ^0.4.0;



interface MakerDAO_ScdMcdMigration {

    // Function to swap SAI to DAI

    // This function is to be used by users that want to get new DAI in exchange of old one (aka SAI)

    // wad amount has to be <= the value pending to reach the debt ceiling (the minimum between general and ilk one)

    function swapSaiToDai(uint wad) external;

}



// This contract is intended to be executed via the Profile proxy of a user (DSProxy) which owns the SCD CDP

interface MakerDAO_MigrationProxyActions {

    function swapSaiToDai(

        address scdMcdMigration,            // Migration contract address

        uint wad                            // Amount to swap

    ) external;

}



// File: contracts/SaiDaiTokenSwap.sol



pragma solidity ^0.4.24;

















/**

 * @title TokenSwap.

 * @author Eidoo SAGL.

 * @dev A swap asset contract. The offerAmount and wantAmount are collected and sent into the contract itself.

 */

contract SaiDaiTokenSwap is Pausable, Destructible

{

  using SafeMath for uint;

  using SafeTransfer for ERC20;

  address constant ETHER = address(0);

  uint constant expScale = 1e18;

  uint constant rateDecimals = 18;

  uint constant rateUnit = 10 ** rateDecimals;



  ERC20 sai;

  ERC20 dai;

  address migration;

  MakerDAO_MigrationProxyActions proxy;



  event LogWithdrawToken(

    address indexed _from,

    address indexed _token,

    uint amount

  );



  event LogTokenSwap(

    address indexed _userAddress,

    address indexed _userSentTokenAddress,

    uint _userSentTokenAmount,

    address indexed _userReceivedTokenAddress,

    uint _userReceivedTokenAmount

  );



  constructor(

    address _sai,

    address _dai,

    address _migration,

    address _proxy

  )

    public

  {

    sai = ERC20(_sai);

    dai = ERC20(_dai);

    migration = _migration;

    proxy = MakerDAO_MigrationProxyActions(_proxy);

  }



  function() external {

    revert("fallback function not allowed");

  }



  /**

   * @dev Withdraw asset.

   * @param _tokenAddress Asset to be withdrawed.

   * @return bool.

   */

  function withdrawToken(address _tokenAddress)

    public

    onlyOwner

  {

    uint tokenBalance;

    if (_tokenAddress == ETHER) {

      tokenBalance = address(this).balance;

      msg.sender.transfer(tokenBalance);

    } else {

      tokenBalance = ERC20(_tokenAddress).balanceOf(address(this));

      ERC20(_tokenAddress)._safeTransfer(msg.sender, tokenBalance);

    }

    emit LogWithdrawToken(msg.sender, _tokenAddress, tokenBalance);

  }



  /******************* rate functions for interface compatibility *******************/



  function buyRate() public pure returns(uint) {

    return rateUnit;

  }



  function buyRateDecimals() public pure returns(uint) {

    return rateDecimals;

  }



  function sellRate() public pure returns(uint) {

    return 0;

  }



  function sellRateDecimals() public pure returns(uint) {

    return rateDecimals;

  }



  /******************* end rate functions *******************/



  /**

 * @dev For interface compatibility. Function to calculate the number of tokens the user is going to receive.

 * @param _offerTokenAmount The amount of tokens.

 * @param _isRedeem If true, the offered token is the LoanToken, otherwise is the underlying token.

 * @return uint.

 */

  function getAmount(uint _offerTokenAmount, bool _isRedeem)

    public pure returns(uint toUserAmount)

  {

    // Swap dai to sai forbidden

    return _isRedeem? 0 : _offerTokenAmount;

  }



  /**

   * @dev Release purchased asset to the buyer based on pair rate.

   * @param _userOfferTokenAddress The token address the purchaser is offering (It may be the quote or the base).

   * @param _userOfferTokenAmount The amount of token the user want to swap.

   * @return bool.

   */

  function swapToken (

    address _userOfferTokenAddress,

    uint _userOfferTokenAmount

  )

    public

    whenNotPaused

    returns (bool)

  {

    require(_userOfferTokenAmount != 0, "_userOfferTokenAmount == 0");

    require(

      ERC20(_userOfferTokenAddress).allowance(msg.sender, address(this)) >= _userOfferTokenAmount,

      "ERC20 allowance < _userOfferTokenAmount"

    );

    // check if offered token address is correct

    require(_userOfferTokenAddress == address(sai), "Swap dai to sai forbidden");



    // get user's tokens

    sai._safeTransferFrom(msg.sender, address(this), _userOfferTokenAmount);



    uint toUserAmount = _userOfferTokenAmount;

    sai._safeApprove(address(proxy), _userOfferTokenAmount);

    proxy.swapSaiToDai(migration, _userOfferTokenAmount);

    require(dai.balanceOf(address(this)) >= toUserAmount, "No enough dai after swap");

//    require(toUserAmount > 0, "toUserAmount must be greater than 0");

    require(

      dai.transfer(msg.sender, toUserAmount),

      "cannot transfer the dai tokens to the user"

    );



    emit LogTokenSwap(

      msg.sender,

      address(sai),

      _userOfferTokenAmount,

      address(dai),

      toUserAmount

    );

    return true;

  }





}



// File: contracts/Interfaces/ICToken.sol



pragma solidity ^0.4.0;



interface ICToken {

    function exchangeRateStored() external view returns (uint);



    function transfer(address dst, uint256 amount) external returns (bool);

    function transferFrom(address src, address dst, uint256 amount) external returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);



//    function balanceOfUnderlying(address owner) external returns (uint);

}



// File: contracts/Interfaces/ICErc20.sol



pragma solidity ^0.4.0;





contract  ICErc20 is ICToken {

    function underlying() external view returns (address);



    function mint(uint mintAmount) external returns (uint);

    function redeem(uint redeemTokens) external returns (uint);

//    function redeemUnderlying(uint redeemAmount) external returns (uint);

//    function borrow(uint borrowAmount) external returns (uint);

//    function repayBorrow(uint repayAmount) external returns (uint);

//    function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint);

//    function liquidateBorrow(address borrower, uint repayAmount, address cTokenCollateral) external returns (uint);

}



// File: contracts/CErc20Swap.sol



pragma solidity ^0.4.24;

















/**

 * @title TokenSwap.

 * @author Eidoo SAGL.

 * @dev A swap asset contract. The offerAmount and wantAmount are collected and sent into the contract itself.

 */

contract CErc20Swap is Pausable, Destructible

{

  using SafeMath for uint;

  using SafeTransfer for ERC20;

  address constant ETHER = address(0);

  uint constant expScale = 1e18;

  uint constant rateDecimals = 18;

  uint constant rateUnit = 10 ** rateDecimals;



  ICErc20 public cToken;



  address public wallet;



  uint public spread;

  uint constant spreadDecimals = 6;

  uint constant spreadUnit = 10 ** spreadDecimals;



  event LogWithdrawToken(

    address indexed _from,

    address indexed _token,

    uint amount

  );



  event LogTokenSwap(

    address indexed _userAddress,

    address indexed _userSentTokenAddress,

    uint _userSentTokenAmount,

    address indexed _userReceivedTokenAddress,

    uint _userReceivedTokenAmount

  );



  event LogFee(address token, uint amount);



  /**

   * @dev Contract constructor.

   * @param _cTokenAddress  The CToken in the pair.

   * @param _wallet The wallet for fees.

   * @param _spread The initial spread (in millionths).

   */

  constructor(

    address _cTokenAddress,

    address _wallet,

    uint _spread

  )

    public

  {

    require(_wallet != address(0), "_wallet == address(0)");

    cToken = ICErc20(_cTokenAddress);

    wallet = _wallet;

    spread = _spread;

  }



  function() external {

    revert("fallback function not allowed");

  }



  function setWallet(address _wallet) public onlyOwner {

    require(_wallet != address(0), "_wallet == address(0)");

    wallet = _wallet;

  }



  function setSpread(uint _spread) public onlyOwner {

    spread = _spread;

  }



  /**

   * @dev Withdraw asset.

   * @param _tokenAddress Asset to be withdrawed.

   * @return bool.

   */

  function withdrawToken(address _tokenAddress)

    public

    onlyOwner

  {

    uint tokenBalance;

    if (_tokenAddress == ETHER) {

      tokenBalance = address(this).balance;

      msg.sender.transfer(tokenBalance);

    } else {

      tokenBalance = ERC20(_tokenAddress).balanceOf(address(this));

      ERC20(_tokenAddress)._safeTransfer(msg.sender, tokenBalance);

    }

    emit LogWithdrawToken(msg.sender, _tokenAddress, tokenBalance);

  }



  /******************* rate functions for interface compatibility *******************/



  function buyRate() public view returns(uint) {

    return getAmount(rateUnit, false);

  }



  function buyRateDecimals() public pure returns(uint) {

    return rateDecimals;

  }



  function sellRate() public view returns(uint) {

    return getAmount(rateUnit, true);

  }



  function sellRateDecimals() public pure returns(uint) {

    return rateDecimals;

  }



  /******************* end rate functions *******************/



  function _getExchangedAmount(uint _amount, bool _isRedeem) internal view returns(uint) {

    uint rate = cToken.exchangeRateStored();

    return _isRedeem

      ? _amount.mul(rate).div(expScale)

      : _amount.mul(expScale).div(rate);

  }



  function _getFee(uint underlyingTokenTotal) internal view returns(uint) {

    return underlyingTokenTotal.mul(spread).div(spreadUnit);

  }



  /**

 * @dev For interface compatibility. Function to calculate the number of tokens the user is going to receive.

 * @param _offerTokenAmount The amount of tokens.

 * @param _isRedeem If true, the offered token is the CToken, otherwise is the underlying token.

 * @return uint.

 */

  function getAmount(uint _offerTokenAmount, bool _isRedeem)

    public view returns(uint toUserAmount)

  {

    if (_isRedeem) {

      uint amount = _getExchangedAmount(_offerTokenAmount, _isRedeem);

      // fee is always in underlying token, when minting the CToken is the received token

      toUserAmount = amount.sub(_getFee(amount));

    } else {

      // fee is always in underlying token, when redeeming the CToken is the offered token

      uint fee = _getFee(_offerTokenAmount);

      toUserAmount = _getExchangedAmount(_offerTokenAmount.sub(fee), _isRedeem);

    }

  }



  /**

   * @dev Release purchased asset to the buyer based on pair rate.

   * @param _userOfferTokenAddress The token address the purchaser is offering (It may be the quote or the base).

   * @param _userOfferTokenAmount The amount of token the user want to swap.

   * @return bool.

   */

  function swapToken (

    address _userOfferTokenAddress,

    uint _userOfferTokenAmount

  )

    public

    whenNotPaused

    returns (bool)

  {

    require(_userOfferTokenAmount != 0, "_userOfferTokenAmount == 0");

    require(

      ERC20(_userOfferTokenAddress).allowance(msg.sender, address(this)) >= _userOfferTokenAmount,

      "ERC20 allowance < _userOfferTokenAmount"

    );

    address underlying = cToken.underlying();

    // check if offered token address is the base or the quote token address

    require(

      _userOfferTokenAddress == underlying || _userOfferTokenAddress == address(cToken),

      "_userOfferTokenAddress not in pair"

    );

    bool isRedeem = _userOfferTokenAddress == address(cToken);

    uint toUserAmount;

    uint fee;



    // get user's tokens

    ERC20(_userOfferTokenAddress)._safeTransferFrom(msg.sender, address(this), _userOfferTokenAmount);



    if (isRedeem) {

      require(

        cToken.redeem(_userOfferTokenAmount) == 0,

        "cannot redeem the CToken"

      );

      uint redeemedAmount = _getExchangedAmount(_userOfferTokenAmount, isRedeem);

      require(

        ERC20(underlying).balanceOf(address(this)) >= redeemedAmount,

        "No enough underlying tokens after redeem"

      );

      fee = _getFee(redeemedAmount);

      toUserAmount = redeemedAmount.sub(fee);

      require(toUserAmount > 0, "toUserAmount must be greater than 0");

      require(

        ERC20(underlying)._safeTransfer(msg.sender, toUserAmount),

        "cannot transfer underlying token to the user"

      );

    } else {

      fee = _getFee(_userOfferTokenAmount);

      uint toSwap = _userOfferTokenAmount.sub(fee);

      ERC20(_userOfferTokenAddress)._safeApprove(address(cToken), toSwap);

      require(

        cToken.mint(toSwap) == 0,

        "cannot mint the CToken"

      );

      toUserAmount = _getExchangedAmount(toSwap, isRedeem);

      require(cToken.balanceOf(address(this)) >= toUserAmount, "No enough CTokens after mint");

      require(toUserAmount > 0, "toUserAmount must be greater than 0");

      require(

        cToken.transfer(msg.sender, toUserAmount),

        "cannot transfer the CToken to the user"

      );

    }

    // get the fee

    if (fee > 0) {

      require(

        ERC20(underlying)._safeTransfer(wallet, fee),

        "cannot transfer the CToken to the wallet for the fees"

      );

      emit LogFee(address(cToken), fee);

    }



    emit LogTokenSwap(

      msg.sender,

      _userOfferTokenAddress,

      _userOfferTokenAmount,

      isRedeem ? underlying : address(cToken),

      toUserAmount

    );

    return true;

  }





}



// File: contracts/CSaiCDaiSwap.sol



pragma solidity ^0.4.24;



















/**

 * @title TokenSwap.

 * @author Eidoo SAGL.

 * @dev A swap asset contract. The offerAmount and wantAmount are collected and sent into the contract itself.

 */

contract CSaiCDaiSwap is Pausable, Destructible

{

  using SafeMath for uint;

  using SafeTransfer for ERC20;

  address constant ETHER = address(0);

  uint constant expScale = 1e18;

  uint constant rateDecimals = 18;

  uint constant rateUnit = 10 ** rateDecimals;



  CErc20Swap public csaiSwap;

  CErc20Swap public cdaiSwap;

  SaiDaiTokenSwap public saidaiSwap;



  event LogWithdrawToken(

    address indexed _from,

    address indexed _token,

    uint amount

  );



  event LogTokenSwap(

    address indexed _userAddress,

    address indexed _userSentTokenAddress,

    uint _userSentTokenAmount,

    address indexed _userReceivedTokenAddress,

    uint _userReceivedTokenAmount

  );



  event UnexpectedBalance(address token, uint balance);



  constructor(

    address _csaiSwap,

    address _cdaiSwap,

    address _saidaiSwap

  )

    public

  {

    csaiSwap = CErc20Swap(_csaiSwap);

    cdaiSwap = CErc20Swap(_cdaiSwap);

    saidaiSwap = SaiDaiTokenSwap(_saidaiSwap);



//    ICErc20 csai = csaiSwap.cToken();

//    require(csaiSwap.cToken().underlying() == address(saidaiSwap.sai()), "SAI tokens mismatch");

//    require(cdaiSwap.cToken().underlying() == address(saidaiSwap.dai()), "DAI tokens mismatch");

  }



  function() external {

    revert("fallback function not allowed");

  }

  /**

   * @dev Withdraw asset.

   * @param _tokenAddress Asset to be withdrawed.

   * @return bool.

   */

  function withdrawToken(address _tokenAddress)

    public

    onlyOwner

  {

    uint tokenBalance;

    if (_tokenAddress == ETHER) {

      tokenBalance = address(this).balance;

      msg.sender.transfer(tokenBalance);

    } else {

      tokenBalance = ERC20(_tokenAddress).balanceOf(address(this));

      ERC20(_tokenAddress)._safeTransfer(msg.sender, tokenBalance);

    }

    emit LogWithdrawToken(msg.sender, _tokenAddress, tokenBalance);

  }



  /******************* rate functions for interface compatibility *******************/



  function buyRate() public view returns(uint) {

    uint csairedeem = csaiSwap.sellRate().mul(10 ** (rateDecimals.sub(csaiSwap.sellRateDecimals())));

    uint saidai = saidaiSwap.buyRate().mul(10 ** (rateDecimals.sub(saidaiSwap.buyRateDecimals())));

    uint cdaimint = cdaiSwap.buyRate().mul(10 ** (rateDecimals.sub(cdaiSwap.buyRateDecimals())));

    uint rate = csairedeem.mul(saidai).div(10 ** rateDecimals).mul(cdaimint).div(10 ** rateDecimals);

    return rate;

  }



  function buyRateDecimals() public pure returns(uint) {

    return rateDecimals;

  }



  function sellRate() public pure returns(uint) {

    return 0;

  }



  function sellRateDecimals() public pure returns(uint) {

    return rateDecimals;

  }



  /******************* end rate functions *******************/



  /**

 * @dev For interface compatibility. Function to calculate the number of tokens the user is going to receive.

 * @param _offerTokenAmount The amount of tokens.

 * @param _isRedeem If true, the offered token is the CToken, otherwise is the underlying token.

 * @return uint.

 */

  function getAmount(uint _offerTokenAmount, bool _isRedeem)

    public view returns(uint toUserAmount)

  {

    // Swap cdai to csai forbidden

    return _isRedeem? 0 : _offerTokenAmount.mul(buyRate()).div(rateUnit);

  }



  /**

   * @dev Release purchased asset to the buyer based on pair rate.

   * @param _userOfferTokenAddress The token address the purchaser is offering (It may be the quote or the base).

   * @param _userOfferTokenAmount The amount of token the user want to swap.

   * @return bool.

   */

  function swapToken (

    address _userOfferTokenAddress,

    uint _userOfferTokenAmount

  )

    public

    whenNotPaused

    returns (bool)

  {

    require(_userOfferTokenAmount != 0, "_userOfferTokenAmount == 0");

    require(

      ERC20(_userOfferTokenAddress).allowance(msg.sender, address(this)) >= _userOfferTokenAmount,

      "ERC20 allowance < _userOfferTokenAmount"

    );



    ICErc20 csai = csaiSwap.cToken();

    ERC20 sai = ERC20(csai.underlying());

    ICErc20 cdai = cdaiSwap.cToken();

    ERC20 dai = ERC20(cdai.underlying());



    // check if offered token address is the base or the quote token address

    require(

      _userOfferTokenAddress == address(csai),

      "_userOfferTokenAddress must be CSAI address"

    );



    emptyBalance(address(csai));

    emptyBalance(address(sai));

    emptyBalance(address(dai));

    emptyBalance(address(cdai));



    // get user's tokens

    csai.transferFrom(msg.sender, address(this), _userOfferTokenAmount);



    csai.approve(address(csaiSwap), _userOfferTokenAmount);

    csaiSwap.swapToken(address(csai), _userOfferTokenAmount);

    uint saiBalance = sai.balanceOf(address(this));

    require(saiBalance > 0, "SAI balance is 0");



    sai.approve(address(saidaiSwap), saiBalance);

    saidaiSwap.swapToken(address(sai), saiBalance);

    uint daiBalance = dai.balanceOf(address(this));

    require(daiBalance > 0, "DAI balance is 0");



    dai.approve(address(cdaiSwap), daiBalance);

    cdaiSwap.swapToken(address(dai), daiBalance);

    uint cdaiBalance = cdai.balanceOf(address(this));

    require(cdaiBalance > 0, "CDAI balance is 0");



    require(cdai.transfer(msg.sender, cdaiBalance), "Cannot tranfer CDAI to the msg.sender address");





    emit LogTokenSwap(

      msg.sender,

      _userOfferTokenAddress,

      _userOfferTokenAmount,

      address(cdai),

      cdaiBalance

    );

    return true;

  }



  function emptyBalance(address token) private {

    uint balance = ERC20(token).balanceOf(address(this));

    if (balance > 0) {

      require(ERC20(token)._safeTransfer(owner, balance), "cannot tranfer tokens in order to empty balance");

      emit UnexpectedBalance(token, balance);

    }

  }



}
