// File: contracts/ethereum-erc721/src/contracts/tokens/erc721.sol



pragma solidity 0.5.6;



/**

 * @dev ERC-721 non-fungible token standard. 

 * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.

 */

interface ERC721

{



  /**

   * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are

   * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any

   * number of NFTs may be created and assigned without emitting Transfer. At the time of any

   * transfer, the approved address for that NFT (if any) is reset to none.

   */

  event Transfer(

    address indexed _from,

    address indexed _to,

    uint256 indexed _tokenId

  );



  /**

   * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero

   * address indicates there is no approved address. When a Transfer event emits, this also

   * indicates that the approved address for that NFT (if any) is reset to none.

   */

  event Approval(

    address indexed _owner,

    address indexed _approved,

    uint256 indexed _tokenId

  );



  /**

   * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage

   * all NFTs of the owner.

   */

  event ApprovalForAll(

    address indexed _owner,

    address indexed _operator,

    bool _approved

  );



  /**

   * @dev Transfers the ownership of an NFT from one address to another address.

   * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the

   * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is

   * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this

   * function checks if `_to` is a smart contract (code size > 0). If so, it calls

   * `onERC721Received` on `_to` and throws if the return value is not 

   * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.

   * @param _from The current owner of the NFT.

   * @param _to The new owner.

   * @param _tokenId The NFT to transfer.

   * @param _data Additional data with no specified format, sent in call to `_to`.

   */

  function safeTransferFrom(

    address _from,

    address _to,

    uint256 _tokenId,

    bytes calldata _data

  )

    external;



  /**

   * @dev Transfers the ownership of an NFT from one address to another address.

   * @notice This works identically to the other function with an extra data parameter, except this

   * function just sets data to ""

   * @param _from The current owner of the NFT.

   * @param _to The new owner.

   * @param _tokenId The NFT to transfer.

   */

  function safeTransferFrom(

    address _from,

    address _to,

    uint256 _tokenId

  )

    external;



  /**

   * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved

   * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero

   * address. Throws if `_tokenId` is not a valid NFT.

   * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else

   * they mayb be permanently lost.

   * @param _from The current owner of the NFT.

   * @param _to The new owner.

   * @param _tokenId The NFT to transfer.

   */

  function transferFrom(

    address _from,

    address _to,

    uint256 _tokenId

  )

    external;



  /**

   * @dev Set or reaffirm the approved address for an NFT.

   * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is

   * the current NFT owner, or an authorized operator of the current owner.

   * @param _approved The new approved NFT controller.

   * @param _tokenId The NFT to approve.

   */

  function approve(

    address _approved,

    uint256 _tokenId

  )

    external;



  /**

   * @dev Enables or disables approval for a third party ("operator") to manage all of

   * `msg.sender`'s assets. It also emits the ApprovalForAll event.

   * @notice The contract MUST allow multiple operators per owner.

   * @param _operator Address to add to the set of authorized operators.

   * @param _approved True if the operators is approved, false to revoke approval.

   */

  function setApprovalForAll(

    address _operator,

    bool _approved

  )

    external;



  /**

   * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are

   * considered invalid, and this function throws for queries about the zero address.

   * @param _owner Address for whom to query the balance.

   * @return Balance of _owner.

   */

  function balanceOf(

    address _owner

  )

    external

    view

    returns (uint256);



  /**

   * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered

   * invalid, and queries about them do throw.

   * @param _tokenId The identifier for an NFT.

   * @return Address of _tokenId owner.

   */

  function ownerOf(

    uint256 _tokenId

  )

    external

    view

    returns (address);

    

  /**

   * @dev Get the approved address for a single NFT.

   * @notice Throws if `_tokenId` is not a valid NFT.

   * @param _tokenId The NFT to find the approved address for.

   * @return Address that _tokenId is approved for. 

   */

  function getApproved(

    uint256 _tokenId

  )

    external

    view

    returns (address);



  /**

   * @dev Returns true if `_operator` is an approved operator for `_owner`, false otherwise.

   * @param _owner The address that owns the NFTs.

   * @param _operator The address that acts on behalf of the owner.

   * @return True if approved for all, false otherwise.

   */

  function isApprovedForAll(

    address _owner,

    address _operator

  )

    external

    view

    returns (bool);



}



// File: contracts/ethereum-erc721/src/contracts/tokens/erc721-token-receiver.sol



pragma solidity 0.5.6;



/**

 * @dev ERC-721 interface for accepting safe transfers. 

 * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.

 */

interface ERC721TokenReceiver

{



  /**

   * @dev Handle the receipt of a NFT. The ERC721 smart contract calls this function on the

   * recipient after a `transfer`. This function MAY throw to revert and reject the transfer. Return

   * of other than the magic value MUST result in the transaction being reverted.

   * Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))` unless throwing.

   * @notice The contract address is always the message sender. A wallet/broker/auction application

   * MUST implement the wallet interface if it will accept safe transfers.

   * @param _operator The address which called `safeTransferFrom` function.

   * @param _from The address which previously owned the token.

   * @param _tokenId The NFT identifier which is being transferred.

   * @param _data Additional data with no specified format.

   * @return Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.

   */

  function onERC721Received(

    address _operator,

    address _from,

    uint256 _tokenId,

    bytes calldata _data

  )

    external

    returns(bytes4);

    

}



// File: contracts/ethereum-erc721/src/contracts/math/safe-math.sol



pragma solidity 0.5.6;



/**

 * @dev Math operations with safety checks that throw on error. This contract is based on the 

 * source code at: 

 * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol.

 */

library SafeMath

{



  /**

   * @dev Multiplies two numbers, reverts on overflow.

   * @param _factor1 Factor number.

   * @param _factor2 Factor number.

   * @return The product of the two factors.

   */

  function mul(

    uint256 _factor1,

    uint256 _factor2

  )

    internal

    pure

    returns (uint256 product)

  {

    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the

    // benefit is lost if 'b' is also tested.

    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522

    if (_factor1 == 0)

    {

      return 0;

    }



    product = _factor1 * _factor2;

    require(product / _factor1 == _factor2);

  }



  /**

   * @dev Integer division of two numbers, truncating the quotient, reverts on division by zero.

   * @param _dividend Dividend number.

   * @param _divisor Divisor number.

   * @return The quotient.

   */

  function div(

    uint256 _dividend,

    uint256 _divisor

  )

    internal

    pure

    returns (uint256 quotient)

  {

    // Solidity automatically asserts when dividing by 0, using all gas.

    require(_divisor > 0);

    quotient = _dividend / _divisor;

    // assert(_dividend == _divisor * quotient + _dividend % _divisor); // There is no case in which this doesn't hold.

  }



  /**

   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).

   * @param _minuend Minuend number.

   * @param _subtrahend Subtrahend number.

   * @return Difference.

   */

  function sub(

    uint256 _minuend,

    uint256 _subtrahend

  )

    internal

    pure

    returns (uint256 difference)

  {

    require(_subtrahend <= _minuend);

    difference = _minuend - _subtrahend;

  }



  /**

   * @dev Adds two numbers, reverts on overflow.

   * @param _addend1 Number.

   * @param _addend2 Number.

   * @return Sum.

   */

  function add(

    uint256 _addend1,

    uint256 _addend2

  )

    internal

    pure

    returns (uint256 sum)

  {

    sum = _addend1 + _addend2;

    require(sum >= _addend1);

  }



  /**

    * @dev Divides two numbers and returns the remainder (unsigned integer modulo), reverts when

    * dividing by zero.

    * @param _dividend Number.

    * @param _divisor Number.

    * @return Remainder.

    */

  function mod(

    uint256 _dividend,

    uint256 _divisor

  )

    internal

    pure

    returns (uint256 remainder) 

  {

    require(_divisor != 0);

    remainder = _dividend % _divisor;

  }



}



// File: contracts/ethereum-erc721/src/contracts/utils/erc165.sol



pragma solidity 0.5.6;



/**

 * @dev A standard for detecting smart contract interfaces. 

 * See: https://eips.ethereum.org/EIPS/eip-165.

 */

interface ERC165

{



  /**

   * @dev Checks if the smart contract includes a specific interface.

   * @notice This function uses less than 30,000 gas.

   * @param _interfaceID The interface identifier, as specified in ERC-165.

   * @return True if _interfaceID is supported, false otherwise.

   */

  function supportsInterface(

    bytes4 _interfaceID

  )

    external

    view

    returns (bool);

    

}



// File: contracts/ethereum-erc721/src/contracts/utils/supports-interface.sol



pragma solidity 0.5.6;





/**

 * @dev Implementation of standard for detect smart contract interfaces.

 */

contract SupportsInterface is

  ERC165

{



  /**

   * @dev Mapping of supported intefraces.

   * @notice You must not set element 0xffffffff to true.

   */

  mapping(bytes4 => bool) internal supportedInterfaces;



  /**

   * @dev Contract constructor.

   */

  constructor()

    public 

  {

    supportedInterfaces[0x01ffc9a7] = true; // ERC165

  }



  /**

   * @dev Function to check which interfaces are suported by this contract.

   * @param _interfaceID Id of the interface.

   * @return True if _interfaceID is supported, false otherwise.

   */

  function supportsInterface(

    bytes4 _interfaceID

  )

    external

    view

    returns (bool)

  {

    return supportedInterfaces[_interfaceID];

  }



}



// File: contracts/ethereum-erc721/src/contracts/utils/address-utils.sol



pragma solidity 0.5.6;



/**

 * @dev Utility library of inline functions on addresses.

 */

library AddressUtils

{



  /**

   * @dev Returns whether the target address is a contract.

   * @param _addr Address to check.

   * @return True if _addr is a contract, false if not.

   */

  function isContract(

    address _addr

  )

    internal

    view

    returns (bool addressCheck)

  {

    uint256 size;



    /**

     * XXX Currently there is no better way to check if there is a contract in an address than to

     * check the size of the code at that address.

     * See https://ethereum.stackexchange.com/a/14016/36603 for more details about how this works.

     * TODO: Check this again before the Serenity release, because all addresses will be

     * contracts then.

     */

    assembly { size := extcodesize(_addr) } // solhint-disable-line

    addressCheck = size > 0;

  }



}



// File: contracts/ethereum-erc721/src/contracts/tokens/nf-token.sol



pragma solidity 0.5.6;













/**

 * @dev Implementation of ERC-721 non-fungible token standard.

 */

contract NFToken is

  ERC721,

  SupportsInterface

{

  using SafeMath for uint256;

  using AddressUtils for address;



  /**

   * @dev Magic value of a smart contract that can recieve NFT.

   * Equal to: bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")).

   */

  bytes4 internal constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;



  /**

   * @dev A mapping from NFT ID to the address that owns it.

   */

  mapping (uint256 => address) internal idToOwner;



  /**

   * @dev Mapping from NFT ID to approved address.

   */

  mapping (uint256 => address) internal idToApproval;



   /**

   * @dev Mapping from owner address to count of his tokens.

   */

  mapping (address => uint256) private ownerToNFTokenCount;



  /**

   * @dev Mapping from owner address to mapping of operator addresses.

   */

  mapping (address => mapping (address => bool)) internal ownerToOperators;



  /**

   * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are

   * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any

   * number of NFTs may be created and assigned without emitting Transfer. At the time of any

   * transfer, the approved address for that NFT (if any) is reset to none.

   * @param _from Sender of NFT (if address is zero address it indicates token creation).

   * @param _to Receiver of NFT (if address is zero address it indicates token destruction).

   * @param _tokenId The NFT that got transfered.

   */

  event Transfer(

    address indexed _from,

    address indexed _to,

    uint256 indexed _tokenId

  );



  /**

   * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero

   * address indicates there is no approved address. When a Transfer event emits, this also

   * indicates that the approved address for that NFT (if any) is reset to none.

   * @param _owner Owner of NFT.

   * @param _approved Address that we are approving.

   * @param _tokenId NFT which we are approving.

   */

  event Approval(

    address indexed _owner,

    address indexed _approved,

    uint256 indexed _tokenId

  );



  /**

   * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage

   * all NFTs of the owner.

   * @param _owner Owner of NFT.

   * @param _operator Address to which we are setting operator rights.

   * @param _approved Status of operator rights(true if operator rights are given and false if

   * revoked).

   */

  event ApprovalForAll(

    address indexed _owner,

    address indexed _operator,

    bool _approved

  );



  /**

   * @dev Guarantees that the msg.sender is an owner or operator of the given NFT.

   * @param _tokenId ID of the NFT to validate.

   */

  modifier canOperate(

    uint256 _tokenId

  ) 

  {

    address tokenOwner = idToOwner[_tokenId];

    require(tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender]);

    _;

  }



  /**

   * @dev Guarantees that the msg.sender is allowed to transfer NFT.

   * @param _tokenId ID of the NFT to transfer.

   */

  modifier canTransfer(

    uint256 _tokenId

  ) 

  {

    address tokenOwner = idToOwner[_tokenId];

    require(

      tokenOwner == msg.sender

      || idToApproval[_tokenId] == msg.sender

      || ownerToOperators[tokenOwner][msg.sender]

    );

    _;

  }



  /**

   * @dev Guarantees that _tokenId is a valid Token.

   * @param _tokenId ID of the NFT to validate.

   */

  modifier validNFToken(

    uint256 _tokenId

  )

  {

    require(idToOwner[_tokenId] != address(0));

    _;

  }



  /**

   * @dev Contract constructor.

   */

  constructor()

    public

  {

    supportedInterfaces[0x80ac58cd] = true; // ERC721

  }



  /**

   * @dev Transfers the ownership of an NFT from one address to another address. This function can

   * be changed to payable.

   * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the

   * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is

   * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this

   * function checks if `_to` is a smart contract (code size > 0). If so, it calls 

   * `onERC721Received` on `_to` and throws if the return value is not 

   * `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.

   * @param _from The current owner of the NFT.

   * @param _to The new owner.

   * @param _tokenId The NFT to transfer.

   * @param _data Additional data with no specified format, sent in call to `_to`.

   */

  function safeTransferFrom(

    address _from,

    address _to,

    uint256 _tokenId,

    bytes calldata _data

  )

    external

  {

    _safeTransferFrom(_from, _to, _tokenId, _data);

  }



  /**

   * @dev Transfers the ownership of an NFT from one address to another address. This function can

   * be changed to payable.

   * @notice This works identically to the other function with an extra data parameter, except this

   * function just sets data to ""

   * @param _from The current owner of the NFT.

   * @param _to The new owner.

   * @param _tokenId The NFT to transfer.

   */

  function safeTransferFrom(

    address _from,

    address _to,

    uint256 _tokenId

  )

    external

  {

    _safeTransferFrom(_from, _to, _tokenId, "");

  }



  /**

   * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved

   * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero

   * address. Throws if `_tokenId` is not a valid NFT. This function can be changed to payable.

   * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else

   * they maybe be permanently lost.

   * @param _from The current owner of the NFT.

   * @param _to The new owner.

   * @param _tokenId The NFT to transfer.

   */

  function transferFrom(

    address _from,

    address _to,

    uint256 _tokenId

  )

    external

    canTransfer(_tokenId)

    validNFToken(_tokenId)

  {

    address tokenOwner = idToOwner[_tokenId];

    require(tokenOwner == _from);

    require(_to != address(0));



    _transfer(_to, _tokenId);

  }



  /**

   * @dev Set or reaffirm the approved address for an NFT. This function can be changed to payable.

   * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is

   * the current NFT owner, or an authorized operator of the current owner.

   * @param _approved Address to be approved for the given NFT ID.

   * @param _tokenId ID of the token to be approved.

   */

  function approve(

    address _approved,

    uint256 _tokenId

  )

    external

    canOperate(_tokenId)

    validNFToken(_tokenId)

  {

    address tokenOwner = idToOwner[_tokenId];

    require(_approved != tokenOwner);



    idToApproval[_tokenId] = _approved;

    emit Approval(tokenOwner, _approved, _tokenId);

  }



  /**

   * @dev Enables or disables approval for a third party ("operator") to manage all of

   * `msg.sender`'s assets. It also emits the ApprovalForAll event.

   * @notice This works even if sender doesn't own any tokens at the time.

   * @param _operator Address to add to the set of authorized operators.

   * @param _approved True if the operators is approved, false to revoke approval.

   */

  function setApprovalForAll(

    address _operator,

    bool _approved

  )

    external

  {

    ownerToOperators[msg.sender][_operator] = _approved;

    emit ApprovalForAll(msg.sender, _operator, _approved);

  }



  /**

   * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are

   * considered invalid, and this function throws for queries about the zero address.

   * @param _owner Address for whom to query the balance.

   * @return Balance of _owner.

   */

  function balanceOf(

    address _owner

  )

    external

    view

    returns (uint256)

  {

    require(_owner != address(0));

    return _getOwnerNFTCount(_owner);

  }



  /**

   * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered

   * invalid, and queries about them do throw.

   * @param _tokenId The identifier for an NFT.

   * @return Address of _tokenId owner.

   */

  function ownerOf(

    uint256 _tokenId

  )

    external

    view

    returns (address _owner)

  {

    _owner = idToOwner[_tokenId];

    require(_owner != address(0));

  }



  /**

   * @dev Get the approved address for a single NFT.

   * @notice Throws if `_tokenId` is not a valid NFT.

   * @param _tokenId ID of the NFT to query the approval of.

   * @return Address that _tokenId is approved for. 

   */

  function getApproved(

    uint256 _tokenId

  )

    external

    view

    validNFToken(_tokenId)

    returns (address)

  {

    return idToApproval[_tokenId];

  }



  /**

   * @dev Checks if `_operator` is an approved operator for `_owner`.

   * @param _owner The address that owns the NFTs.

   * @param _operator The address that acts on behalf of the owner.

   * @return True if approved for all, false otherwise.

   */

  function isApprovedForAll(

    address _owner,

    address _operator

  )

    external

    view

    returns (bool)

  {

    return ownerToOperators[_owner][_operator];

  }



  /**

   * @dev Actually preforms the transfer.

   * @notice Does NO checks.

   * @param _to Address of a new owner.

   * @param _tokenId The NFT that is being transferred.

   */

  function _transfer(

    address _to,

    uint256 _tokenId

  )

    internal

  {

    address from = idToOwner[_tokenId];

    _clearApproval(_tokenId);



    _removeNFToken(from, _tokenId);

    _addNFToken(_to, _tokenId);



    emit Transfer(from, _to, _tokenId);

  }

   

  /**

   * @dev Mints a new NFT.

   * @notice This is an internal function which should be called from user-implemented external

   * mint function. Its purpose is to show and properly initialize data structures when using this

   * implementation.

   * @param _to The address that will own the minted NFT.

   * @param _tokenId of the NFT to be minted by the msg.sender.

   */

  function _mint(

    address _to,

    uint256 _tokenId

  )

    internal

  {

    require(_to != address(0));

    require(idToOwner[_tokenId] == address(0));



    _addNFToken(_to, _tokenId);



    emit Transfer(address(0), _to, _tokenId);

  }



  /**

   * @dev Burns a NFT.

   * @notice This is an internal function which should be called from user-implemented external burn

   * function. Its purpose is to show and properly initialize data structures when using this

   * implementation. Also, note that this burn implementation allows the minter to re-mint a burned

   * NFT.

   * @param _tokenId ID of the NFT to be burned.

   */

  function _burn(

    uint256 _tokenId

  )

    internal

    validNFToken(_tokenId)

  {

    address tokenOwner = idToOwner[_tokenId];

    _clearApproval(_tokenId);

    _removeNFToken(tokenOwner, _tokenId);

    emit Transfer(tokenOwner, address(0), _tokenId);

  }



  /**

   * @dev Removes a NFT from owner.

   * @notice Use and override this function with caution. Wrong usage can have serious consequences.

   * @param _from Address from wich we want to remove the NFT.

   * @param _tokenId Which NFT we want to remove.

   */

  function _removeNFToken(

    address _from,

    uint256 _tokenId

  )

    internal

  {

    require(idToOwner[_tokenId] == _from);

    ownerToNFTokenCount[_from] = ownerToNFTokenCount[_from] - 1;

    delete idToOwner[_tokenId];

  }



  /**

   * @dev Assignes a new NFT to owner.

   * @notice Use and override this function with caution. Wrong usage can have serious consequences.

   * @param _to Address to wich we want to add the NFT.

   * @param _tokenId Which NFT we want to add.

   */

  function _addNFToken(

    address _to,

    uint256 _tokenId

  )

    internal

  {

    require(idToOwner[_tokenId] == address(0));



    idToOwner[_tokenId] = _to;

    ownerToNFTokenCount[_to] = ownerToNFTokenCount[_to].add(1);

  }



  /**

   *\u00a0@dev Helper function that gets NFT count of owner. This is needed for overriding in enumerable

   * extension to remove double storage (gas optimization) of owner nft count.

   * @param _owner Address for whom to query the count.

   * @return Number of _owner NFTs.

   */

  function _getOwnerNFTCount(

    address _owner

  )

    internal

    view

    returns (uint256)

  {

    return ownerToNFTokenCount[_owner];

  }



  /**

   * @dev Actually perform the safeTransferFrom.

   * @param _from The current owner of the NFT.

   * @param _to The new owner.

   * @param _tokenId The NFT to transfer.

   * @param _data Additional data with no specified format, sent in call to `_to`.

   */

  function _safeTransferFrom(

    address _from,

    address _to,

    uint256 _tokenId,

    bytes memory _data

  )

    private

    canTransfer(_tokenId)

    validNFToken(_tokenId)

  {

    address tokenOwner = idToOwner[_tokenId];

    require(tokenOwner == _from);

    require(_to != address(0));



    _transfer(_to, _tokenId);



    if (_to.isContract()) 

    {

      bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);

      require(retval == MAGIC_ON_ERC721_RECEIVED);

    }

  }



  /** 

   * @dev Clears the current approval of a given NFT ID.

   * @param _tokenId ID of the NFT to be transferred.

   */

  function _clearApproval(

    uint256 _tokenId

  )

    private

  {

    if (idToApproval[_tokenId] != address(0))

    {

      delete idToApproval[_tokenId];

    }

  }



}



// File: contracts/ethereum-erc721/src/contracts/tokens/erc721-metadata.sol



pragma solidity 0.5.6;



/**

 * @dev Optional metadata extension for ERC-721 non-fungible token standard.

 * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.

 */

interface ERC721Metadata

{



  /**

   * @dev Returns a descriptive name for a collection of NFTs in this contract.

   * @return Representing name. 

   */

  function name()

    external

    view

    returns (string memory _name);



  /**

   * @dev Returns a abbreviated name for a collection of NFTs in this contract.

   * @return Representing symbol. 

   */

  function symbol()

    external

    view

    returns (string memory _symbol);



  /**

   * @dev Returns a distinct Uniform Resource Identifier (URI) for a given asset. It Throws if

   * `_tokenId` is not a valid NFT. URIs are defined in RFC3986. The URI may point to a JSON file

   * that conforms to the "ERC721 Metadata JSON Schema".

   * @return URI of _tokenId.

   */

  function tokenURI(uint256 _tokenId)

    external

    view

    returns (string memory);



}



// File: contracts/ethereum-erc721/src/contracts/tokens/nf-token-metadata.sol



pragma solidity 0.5.6;







/**

 * @dev Optional metadata implementation for ERC-721 non-fungible token standard.

 */

contract NFTokenMetadata is

  NFToken,

  ERC721Metadata

{



  /**

   * @dev A descriptive name for a collection of NFTs.

   */

  string internal nftName;



  /**

   * @dev An abbreviated name for NFTokens.

   */

  string internal nftSymbol;



  /**

   * @dev Mapping from NFT ID to metadata uri.

   */

  mapping (uint256 => string) internal idToUri;



  /**

   * @dev Contract constructor.

   * @notice When implementing this contract don't forget to set nftName and nftSymbol.

   */

  constructor()

    public

  {

    supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata

  }



  /**

   * @dev Returns a descriptive name for a collection of NFTokens.

   * @return Representing name. 

   */

  function name()

    external

    view

    returns (string memory _name)

  {

    _name = nftName;

  }



  /**

   * @dev Returns an abbreviated name for NFTokens.

   * @return Representing symbol. 

   */

  function symbol()

    external

    view

    returns (string memory _symbol)

  {

    _symbol = nftSymbol;

  }



  /**

   * @dev A distinct URI (RFC 3986) for a given NFT.

   * @param _tokenId Id for which we want uri.

   * @return URI of _tokenId.

   */

  function tokenURI(

    uint256 _tokenId

  )

    external

    view

    validNFToken(_tokenId)

    returns (string memory)

  {

    return idToUri[_tokenId];

  }



  /**

   * @dev Burns a NFT.

   * @notice This is an internal function which should be called from user-implemented external

   * burn function. Its purpose is to show and properly initialize data structures when using this

   * implementation. Also, note that this burn implementation allows the minter to re-mint a burned

   * NFT.

   * @param _tokenId ID of the NFT to be burned.

   */

  function _burn(

    uint256 _tokenId

  )

    internal

  {

    super._burn(_tokenId);



    if (bytes(idToUri[_tokenId]).length != 0)

    {

      delete idToUri[_tokenId];

    }

  }



  /**

   * @dev Set a distinct URI (RFC 3986) for a given NFT ID.

   * @notice This is an internal function which should be called from user-implemented external

   * function. Its purpose is to show and properly initialize data structures when using this

   * implementation.

   * @param _tokenId Id for which we want uri.

   * @param _uri String representing RFC 3986 URI.

   */

  function _setTokenUri(

    uint256 _tokenId,

    string memory _uri

  )

    internal

    validNFToken(_tokenId)

  {

    idToUri[_tokenId] = _uri;

  }



}



// File: contracts/ethereum-erc721/src/contracts/tokens/erc721-enumerable.sol



pragma solidity 0.5.6;



/**

 * @dev Optional enumeration extension for ERC-721 non-fungible token standard.

 * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.

 */

interface ERC721Enumerable

{



  /**

   * @dev Returns a count of valid NFTs tracked by this contract, where each one of them has an

   * assigned and queryable owner not equal to the zero address.

   * @return Total supply of NFTs.

   */

  function totalSupply()

    external

    view

    returns (uint256);



  /**

   * @dev Returns the token identifier for the `_index`th NFT. Sort order is not specified.

   * @param _index A counter less than `totalSupply()`.

   * @return Token id.

   */

  function tokenByIndex(

    uint256 _index

  )

    external

    view

    returns (uint256);



  /**

   * @dev Returns the token identifier for the `_index`th NFT assigned to `_owner`. Sort order is

   * not specified. It throws if `_index` >= `balanceOf(_owner)` or if `_owner` is the zero address,

   * representing invalid NFTs.

   * @param _owner An address where we are interested in NFTs owned by them.

   * @param _index A counter less than `balanceOf(_owner)`.

   * @return Token id.

   */

  function tokenOfOwnerByIndex(

    address _owner,

    uint256 _index

  )

    external

    view

    returns (uint256);



}



// File: contracts/ethereum-erc721/src/contracts/tokens/nf-token-enumerable.sol



pragma solidity 0.5.6;







/**

 * @dev Optional enumeration implementation for ERC-721 non-fungible token standard.

 */

contract NFTokenEnumerable is

  NFToken,

  ERC721Enumerable

{



  /**

   * @dev Array of all NFT IDs.

   */

  uint256[] internal tokens;



  /**

   * @dev Mapping from token ID to its index in global tokens array.

   */

  mapping(uint256 => uint256) internal idToIndex;



  /**

   * @dev Mapping from owner to list of owned NFT IDs.

   */

  mapping(address => uint256[]) internal ownerToIds;



  /**

   * @dev Mapping from NFT ID to its index in the owner tokens list.

   */

  mapping(uint256 => uint256) internal idToOwnerIndex;



  /**

   * @dev Contract constructor.

   */

  constructor()

    public

  {

    supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable

  }



  /**

   * @dev Returns the count of all existing NFTokens.

   * @return Total supply of NFTs.

   */

  function totalSupply()

    external

    view

    returns (uint256)

  {

    return tokens.length;

  }



  /**

   * @dev Returns NFT ID by its index.

   * @param _index A counter less than `totalSupply()`.

   * @return Token id.

   */

  function tokenByIndex(

    uint256 _index

  )

    external

    view

    returns (uint256)

  {

    require(_index < tokens.length);

    return tokens[_index];

  }



  /**

   * @dev returns the n-th NFT ID from a list of owner's tokens.

   * @param _owner Token owner's address.

   * @param _index Index number representing n-th token in owner's list of tokens.

   * @return Token id.

   */

  function tokenOfOwnerByIndex(

    address _owner,

    uint256 _index

  )

    external

    view

    returns (uint256)

  {

    require(_index < ownerToIds[_owner].length);

    return ownerToIds[_owner][_index];

  }



  /**

   * @dev Mints a new NFT.

   * @notice This is an internal function which should be called from user-implemented external

   * mint function. Its purpose is to show and properly initialize data structures when using this

   * implementation.

   * @param _to The address that will own the minted NFT.

   * @param _tokenId of the NFT to be minted by the msg.sender.

   */

  function _mint(

    address _to,

    uint256 _tokenId

  )

    internal

  {

    super._mint(_to, _tokenId);

    uint256 length = tokens.push(_tokenId);

    idToIndex[_tokenId] = length - 1;

  }



  /**

   * @dev Burns a NFT.

   * @notice This is an internal function which should be called from user-implemented external

   * burn function. Its purpose is to show and properly initialize data structures when using this

   * implementation. Also, note that this burn implementation allows the minter to re-mint a burned

   * NFT.

   * @param _tokenId ID of the NFT to be burned.

   */

  function _burn(

    uint256 _tokenId

  )

    internal

  {

    super._burn(_tokenId);



    uint256 tokenIndex = idToIndex[_tokenId];

    uint256 lastTokenIndex = tokens.length - 1;

    uint256 lastToken = tokens[lastTokenIndex];



    tokens[tokenIndex] = lastToken;



    tokens.length--;

    // This wastes gas if you are burning the last token but saves a little gas if you are not. 

    idToIndex[lastToken] = tokenIndex;

    idToIndex[_tokenId] = 0;

  }



  /**

   * @dev Removes a NFT from an address.

   * @notice Use and override this function with caution. Wrong usage can have serious consequences.

   * @param _from Address from wich we want to remove the NFT.

   * @param _tokenId Which NFT we want to remove.

   */

  function _removeNFToken(

    address _from,

    uint256 _tokenId

  )

    internal

  {

    require(idToOwner[_tokenId] == _from);

    delete idToOwner[_tokenId];



    uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];

    uint256 lastTokenIndex = ownerToIds[_from].length - 1;



    if (lastTokenIndex != tokenToRemoveIndex)

    {

      uint256 lastToken = ownerToIds[_from][lastTokenIndex];

      ownerToIds[_from][tokenToRemoveIndex] = lastToken;

      idToOwnerIndex[lastToken] = tokenToRemoveIndex;

    }



    ownerToIds[_from].length--;

  }



  /**

   * @dev Assignes a new NFT to an address.

   * @notice Use and override this function with caution. Wrong usage can have serious consequences.

   * @param _to Address to wich we want to add the NFT.

   * @param _tokenId Which NFT we want to add.

   */

  function _addNFToken(

    address _to,

    uint256 _tokenId

  )

    internal

  {

    require(idToOwner[_tokenId] == address(0));

    idToOwner[_tokenId] = _to;



    uint256 length = ownerToIds[_to].push(_tokenId);

    idToOwnerIndex[_tokenId] = length - 1;

  }



  /**

   *\u00a0@dev Helper function that gets NFT count of owner. This is needed for overriding in enumerable

   * extension to remove double storage(gas optimization) of owner nft count.

   * @param _owner Address for whom to query the count.

   * @return Number of _owner NFTs.

   */

  function _getOwnerNFTCount(

    address _owner

  )

    internal

    view

    returns (uint256)

  {

    return ownerToIds[_owner].length;

  }

}



// File: contracts/ethereum-erc721/src/contracts/ownership/ownable.sol



pragma solidity 0.5.6;



/**

 * @dev The contract has an owner address, and provides basic authorization control whitch

 * simplifies the implementation of user permissions. This contract is based on the source code at:

 * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol

 */

contract Ownable

{

  

  /**

   * @dev Error constants.

   */

  string public constant NOT_OWNER = "018001";

  string public constant ZERO_ADDRESS = "018002";



  /**

   * @dev Current owner address.

   */

  address public owner;



  /**

   * @dev An event which is triggered when the owner is changed.

   * @param previousOwner The address of the previous owner.

   * @param newOwner The address of the new owner.

   */

  event OwnershipTransferred(

    address indexed previousOwner,

    address indexed newOwner

  );



  /**

   * @dev The constructor sets the original `owner` of the contract to the sender account.

   */

  constructor()

    public

  {

    owner = msg.sender;

  }



  /**

   * @dev Throws if called by any account other than the owner.

   */

  modifier onlyOwner()

  {

    require(msg.sender == owner, NOT_OWNER);

    _;

  }



  /**

   * @dev Allows the current owner to transfer control of the contract to a newOwner.

   * @param _newOwner The address to transfer ownership to.

   */

  function transferOwnership(

    address _newOwner

  )

    public

    onlyOwner

  {

    require(_newOwner != address(0), ZERO_ADDRESS);

    emit OwnershipTransferred(owner, _newOwner);

    owner = _newOwner;

  }



}



// File: contracts/Pausable.sol



pragma solidity 0.5.6;





/**

 * @dev Contract module which allows children to implement an emergency stop

 * mechanism that can be triggered by an authorized account.

 *

 * This module is used through inheritance. It will make available the

 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to

 * the functions of your contract. Note that they will not be pausable by

 * simply including this module, only once the modifiers are put in place.

 */

contract Pausable is Ownable {

    /**

     * @dev Emitted when the pause is triggered by a pauser (`account`).

     */

    event Paused(address account);



    /**

     * @dev Emitted when the pause is lifted by a pauser (`account`).

     */

    event Unpaused(address account);



    bool private _paused;



    /**

     * @dev Initializes the contract in unpaused state. Assigns the Pauser role

     * to the deployer.

     */

    constructor () internal {

        _paused = false;

    }



    /**

     * @dev Returns true if the contract is paused, and false otherwise.

     */

    function paused() public view returns (bool) {

        return _paused;

    }



    /**

     * @dev Modifier to make a function callable only when the contract is not paused.

     */

    modifier whenNotPaused() {

        require(!_paused, "Pausable: paused");

        _;

    }



    /**

     * @dev Modifier to make a function callable only when the contract is paused.

     */

    modifier whenPaused() {

        require(_paused, "Pausable: not paused");

        _;

    }



    /**

     * @dev Called by a pauser to pause, triggers stopped state.

     */

    function pause() public onlyOwner whenNotPaused {

        _paused = true;

        emit Paused(msg.sender);

    }



    /**

     * @dev Called by a pauser to unpause, returns to normal state.

     */

    function unpause() public onlyOwner whenPaused {

        _paused = false;

        emit Unpaused(msg.sender);

    }

}



// File: contracts/vegas-city-nft.sol



pragma solidity 0.5.6;











/**

 * @dev This is an example contract implementation of NFToken with metadata extension.

 */

contract VegasCityNFT is NFTokenEnumerable, NFTokenMetadata, Ownable, Pausable {

  uint256 constant clearLow = 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000;

  uint256 constant clearHigh = 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff;

  uint256 constant factor = 0x100000000000000000000000000000000;



  /**

   * @dev Contract constructor. Sets metadata extension `name` and `symbol`.

   */

  constructor(string memory name, string memory symbol) public {

    nftName = name;

    nftSymbol = symbol;

  }

  

  function encodeTokenId(int x, int y) external pure returns (uint) {

    return _encodeTokenId(x, y);

  }



  function decodeTokenId(uint value) external pure returns (int, int) {

    return _decodeTokenId(value);

  }



  function _encodeTokenId(int x, int y) internal pure returns (uint result) {

    require(

      -1000000 < x && x < 1000000 && -1000000 < y && y < 1000000,

      "The coordinates should be inside bounds"

    );

    return _unsafeEncodeTokenId(x, y);

  }



  function _unsafeEncodeTokenId(int x, int y) internal pure returns (uint) {

    return ((uint(x) * factor) & clearLow) | (uint(y) & clearHigh);

  }



  function _unsafeDecodeTokenId(uint value) internal pure returns (int x, int y) {

    x = expandNegative128BitCast((value & clearLow) >> 128);

    y = expandNegative128BitCast(value & clearHigh);

  }



  function _decodeTokenId(uint value) internal pure returns (int x, int y) {

    (x, y) = _unsafeDecodeTokenId(value);

    require(

      -1000000 < x && x < 1000000 && -1000000 < y && y < 1000000,

      "The coordinates should be inside bounds"

    );

  }



  function expandNegative128BitCast(uint value) internal pure returns (int) {

    if (value & (1<<127) != 0) {

      return int(value | clearLow);

    }

    return int(value);

  }



  /**

   * @dev Mints a new NFT.

   * @param _to The address that will own the minted NFT.

   * @param _tokenId of the NFT to be minted by the msg.sender.

   * @param _uri String representing RFC 3986 URI.

   */

  function mint(address _to, uint256 _tokenId, string calldata _uri) external onlyOwner {

    super._mint(_to, _tokenId);

    super._setTokenUri(_tokenId, _uri);

  }



  /**

   * @dev Removes a NFT from owner.

   * @param _tokenId Which NFT we want to remove.

   */

  function burn(uint256 _tokenId) external onlyOwner {

    super._burn(_tokenId);

  }

  

  /**

   * @dev Guarantees that the msg.sender is an owner or operator of the given NFT.

   * @param _tokenId ID of the NFT to validate.

   */

  modifier canOperate(uint256 _tokenId) {

    require(!paused());



    address tokenOwner = idToOwner[_tokenId];

    require(tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender]);

    _;

  }



  /**

   * @dev Guarantees that the msg.sender is allowed to transfer NFT.

   * @param _tokenId ID of the NFT to transfer.

   */

  modifier canTransfer(uint256 _tokenId) {

    require(!paused());



    address tokenOwner = idToOwner[_tokenId];

    require(

      tokenOwner == msg.sender

      || idToApproval[_tokenId] == msg.sender

      || ownerToOperators[tokenOwner][msg.sender]

    );

    _;

  }



}
