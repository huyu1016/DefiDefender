// File: @openzeppelin/contracts/token/ERC20/IERC20.sol



pragma solidity ^0.5.0;



/**

 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include

 * the optional functions; to access them see {ERC20Detailed}.

 */

interface IERC20 {

    /**

     * @dev Returns the amount of tokens in existence.

     */

    function totalSupply() external view returns (uint256);



    /**

     * @dev Returns the amount of tokens owned by `account`.

     */

    function balanceOf(address account) external view returns (uint256);



    /**

     * @dev Moves `amount` tokens from the caller's account to `recipient`.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * Emits a {Transfer} event.

     */

    function transfer(address recipient, uint256 amount) external returns (bool);



    /**

     * @dev Returns the remaining number of tokens that `spender` will be

     * allowed to spend on behalf of `owner` through {transferFrom}. This is

     * zero by default.

     *

     * This value changes when {approve} or {transferFrom} are called.

     */

    function allowance(address owner, address spender) external view returns (uint256);



    /**

     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * IMPORTANT: Beware that changing an allowance with this method brings the risk

     * that someone may use both the old and the new allowance by unfortunate

     * transaction ordering. One possible solution to mitigate this race

     * condition is to first reduce the spender's allowance to 0 and set the

     * desired value afterwards:

     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729

     *

     * Emits an {Approval} event.

     */

    function approve(address spender, uint256 amount) external returns (bool);



    /**

     * @dev Moves `amount` tokens from `sender` to `recipient` using the

     * allowance mechanism. `amount` is then deducted from the caller's

     * allowance.

     *

     * Returns a boolean value indicating whether the operation succeeded.

     *

     * Emits a {Transfer} event.

     */

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);



    /**

     * @dev Emitted when `value` tokens are moved from one account (`from`) to

     * another (`to`).

     *

     * Note that `value` may be zero.

     */

    event Transfer(address indexed from, address indexed to, uint256 value);



    /**

     * @dev Emitted when the allowance of a `spender` for an `owner` is set by

     * a call to {approve}. `value` is the new allowance.

     */

    event Approval(address indexed owner, address indexed spender, uint256 value);

}



// File: akap/contracts/IAKAP.sol



// Copyright (C) 2019  Christian Felde

// Copyright (C) 2019  Mohamed Elshami



// Licensed under the Apache License, Version 2.0 (the "License");

// you may not use this file except in compliance with the License.

// You may obtain a copy of the License at



// http://www.apache.org/licenses/LICENSE-2.0



// Unless required by applicable law or agreed to in writing, software

// distributed under the License is distributed on an "AS IS" BASIS,

// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

// See the License for the specific language governing permissions and

// limitations under the License.



pragma solidity ^0.5.0;



/**

 * @title  Interface for AKA Protocol Registry (akap.me)

 *

 * @author Christian Felde

 * @author Mohamed Elshami

 *

 * @notice This interface defines basic meta data operations in addition to hashOf and claim functions on AKAP nodes.

 * @dev    Functionality related to the ERC-721 nature of nodes also available on AKAP, like transferFrom(..), etc.

 */

contract IAKAP {

    enum ClaimCase {RECLAIM, NEW, TRANSFER}

    enum NodeAttribute {EXPIRY, SEE_ALSO, SEE_ADDRESS, NODE_BODY, TOKEN_URI}



    event Claim(address indexed sender, uint indexed nodeId, uint indexed parentId, bytes label, ClaimCase claimCase);

    event AttributeChanged(address indexed sender, uint indexed nodeId, NodeAttribute attribute);



    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);



    /**

     * @dev Calculate the hash of a parentId and node label.

     *

     * @param parentId Hash value of parent ID

     * @param label Label of node

     * @return Hash ID of node

     */

    function hashOf(uint parentId, bytes memory label) public pure returns (uint id);



    /**

     * @dev Claim or reclaim a node identified by the given parent ID hash and node label.

     *

     * There are 4 potential return value outcomes:

     *

     * 0: No action taken. This is the default if msg.sender does not have permission to act on the specified node.

     * 1: An existing node already owned by msg.sender was reclaimed.

     * 2: Node did not previously exist and is now minted and allocated to msg.sender.

     * 3: An existing node already exist but was expired. Node ownership transferred to msg.sender.

     *

     * If msg.sender is not the owner but is instead approved "spender" of node, the same logic applies. Only on

     * case 2 and 3 does msg.sender become owner of the node. On case 1 only the expiry is updated.

     *

     * Whenever the return value is non-zero, the expiry of the node has been set to 52 weeks into the future.

     *

     * @param parentId Hash value of parent ID

     * @param label Label of node

     * @return Returns one of the above 4 outcomes

     */

    function claim(uint parentId, bytes calldata label) external returns (uint status);



    /**

     * @dev Returns true if nodeId exists.

     *

     * @param nodeId Node hash ID

     * @return True if node exists

     */

    function exists(uint nodeId) external view returns (bool);



    /**

     * @dev Returns whether msg.sender can transfer, claim or operate on a given node ID.

     *

     * @param nodeId Node hash ID

     * @return bool True if approved or owner

     */

    function isApprovedOrOwner(uint nodeId) external view returns (bool);



    /**

     * @dev Gets the owner of the specified node ID.

     *

     * @param tokenId Node hash ID

     * @return address Node owner address

     */

    function ownerOf(uint256 tokenId) public view returns (address);



    /**

     * @dev Return parent hash ID for given node ID.

     *

     * @param nodeId Node hash ID

     * @return Parent hash ID

     */

    function parentOf(uint nodeId) external view returns (uint);



    /**

     * @dev Return expiry timestamp for given node ID.

     *

     * @param nodeId Node hash ID

     * @return Expiry timestamp as seconds since unix epoch

     */

    function expiryOf(uint nodeId) external view returns (uint);



    /**

     * @dev Return "see also" value for given node ID.

     *

     * @param nodeId Node hash ID

     * @return "See also" value

     */

    function seeAlso(uint nodeId) external view returns (uint);



    /**

     * @dev Return "see address" value for given node ID.

     *

     * @param nodeId Node hash ID

     * @return "See address" value

     */

    function seeAddress(uint nodeId) external view returns (address);



    /**

     * @dev Return "node body" value for given node ID.

     *

     * @param nodeId Node hash ID

     * @return "Node body" value

     */

    function nodeBody(uint nodeId) external view returns (bytes memory);



    /**

     * @dev Return "token URI" value for given node ID.

     *

     * @param tokenId Node hash ID

     * @return "Token URI" value

     */

    function tokenURI(uint256 tokenId) external view returns (string memory);



    /**

     * @dev Will immediately expire node on given node ID.

     *

     * An expired node will continue to function as any other node,

     * but is now available to be claimed by a new owner.

     *

     * @param nodeId Node hash ID

     */

    function expireNode(uint nodeId) external;



    /**

     * @dev Set "see also" value on given node ID.

     *

     * @param nodeId Node hash ID

     * @param value New "see also" value

     */

    function setSeeAlso(uint nodeId, uint value) external;



    /**

     * @dev Set "see address" value on given node ID.

     *

     * @param nodeId Node hash ID

     * @param value New "see address" value

     */

    function setSeeAddress(uint nodeId, address value) external;



    /**

     * @dev Set "node body" value on given node ID.

     *

     * @param nodeId Node hash ID

     * @param value New "node body" value

     */

    function setNodeBody(uint nodeId, bytes calldata value) external;



    /**

     * @dev Set "token URI" value on given node ID.

     *

     * @param nodeId Node hash ID

     * @param uri New "token URI" value

     */

    function setTokenURI(uint nodeId, string calldata uri) external;



    /**

     * @dev Approves another address to transfer the given token ID

     *

     * The zero address indicates there is no approved address.

     * There can only be one approved address per token at a given time.

     * Can only be called by the token owner or an approved operator.

     *

     * @param to address to be approved for the given token ID

     * @param tokenId uint256 ID of the token to be approved

     */

    function approve(address to, uint256 tokenId) public;



    /**

     * @dev Gets the approved address for a token ID, or zero if no address set

     *

     * Reverts if the token ID does not exist.

     *

     * @param tokenId uint256 ID of the token to query the approval of

     * @return address currently approved for the given token ID

     */

    function getApproved(uint256 tokenId) public view returns (address);



    /**

     * @dev Sets or unsets the approval of a given operator

     *

     * An operator is allowed to transfer all tokens of the sender on their behalf.

     *

     * @param to operator address to set the approval

     * @param approved representing the status of the approval to be set

     */

    function setApprovalForAll(address to, bool approved) public;



    /**

     * @dev Tells whether an operator is approved by a given owner.

     *

     * @param owner owner address which you want to query the approval of

     * @param operator operator address which you want to query the approval of

     * @return bool whether the given operator is approved by the given owner

     */

    function isApprovedForAll(address owner, address operator) public view returns (bool);



    /**

     * @dev Transfers the ownership of a given token ID to another address.

     *

     * Usage of this method is discouraged, use `safeTransferFrom` whenever possible.

     * Requires the msg.sender to be the owner, approved, or operator.

     *

     * @param from current owner of the token

     * @param to address to receive the ownership of the given token ID

     * @param tokenId uint256 ID of the token to be transferred

     */

    function transferFrom(address from, address to, uint256 tokenId) public;



    /**

     * @dev Safely transfers the ownership of a given token ID to another address

     *

     * If the target address is a contract, it must implement `onERC721Received`,

     * which is called upon a safe transfer, and return the magic value

     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,

     * the transfer is reverted.

     * Requires the msg.sender to be the owner, approved, or operator

     *

     * @param from current owner of the token

     * @param to address to receive the ownership of the given token ID

     * @param tokenId uint256 ID of the token to be transferred

     */

    function safeTransferFrom(address from, address to, uint256 tokenId) public;



    /**

     * @dev Safely transfers the ownership of a given token ID to another address

     *

     * If the target address is a contract, it must implement `onERC721Received`,

     * which is called upon a safe transfer, and return the magic value

     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,

     * the transfer is reverted.

     * Requires the msg.sender to be the owner, approved, or operator

     *

     * @param from current owner of the token

     * @param to address to receive the ownership of the given token ID

     * @param tokenId uint256 ID of the token to be transferred

     * @param _data bytes data to send along with a safe transfer check

     */

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public;

}



// File: @openzeppelin/contracts/introspection/IERC165.sol



pragma solidity ^0.5.0;



/**

 * @dev Interface of the ERC165 standard, as defined in the

 * https://eips.ethereum.org/EIPS/eip-165[EIP].

 *

 * Implementers can declare support of contract interfaces, which can then be

 * queried by others ({ERC165Checker}).

 *

 * For an implementation, see {ERC165}.

 */

interface IERC165 {

    /**

     * @dev Returns true if this contract implements the interface defined by

     * `interfaceId`. See the corresponding

     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]

     * to learn more about how these ids are created.

     *

     * This function call must use less than 30 000 gas.

     */

    function supportsInterface(bytes4 interfaceId) external view returns (bool);

}



// File: @openzeppelin/contracts/token/ERC721/IERC721.sol



pragma solidity ^0.5.0;





/**

 * @dev Required interface of an ERC721 compliant contract.

 */

contract IERC721 is IERC165 {

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);



    /**

     * @dev Returns the number of NFTs in `owner`'s account.

     */

    function balanceOf(address owner) public view returns (uint256 balance);



    /**

     * @dev Returns the owner of the NFT specified by `tokenId`.

     */

    function ownerOf(uint256 tokenId) public view returns (address owner);



    /**

     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to

     * another (`to`).

     *

     *

     *

     * Requirements:

     * - `from`, `to` cannot be zero.

     * - `tokenId` must be owned by `from`.

     * - If the caller is not `from`, it must be have been allowed to move this

     * NFT by either {approve} or {setApprovalForAll}.

     */

    function safeTransferFrom(address from, address to, uint256 tokenId) public;

    /**

     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to

     * another (`to`).

     *

     * Requirements:

     * - If the caller is not `from`, it must be approved to move this NFT by

     * either {approve} or {setApprovalForAll}.

     */

    function transferFrom(address from, address to, uint256 tokenId) public;

    function approve(address to, uint256 tokenId) public;

    function getApproved(uint256 tokenId) public view returns (address operator);



    function setApprovalForAll(address operator, bool _approved) public;

    function isApprovedForAll(address owner, address operator) public view returns (bool);





    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;

}



// File: akap-utils/contracts/domain/IDomainManager.sol



// Copyright (C) 2020  Christian Felde



// Licensed under the Apache License, Version 2.0 (the "License");

// you may not use this file except in compliance with the License.

// You may obtain a copy of the License at



// http://www.apache.org/licenses/LICENSE-2.0



// Unless required by applicable law or agreed to in writing, software

// distributed under the License is distributed on an "AS IS" BASIS,

// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

// See the License for the specific language governing permissions and

// limitations under the License.



pragma solidity ^0.5.0;







contract IDomainManager {

    function akap() public view returns (IAKAP);



    function erc721() public view returns (IERC721);



    function domainParent() public view returns (uint);



    function domainLabel() public view returns (bytes memory);



    function domain() public view returns (uint);



    function setApprovalForAll(address to, bool approved) public;



    function claim(bytes memory label) public returns (uint status);



    function claim(uint parentId, bytes memory label) public returns (uint);



    function reclaim() public returns (uint);

}



// File: akap-utils/contracts/types/Uint256Lib.sol



// Copyright (C) 2020  Christian Felde



// Licensed under the Apache License, Version 2.0 (the "License");

// you may not use this file except in compliance with the License.

// You may obtain a copy of the License at



// http://www.apache.org/licenses/LICENSE-2.0



// Unless required by applicable law or agreed to in writing, software

// distributed under the License is distributed on an "AS IS" BASIS,

// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

// See the License for the specific language governing permissions and

// limitations under the License.



pragma solidity ^0.5.0;



library Uint256Lib {

    function asBytes(uint256 x) internal pure returns (bytes memory b) {

        return abi.encodePacked(x);

    }

}



// File: akap-utils/contracts/types/StringLib.sol



// Copyright (C) 2020  Christian Felde



// Licensed under the Apache License, Version 2.0 (the "License");

// you may not use this file except in compliance with the License.

// You may obtain a copy of the License at



// http://www.apache.org/licenses/LICENSE-2.0



// Unless required by applicable law or agreed to in writing, software

// distributed under the License is distributed on an "AS IS" BASIS,

// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

// See the License for the specific language governing permissions and

// limitations under the License.



pragma solidity ^0.5.0;



library StringLib {

    function asBytes(string memory s) internal pure returns (bytes memory) {

        return bytes(s);

    }

}



// File: akap-utils/contracts/types/AddressLib.sol



// Copyright (C) 2020  Christian Felde



// Licensed under the Apache License, Version 2.0 (the "License");

// you may not use this file except in compliance with the License.

// You may obtain a copy of the License at



// http://www.apache.org/licenses/LICENSE-2.0



// Unless required by applicable law or agreed to in writing, software

// distributed under the License is distributed on an "AS IS" BASIS,

// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

// See the License for the specific language governing permissions and

// limitations under the License.



pragma solidity ^0.5.0;



library AddressLib {

    function asBytes(address x) internal pure returns (bytes memory b) {

        return abi.encodePacked(x);

    }

}



// File: akap-utils/contracts/types/BytesLib.sol



// Copyright (C) 2020  Christian Felde



// Licensed under the Apache License, Version 2.0 (the "License");

// you may not use this file except in compliance with the License.

// You may obtain a copy of the License at



// http://www.apache.org/licenses/LICENSE-2.0



// Unless required by applicable law or agreed to in writing, software

// distributed under the License is distributed on an "AS IS" BASIS,

// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

// See the License for the specific language governing permissions and

// limitations under the License.



pragma solidity ^0.5.0;



library BytesLib {

    function asAddress(bytes memory b) internal pure returns (address x) {

        if (b.length == 0) {

            x = address(0);

        } else {

            assembly {

                x := mload(add(b, 0x14))

            }

        }

    }



    function asBool(bytes memory b) internal pure returns (bool x) {

        if (asUint8(b) > 0) return true;



        return false;

    }



    function asString(bytes memory b) internal pure returns (string memory) {

        return string(b);

    }



    function asUint8(bytes memory b) internal pure returns (uint8 x) {

        if (b.length == 0) {

            x = 0;

        } else {

            assembly {

                x := mload(add(b, 0x1))

            }

        }

    }



    function asUint160(bytes memory b) internal pure returns (uint160 x) {

        if (b.length == 0) {

            x = 0;

        } else {

            assembly {

                x := mload(add(b, 0x14))

            }

        }

    }



    function asUint256(bytes memory b) internal pure returns (uint256 x) {

        if (b.length == 0) {

            x = 0;

        } else {

            assembly {

                x := mload(add(b, 0x20))

            }

        }

    }

}



// File: akap-utils/contracts/collections/ISimpleMap.sol



// Copyright (C) 2020  Christian Felde



// Licensed under the Apache License, Version 2.0 (the "License");

// you may not use this file except in compliance with the License.

// You may obtain a copy of the License at



// http://www.apache.org/licenses/LICENSE-2.0



// Unless required by applicable law or agreed to in writing, software

// distributed under the License is distributed on an "AS IS" BASIS,

// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

// See the License for the specific language governing permissions and

// limitations under the License.



pragma solidity ^0.5.0;



contract ISimpleMap {

    function get(bytes memory key) public view returns (bytes memory value);



    function put(bytes memory key, bytes memory newValue) public;



    function remove(bytes memory key) public;

}



// File: contracts/RTokenLike.sol



pragma solidity ^0.5.0;





contract RTokenLike is IERC20 {

    function mint(uint256 mintAmount) external returns (bool);



    function mintWithSelectedHat(uint256 mintAmount, uint256 hatID) external returns (bool);



    function mintWithNewHat(

        uint256 mintAmount,

        address[] calldata recipients,

        uint32[] calldata proportions

    ) external returns (bool);



    function transferAll(address dst) external returns (bool);



    function transferAllFrom(address src, address dst) external returns (bool);



    function redeem(uint256 redeemTokens) external returns (bool);



    function redeemAll() external returns (bool);



    function redeemAndTransfer(address redeemTo, uint256 redeemTokens) external returns (bool);



    function redeemAndTransferAll(address redeemTo) external returns (bool);



    function createHat(

        address[] calldata recipients,

        uint32[] calldata proportions,

        bool doChangeHat

    ) external returns (uint256 hatID);



    function changeHat(uint256 hatID) external returns (bool);



    function payInterest(address owner) external returns (bool);



    function getMaximumHatID() external view returns (uint256 hatID);



    function getHatByAddress(address owner)

    external

    view

    returns (

        uint256 hatID,

        address[] memory recipients,

        uint32[] memory proportions

    );



    function getHatByID(uint256 hatID)

    external

    view

    returns (address[] memory recipients, uint32[] memory proportions);



    function receivedSavingsOf(address owner)

    external

    view

    returns (uint256 amount);



    function receivedLoanOf(address owner)

    external

    view

    returns (uint256 amount);



    function interestPayableOf(address owner)

    external

    view

    returns (uint256 amount);



    event LoansTransferred(

        address indexed owner,

        address indexed recipient,

        uint256 indexed hatId,

        bool isDistribution,

        uint256 redeemableAmount,

        uint256 internalSavingsAmount);



    event InterestPaid(address indexed recipient, uint256 amount);



    event HatCreated(uint256 indexed hatID);



    event HatChanged(address indexed account, uint256 indexed oldHatID, uint256 indexed newHatID);

}



// File: @openzeppelin/contracts/GSN/Context.sol



pragma solidity ^0.5.0;



/*

 * @dev Provides information about the current execution context, including the

 * sender of the transaction and its data. While these are generally available

 * via msg.sender and msg.data, they should not be accessed in such a direct

 * manner, since when dealing with GSN meta-transactions the account sending and

 * paying for execution may not be the actual sender (as far as an application

 * is concerned).

 *

 * This contract is only required for intermediate, library-like contracts.

 */

contract Context {

    // Empty internal constructor, to prevent people from mistakenly deploying

    // an instance of this contract, which should be used via inheritance.

    constructor () internal { }

    // solhint-disable-previous-line no-empty-blocks



    function _msgSender() internal view returns (address payable) {

        return msg.sender;

    }



    function _msgData() internal view returns (bytes memory) {

        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691

        return msg.data;

    }

}



// File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol



pragma solidity ^0.5.0;



/**

 * @title ERC721 token receiver interface

 * @dev Interface for any contract that wants to support safeTransfers

 * from ERC721 asset contracts.

 */

contract IERC721Receiver {

    /**

     * @notice Handle the receipt of an NFT

     * @dev The ERC721 smart contract calls this function on the recipient

     * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,

     * otherwise the caller will revert the transaction. The selector to be

     * returned can be obtained as `this.onERC721Received.selector`. This

     * function MAY throw to revert and reject the transfer.

     * Note: the ERC721 contract address is always the message sender.

     * @param operator The address which called `safeTransferFrom` function

     * @param from The address which previously owned the token

     * @param tokenId The NFT identifier which is being transferred

     * @param data Additional data with no specified format

     * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`

     */

    function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)

    public returns (bytes4);

}



// File: @openzeppelin/contracts/math/SafeMath.sol



pragma solidity ^0.5.0;



/**

 * @dev Wrappers over Solidity's arithmetic operations with added overflow

 * checks.

 *

 * Arithmetic operations in Solidity wrap on overflow. This can easily result

 * in bugs, because programmers usually assume that an overflow raises an

 * error, which is the standard behavior in high level programming languages.

 * `SafeMath` restores this intuition by reverting the transaction when an

 * operation overflows.

 *

 * Using this library instead of the unchecked operations eliminates an entire

 * class of bugs, so it's recommended to use it always.

 */

library SafeMath {

    /**

     * @dev Returns the addition of two unsigned integers, reverting on

     * overflow.

     *

     * Counterpart to Solidity's `+` operator.

     *

     * Requirements:

     * - Addition cannot overflow.

     */

    function add(uint256 a, uint256 b) internal pure returns (uint256) {

        uint256 c = a + b;

        require(c >= a, "SafeMath: addition overflow");



        return c;

    }



    /**

     * @dev Returns the subtraction of two unsigned integers, reverting on

     * overflow (when the result is negative).

     *

     * Counterpart to Solidity's `-` operator.

     *

     * Requirements:

     * - Subtraction cannot overflow.

     */

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

        return sub(a, b, "SafeMath: subtraction overflow");

    }



    /**

     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on

     * overflow (when the result is negative).

     *

     * Counterpart to Solidity's `-` operator.

     *

     * Requirements:

     * - Subtraction cannot overflow.

     *

     * _Available since v2.4.0._

     */

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b <= a, errorMessage);

        uint256 c = a - b;



        return c;

    }



    /**

     * @dev Returns the multiplication of two unsigned integers, reverting on

     * overflow.

     *

     * Counterpart to Solidity's `*` operator.

     *

     * Requirements:

     * - Multiplication cannot overflow.

     */

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {

        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the

        // benefit is lost if 'b' is also tested.

        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522

        if (a == 0) {

            return 0;

        }



        uint256 c = a * b;

        require(c / a == b, "SafeMath: multiplication overflow");



        return c;

    }



    /**

     * @dev Returns the integer division of two unsigned integers. Reverts on

     * division by zero. The result is rounded towards zero.

     *

     * Counterpart to Solidity's `/` operator. Note: this function uses a

     * `revert` opcode (which leaves remaining gas untouched) while Solidity

     * uses an invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.

     */

    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        return div(a, b, "SafeMath: division by zero");

    }



    /**

     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on

     * division by zero. The result is rounded towards zero.

     *

     * Counterpart to Solidity's `/` operator. Note: this function uses a

     * `revert` opcode (which leaves remaining gas untouched) while Solidity

     * uses an invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.

     *

     * _Available since v2.4.0._

     */

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        // Solidity only automatically asserts when dividing by 0

        require(b > 0, errorMessage);

        uint256 c = a / b;

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold



        return c;

    }



    /**

     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),

     * Reverts when dividing by zero.

     *

     * Counterpart to Solidity's `%` operator. This function uses a `revert`

     * opcode (which leaves remaining gas untouched) while Solidity uses an

     * invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.

     */

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {

        return mod(a, b, "SafeMath: modulo by zero");

    }



    /**

     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),

     * Reverts with custom message when dividing by zero.

     *

     * Counterpart to Solidity's `%` operator. This function uses a `revert`

     * opcode (which leaves remaining gas untouched) while Solidity uses an

     * invalid opcode to revert (consuming all remaining gas).

     *

     * Requirements:

     * - The divisor cannot be zero.

     *

     * _Available since v2.4.0._

     */

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

        require(b != 0, errorMessage);

        return a % b;

    }

}



// File: @openzeppelin/contracts/utils/Address.sol



pragma solidity ^0.5.5;



/**

 * @dev Collection of functions related to the address type

 */

library Address {

    /**

     * @dev Returns true if `account` is a contract.

     *

     * [IMPORTANT]

     * ====

     * It is unsafe to assume that an address for which this function returns

     * false is an externally-owned account (EOA) and not a contract.

     *

     * Among others, `isContract` will return false for the following 

     * types of addresses:

     *

     *  - an externally-owned account

     *  - a contract in construction

     *  - an address where a contract will be created

     *  - an address where a contract lived, but was destroyed

     * ====

     */

    function isContract(address account) internal view returns (bool) {

        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts

        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned

        // for accounts without code, i.e. `keccak256('')`

        bytes32 codehash;

        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;

        // solhint-disable-next-line no-inline-assembly

        assembly { codehash := extcodehash(account) }

        return (codehash != accountHash && codehash != 0x0);

    }



    /**

     * @dev Converts an `address` into `address payable`. Note that this is

     * simply a type cast: the actual underlying value is not changed.

     *

     * _Available since v2.4.0._

     */

    function toPayable(address account) internal pure returns (address payable) {

        return address(uint160(account));

    }



    /**

     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to

     * `recipient`, forwarding all available gas and reverting on errors.

     *

     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost

     * of certain opcodes, possibly making contracts go over the 2300 gas limit

     * imposed by `transfer`, making them unable to receive funds via

     * `transfer`. {sendValue} removes this limitation.

     *

     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].

     *

     * IMPORTANT: because control is transferred to `recipient`, care must be

     * taken to not create reentrancy vulnerabilities. Consider using

     * {ReentrancyGuard} or the

     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].

     *

     * _Available since v2.4.0._

     */

    function sendValue(address payable recipient, uint256 amount) internal {

        require(address(this).balance >= amount, "Address: insufficient balance");



        // solhint-disable-next-line avoid-call-value

        (bool success, ) = recipient.call.value(amount)("");

        require(success, "Address: unable to send value, recipient may have reverted");

    }

}



// File: @openzeppelin/contracts/drafts/Counters.sol



pragma solidity ^0.5.0;





/**

 * @title Counters

 * @author Matt Condon (@shrugs)

 * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number

 * of elements in a mapping, issuing ERC721 ids, or counting request ids.

 *

 * Include with `using Counters for Counters.Counter;`

 * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}

 * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never

 * directly accessed.

 */

library Counters {

    using SafeMath for uint256;



    struct Counter {

        // This variable should never be directly accessed by users of the library: interactions must be restricted to

        // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add

        // this feature: see https://github.com/ethereum/solidity/issues/4637

        uint256 _value; // default: 0

    }



    function current(Counter storage counter) internal view returns (uint256) {

        return counter._value;

    }



    function increment(Counter storage counter) internal {

        // The {SafeMath} overflow check can be skipped here, see the comment at the top

        counter._value += 1;

    }



    function decrement(Counter storage counter) internal {

        counter._value = counter._value.sub(1);

    }

}



// File: @openzeppelin/contracts/introspection/ERC165.sol



pragma solidity ^0.5.0;





/**

 * @dev Implementation of the {IERC165} interface.

 *

 * Contracts may inherit from this and call {_registerInterface} to declare

 * their support of an interface.

 */

contract ERC165 is IERC165 {

    /*

     * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7

     */

    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;



    /**

     * @dev Mapping of interface ids to whether or not it's supported.

     */

    mapping(bytes4 => bool) private _supportedInterfaces;



    constructor () internal {

        // Derived contracts need only register support for their own interfaces,

        // we register support for ERC165 itself here

        _registerInterface(_INTERFACE_ID_ERC165);

    }



    /**

     * @dev See {IERC165-supportsInterface}.

     *

     * Time complexity O(1), guaranteed to always use less than 30 000 gas.

     */

    function supportsInterface(bytes4 interfaceId) external view returns (bool) {

        return _supportedInterfaces[interfaceId];

    }



    /**

     * @dev Registers the contract as an implementer of the interface defined by

     * `interfaceId`. Support of the actual ERC165 interface is automatic and

     * registering its interface id is not required.

     *

     * See {IERC165-supportsInterface}.

     *

     * Requirements:

     *

     * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).

     */

    function _registerInterface(bytes4 interfaceId) internal {

        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");

        _supportedInterfaces[interfaceId] = true;

    }

}



// File: @openzeppelin/contracts/token/ERC721/ERC721.sol



pragma solidity ^0.5.0;

















/**

 * @title ERC721 Non-Fungible Token Standard basic implementation

 * @dev see https://eips.ethereum.org/EIPS/eip-721

 */

contract ERC721 is Context, ERC165, IERC721 {

    using SafeMath for uint256;

    using Address for address;

    using Counters for Counters.Counter;



    // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`

    // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`

    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;



    // Mapping from token ID to owner

    mapping (uint256 => address) private _tokenOwner;



    // Mapping from token ID to approved address

    mapping (uint256 => address) private _tokenApprovals;



    // Mapping from owner to number of owned token

    mapping (address => Counters.Counter) private _ownedTokensCount;



    // Mapping from owner to operator approvals

    mapping (address => mapping (address => bool)) private _operatorApprovals;



    /*

     *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231

     *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e

     *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3

     *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc

     *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465

     *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5

     *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd

     *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e

     *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde

     *

     *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^

     *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd

     */

    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;



    constructor () public {

        // register the supported interfaces to conform to ERC721 via ERC165

        _registerInterface(_INTERFACE_ID_ERC721);

    }



    /**

     * @dev Gets the balance of the specified address.

     * @param owner address to query the balance of

     * @return uint256 representing the amount owned by the passed address

     */

    function balanceOf(address owner) public view returns (uint256) {

        require(owner != address(0), "ERC721: balance query for the zero address");



        return _ownedTokensCount[owner].current();

    }



    /**

     * @dev Gets the owner of the specified token ID.

     * @param tokenId uint256 ID of the token to query the owner of

     * @return address currently marked as the owner of the given token ID

     */

    function ownerOf(uint256 tokenId) public view returns (address) {

        address owner = _tokenOwner[tokenId];

        require(owner != address(0), "ERC721: owner query for nonexistent token");



        return owner;

    }



    /**

     * @dev Approves another address to transfer the given token ID

     * The zero address indicates there is no approved address.

     * There can only be one approved address per token at a given time.

     * Can only be called by the token owner or an approved operator.

     * @param to address to be approved for the given token ID

     * @param tokenId uint256 ID of the token to be approved

     */

    function approve(address to, uint256 tokenId) public {

        address owner = ownerOf(tokenId);

        require(to != owner, "ERC721: approval to current owner");



        require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),

            "ERC721: approve caller is not owner nor approved for all"

        );



        _tokenApprovals[tokenId] = to;

        emit Approval(owner, to, tokenId);

    }



    /**

     * @dev Gets the approved address for a token ID, or zero if no address set

     * Reverts if the token ID does not exist.

     * @param tokenId uint256 ID of the token to query the approval of

     * @return address currently approved for the given token ID

     */

    function getApproved(uint256 tokenId) public view returns (address) {

        require(_exists(tokenId), "ERC721: approved query for nonexistent token");



        return _tokenApprovals[tokenId];

    }



    /**

     * @dev Sets or unsets the approval of a given operator

     * An operator is allowed to transfer all tokens of the sender on their behalf.

     * @param to operator address to set the approval

     * @param approved representing the status of the approval to be set

     */

    function setApprovalForAll(address to, bool approved) public {

        require(to != _msgSender(), "ERC721: approve to caller");



        _operatorApprovals[_msgSender()][to] = approved;

        emit ApprovalForAll(_msgSender(), to, approved);

    }



    /**

     * @dev Tells whether an operator is approved by a given owner.

     * @param owner owner address which you want to query the approval of

     * @param operator operator address which you want to query the approval of

     * @return bool whether the given operator is approved by the given owner

     */

    function isApprovedForAll(address owner, address operator) public view returns (bool) {

        return _operatorApprovals[owner][operator];

    }



    /**

     * @dev Transfers the ownership of a given token ID to another address.

     * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.

     * Requires the msg.sender to be the owner, approved, or operator.

     * @param from current owner of the token

     * @param to address to receive the ownership of the given token ID

     * @param tokenId uint256 ID of the token to be transferred

     */

    function transferFrom(address from, address to, uint256 tokenId) public {

        //solhint-disable-next-line max-line-length

        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");



        _transferFrom(from, to, tokenId);

    }



    /**

     * @dev Safely transfers the ownership of a given token ID to another address

     * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},

     * which is called upon a safe transfer, and return the magic value

     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,

     * the transfer is reverted.

     * Requires the msg.sender to be the owner, approved, or operator

     * @param from current owner of the token

     * @param to address to receive the ownership of the given token ID

     * @param tokenId uint256 ID of the token to be transferred

     */

    function safeTransferFrom(address from, address to, uint256 tokenId) public {

        safeTransferFrom(from, to, tokenId, "");

    }



    /**

     * @dev Safely transfers the ownership of a given token ID to another address

     * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},

     * which is called upon a safe transfer, and return the magic value

     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,

     * the transfer is reverted.

     * Requires the _msgSender() to be the owner, approved, or operator

     * @param from current owner of the token

     * @param to address to receive the ownership of the given token ID

     * @param tokenId uint256 ID of the token to be transferred

     * @param _data bytes data to send along with a safe transfer check

     */

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {

        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

        _safeTransferFrom(from, to, tokenId, _data);

    }



    /**

     * @dev Safely transfers the ownership of a given token ID to another address

     * If the target address is a contract, it must implement `onERC721Received`,

     * which is called upon a safe transfer, and return the magic value

     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,

     * the transfer is reverted.

     * Requires the msg.sender to be the owner, approved, or operator

     * @param from current owner of the token

     * @param to address to receive the ownership of the given token ID

     * @param tokenId uint256 ID of the token to be transferred

     * @param _data bytes data to send along with a safe transfer check

     */

    function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {

        _transferFrom(from, to, tokenId);

        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");

    }



    /**

     * @dev Returns whether the specified token exists.

     * @param tokenId uint256 ID of the token to query the existence of

     * @return bool whether the token exists

     */

    function _exists(uint256 tokenId) internal view returns (bool) {

        address owner = _tokenOwner[tokenId];

        return owner != address(0);

    }



    /**

     * @dev Returns whether the given spender can transfer a given token ID.

     * @param spender address of the spender to query

     * @param tokenId uint256 ID of the token to be transferred

     * @return bool whether the msg.sender is approved for the given token ID,

     * is an operator of the owner, or is the owner of the token

     */

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {

        require(_exists(tokenId), "ERC721: operator query for nonexistent token");

        address owner = ownerOf(tokenId);

        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));

    }



    /**

     * @dev Internal function to safely mint a new token.

     * Reverts if the given token ID already exists.

     * If the target address is a contract, it must implement `onERC721Received`,

     * which is called upon a safe transfer, and return the magic value

     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,

     * the transfer is reverted.

     * @param to The address that will own the minted token

     * @param tokenId uint256 ID of the token to be minted

     */

    function _safeMint(address to, uint256 tokenId) internal {

        _safeMint(to, tokenId, "");

    }



    /**

     * @dev Internal function to safely mint a new token.

     * Reverts if the given token ID already exists.

     * If the target address is a contract, it must implement `onERC721Received`,

     * which is called upon a safe transfer, and return the magic value

     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,

     * the transfer is reverted.

     * @param to The address that will own the minted token

     * @param tokenId uint256 ID of the token to be minted

     * @param _data bytes data to send along with a safe transfer check

     */

    function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {

        _mint(to, tokenId);

        require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");

    }



    /**

     * @dev Internal function to mint a new token.

     * Reverts if the given token ID already exists.

     * @param to The address that will own the minted token

     * @param tokenId uint256 ID of the token to be minted

     */

    function _mint(address to, uint256 tokenId) internal {

        require(to != address(0), "ERC721: mint to the zero address");

        require(!_exists(tokenId), "ERC721: token already minted");



        _tokenOwner[tokenId] = to;

        _ownedTokensCount[to].increment();



        emit Transfer(address(0), to, tokenId);

    }



    /**

     * @dev Internal function to burn a specific token.

     * Reverts if the token does not exist.

     * Deprecated, use {_burn} instead.

     * @param owner owner of the token to burn

     * @param tokenId uint256 ID of the token being burned

     */

    function _burn(address owner, uint256 tokenId) internal {

        require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");



        _clearApproval(tokenId);



        _ownedTokensCount[owner].decrement();

        _tokenOwner[tokenId] = address(0);



        emit Transfer(owner, address(0), tokenId);

    }



    /**

     * @dev Internal function to burn a specific token.

     * Reverts if the token does not exist.

     * @param tokenId uint256 ID of the token being burned

     */

    function _burn(uint256 tokenId) internal {

        _burn(ownerOf(tokenId), tokenId);

    }



    /**

     * @dev Internal function to transfer ownership of a given token ID to another address.

     * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.

     * @param from current owner of the token

     * @param to address to receive the ownership of the given token ID

     * @param tokenId uint256 ID of the token to be transferred

     */

    function _transferFrom(address from, address to, uint256 tokenId) internal {

        require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");

        require(to != address(0), "ERC721: transfer to the zero address");



        _clearApproval(tokenId);



        _ownedTokensCount[from].decrement();

        _ownedTokensCount[to].increment();



        _tokenOwner[tokenId] = to;



        emit Transfer(from, to, tokenId);

    }



    /**

     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.

     * The call is not executed if the target address is not a contract.

     *

     * This is an internal detail of the `ERC721` contract and its use is deprecated.

     * @param from address representing the previous owner of the given token ID

     * @param to target address that will receive the tokens

     * @param tokenId uint256 ID of the token to be transferred

     * @param _data bytes optional data to send along with the call

     * @return bool whether the call correctly returned the expected magic value

     */

    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)

        internal returns (bool)

    {

        if (!to.isContract()) {

            return true;

        }

        // solhint-disable-next-line avoid-low-level-calls

        (bool success, bytes memory returndata) = to.call(abi.encodeWithSelector(

            IERC721Receiver(to).onERC721Received.selector,

            _msgSender(),

            from,

            tokenId,

            _data

        ));

        if (!success) {

            if (returndata.length > 0) {

                // solhint-disable-next-line no-inline-assembly

                assembly {

                    let returndata_size := mload(returndata)

                    revert(add(32, returndata), returndata_size)

                }

            } else {

                revert("ERC721: transfer to non ERC721Receiver implementer");

            }

        } else {

            bytes4 retval = abi.decode(returndata, (bytes4));

            return (retval == _ERC721_RECEIVED);

        }

    }



    /**

     * @dev Private function to clear current approval of a given token ID.

     * @param tokenId uint256 ID of the token to be transferred

     */

    function _clearApproval(uint256 tokenId) private {

        if (_tokenApprovals[tokenId] != address(0)) {

            _tokenApprovals[tokenId] = address(0);

        }

    }

}



// File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol



pragma solidity ^0.5.0;





/**

 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension

 * @dev See https://eips.ethereum.org/EIPS/eip-721

 */

contract IERC721Enumerable is IERC721 {

    function totalSupply() public view returns (uint256);

    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);



    function tokenByIndex(uint256 index) public view returns (uint256);

}



// File: @openzeppelin/contracts/token/ERC721/ERC721Enumerable.sol



pragma solidity ^0.5.0;











/**

 * @title ERC-721 Non-Fungible Token with optional enumeration extension logic

 * @dev See https://eips.ethereum.org/EIPS/eip-721

 */

contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {

    // Mapping from owner to list of owned token IDs

    mapping(address => uint256[]) private _ownedTokens;



    // Mapping from token ID to index of the owner tokens list

    mapping(uint256 => uint256) private _ownedTokensIndex;



    // Array with all token ids, used for enumeration

    uint256[] private _allTokens;



    // Mapping from token id to position in the allTokens array

    mapping(uint256 => uint256) private _allTokensIndex;



    /*

     *     bytes4(keccak256('totalSupply()')) == 0x18160ddd

     *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59

     *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7

     *

     *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63

     */

    bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;



    /**

     * @dev Constructor function.

     */

    constructor () public {

        // register the supported interface to conform to ERC721Enumerable via ERC165

        _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);

    }



    /**

     * @dev Gets the token ID at a given index of the tokens list of the requested owner.

     * @param owner address owning the tokens list to be accessed

     * @param index uint256 representing the index to be accessed of the requested tokens list

     * @return uint256 token ID at the given index of the tokens list owned by the requested address

     */

    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {

        require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");

        return _ownedTokens[owner][index];

    }



    /**

     * @dev Gets the total amount of tokens stored by the contract.

     * @return uint256 representing the total amount of tokens

     */

    function totalSupply() public view returns (uint256) {

        return _allTokens.length;

    }



    /**

     * @dev Gets the token ID at a given index of all the tokens in this contract

     * Reverts if the index is greater or equal to the total number of tokens.

     * @param index uint256 representing the index to be accessed of the tokens list

     * @return uint256 token ID at the given index of the tokens list

     */

    function tokenByIndex(uint256 index) public view returns (uint256) {

        require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");

        return _allTokens[index];

    }



    /**

     * @dev Internal function to transfer ownership of a given token ID to another address.

     * As opposed to transferFrom, this imposes no restrictions on msg.sender.

     * @param from current owner of the token

     * @param to address to receive the ownership of the given token ID

     * @param tokenId uint256 ID of the token to be transferred

     */

    function _transferFrom(address from, address to, uint256 tokenId) internal {

        super._transferFrom(from, to, tokenId);



        _removeTokenFromOwnerEnumeration(from, tokenId);



        _addTokenToOwnerEnumeration(to, tokenId);

    }



    /**

     * @dev Internal function to mint a new token.

     * Reverts if the given token ID already exists.

     * @param to address the beneficiary that will own the minted token

     * @param tokenId uint256 ID of the token to be minted

     */

    function _mint(address to, uint256 tokenId) internal {

        super._mint(to, tokenId);



        _addTokenToOwnerEnumeration(to, tokenId);



        _addTokenToAllTokensEnumeration(tokenId);

    }



    /**

     * @dev Internal function to burn a specific token.

     * Reverts if the token does not exist.

     * Deprecated, use {ERC721-_burn} instead.

     * @param owner owner of the token to burn

     * @param tokenId uint256 ID of the token being burned

     */

    function _burn(address owner, uint256 tokenId) internal {

        super._burn(owner, tokenId);



        _removeTokenFromOwnerEnumeration(owner, tokenId);

        // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund

        _ownedTokensIndex[tokenId] = 0;



        _removeTokenFromAllTokensEnumeration(tokenId);

    }



    /**

     * @dev Gets the list of token IDs of the requested owner.

     * @param owner address owning the tokens

     * @return uint256[] List of token IDs owned by the requested address

     */

    function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {

        return _ownedTokens[owner];

    }



    /**

     * @dev Private function to add a token to this extension's ownership-tracking data structures.

     * @param to address representing the new owner of the given token ID

     * @param tokenId uint256 ID of the token to be added to the tokens list of the given address

     */

    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {

        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;

        _ownedTokens[to].push(tokenId);

    }



    /**

     * @dev Private function to add a token to this extension's token tracking data structures.

     * @param tokenId uint256 ID of the token to be added to the tokens list

     */

    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {

        _allTokensIndex[tokenId] = _allTokens.length;

        _allTokens.push(tokenId);

    }



    /**

     * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that

     * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for

     * gas optimizations e.g. when performing a transfer operation (avoiding double writes).

     * This has O(1) time complexity, but alters the order of the _ownedTokens array.

     * @param from address representing the previous owner of the given token ID

     * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address

     */

    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {

        // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and

        // then delete the last slot (swap and pop).



        uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);

        uint256 tokenIndex = _ownedTokensIndex[tokenId];



        // When the token to delete is the last token, the swap operation is unnecessary

        if (tokenIndex != lastTokenIndex) {

            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];



            _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token

            _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index

        }



        // This also deletes the contents at the last position of the array

        _ownedTokens[from].length--;



        // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by

        // lastTokenId, or just over the end of the array if the token was the last one).

    }



    /**

     * @dev Private function to remove a token from this extension's token tracking data structures.

     * This has O(1) time complexity, but alters the order of the _allTokens array.

     * @param tokenId uint256 ID of the token to be removed from the tokens list

     */

    function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {

        // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and

        // then delete the last slot (swap and pop).



        uint256 lastTokenIndex = _allTokens.length.sub(1);

        uint256 tokenIndex = _allTokensIndex[tokenId];



        // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so

        // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding

        // an 'if' statement (like in _removeTokenFromOwnerEnumeration)

        uint256 lastTokenId = _allTokens[lastTokenIndex];



        _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token

        _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index



        // This also deletes the contents at the last position of the array

        _allTokens.length--;

        _allTokensIndex[tokenId] = 0;

    }

}



// File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol



pragma solidity ^0.5.0;





/**

 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension

 * @dev See https://eips.ethereum.org/EIPS/eip-721

 */

contract IERC721Metadata is IERC721 {

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function tokenURI(uint256 tokenId) external view returns (string memory);

}



// File: @openzeppelin/contracts/token/ERC721/ERC721Metadata.sol



pragma solidity ^0.5.0;











contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {

    // Token name

    string private _name;



    // Token symbol

    string private _symbol;



    // Base URI

    string private _baseURI;



    // Optional mapping for token URIs

    mapping(uint256 => string) private _tokenURIs;



    /*

     *     bytes4(keccak256('name()')) == 0x06fdde03

     *     bytes4(keccak256('symbol()')) == 0x95d89b41

     *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd

     *

     *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f

     */

    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;



    /**

     * @dev Constructor function

     */

    constructor (string memory name, string memory symbol) public {

        _name = name;

        _symbol = symbol;



        // register the supported interfaces to conform to ERC721 via ERC165

        _registerInterface(_INTERFACE_ID_ERC721_METADATA);

    }



    /**

     * @dev Gets the token name.

     * @return string representing the token name

     */

    function name() external view returns (string memory) {

        return _name;

    }



    /**

     * @dev Gets the token symbol.

     * @return string representing the token symbol

     */

    function symbol() external view returns (string memory) {

        return _symbol;

    }



    /**

     * @dev Returns the URI for a given token ID. May return an empty string.

     *

     * If the token's URI is non-empty and a base URI was set (via

     * {_setBaseURI}), it will be added to the token ID's URI as a prefix.

     *

     * Reverts if the token ID does not exist.

     */

    function tokenURI(uint256 tokenId) external view returns (string memory) {

        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");



        string memory _tokenURI = _tokenURIs[tokenId];



        // Even if there is a base URI, it is only appended to non-empty token-specific URIs

        if (bytes(_tokenURI).length == 0) {

            return "";

        } else {

            // abi.encodePacked is being used to concatenate strings

            return string(abi.encodePacked(_baseURI, _tokenURI));

        }

    }



    /**

     * @dev Internal function to set the token URI for a given token.

     *

     * Reverts if the token ID does not exist.

     *

     * TIP: if all token IDs share a prefix (e.g. if your URIs look like

     * `http://api.myproject.com/token/<id>`), use {_setBaseURI} to store

     * it and save gas.

     */

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal {

        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");

        _tokenURIs[tokenId] = _tokenURI;

    }



    /**

     * @dev Internal function to set the base URI for all token IDs. It is

     * automatically added as a prefix to the value returned in {tokenURI}.

     *

     * _Available since v2.5.0._

     */

    function _setBaseURI(string memory baseURI) internal {

        _baseURI = baseURI;

    }



    /**

    * @dev Returns the base URI set via {_setBaseURI}. This will be

    * automatically added as a preffix in {tokenURI} to each token's URI, when

    * they are non-empty.

    *

    * _Available since v2.5.0._

    */

    function baseURI() external view returns (string memory) {

        return _baseURI;

    }



    /**

     * @dev Internal function to burn a specific token.

     * Reverts if the token does not exist.

     * Deprecated, use _burn(uint256) instead.

     * @param owner owner of the token to burn

     * @param tokenId uint256 ID of the token being burned by the msg.sender

     */

    function _burn(address owner, uint256 tokenId) internal {

        super._burn(owner, tokenId);



        // Clear metadata (if any)

        if (bytes(_tokenURIs[tokenId]).length != 0) {

            delete _tokenURIs[tokenId];

        }

    }

}



// File: @openzeppelin/contracts/token/ERC721/ERC721Full.sol



pragma solidity ^0.5.0;









/**

 * @title Full ERC721 Token

 * @dev This implementation includes all the required and some optional functionality of the ERC721 standard

 * Moreover, it includes approve all functionality using operator terminology.

 *

 * See https://eips.ethereum.org/EIPS/eip-721

 */

contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {

    constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {

        // solhint-disable-previous-line no-empty-blocks

    }

}



// File: akap-utils/contracts/domain/DomainManager.sol



// Copyright (C) 2020  Christian Felde



// Licensed under the Apache License, Version 2.0 (the "License");

// you may not use this file except in compliance with the License.

// You may obtain a copy of the License at



// http://www.apache.org/licenses/LICENSE-2.0



// Unless required by applicable law or agreed to in writing, software

// distributed under the License is distributed on an "AS IS" BASIS,

// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

// See the License for the specific language governing permissions and

// limitations under the License.



pragma solidity ^0.5.0;









contract DomainManager is IDomainManager {

    IAKAP private __akap;

    IERC721 private __erc721;



    uint private __domainParent;

    bytes private __domainLabel;



    uint private __domain;



    constructor(address _akapAddress, uint _domainParent, bytes memory _domainLabel) public {

        __akap = IAKAP(_akapAddress);

        __erc721 = IERC721(_akapAddress);



        __domainParent = _domainParent;

        __domainLabel = _domainLabel;



        require(__akap.claim(__domainParent, __domainLabel) > 0, "DomainManager: Unable to claim");



        __domain = __akap.hashOf(__domainParent, __domainLabel);



        __akap.setSeeAddress(__domain, address(this));



        // DomainManager creator gets full access by default

        __erc721.setApprovalForAll(msg.sender, true);

    }



    modifier onlyApproved() {

        require(__erc721.isApprovedForAll(address(this), msg.sender), "DomainManager: Not approved for all");



        _;

    }



    function akap() public view returns (IAKAP) {

        return __akap;

    }



    function erc721() public view returns (IERC721) {

        return __erc721;

    }



    function domainParent() public view returns (uint) {

        return __domainParent;

    }



    function domainLabel() public view returns (bytes memory) {

        return __domainLabel;

    }



    function domain() public view returns (uint) {

        return __domain;

    }



    function setApprovalForAll(address to, bool approved) public onlyApproved() {

        require(to != msg.sender, "DomainManager: Approve to caller");



        __erc721.setApprovalForAll(to, approved);

    }



    function claim(bytes memory label) public returns (uint status) {

        return claim(__domain, label);

    }



    function claim(uint parentId, bytes memory label) public onlyApproved() returns (uint) {

        uint status = __akap.claim(parentId, label);



        require(status > 0, "DomainManager: Unable to claim");



        return status;

    }



    function reclaim() public returns (uint) {

        uint status = __akap.claim(__domainParent, __domainLabel);



        require(status > 0, "DomainManager: Unable to reclaim");



        return status;

    }

}



// File: contracts/MillionDaiToken.sol



// Copyright (C) 2020  Christian Felde



// Licensed under the Apache License, Version 2.0 (the "License");

// you may not use this file except in compliance with the License.

// You may obtain a copy of the License at



// http://www.apache.org/licenses/LICENSE-2.0



// Unless required by applicable law or agreed to in writing, software

// distributed under the License is distributed on an "AS IS" BASIS,

// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

// See the License for the specific language governing permissions and

// limitations under the License.



pragma solidity ^0.5.0;











contract MillionDaiToken is ERC721Full {

    using StringLib for string;



    DomainManager public dm;

    IAKAP public akap;

    uint public rootPtr;



    constructor(address _dmAddress, uint _rootPtr) ERC721Full("Million DAI website", "MillionDAI") public {

        dm = DomainManager(_dmAddress);

        akap = dm.akap();

        rootPtr = _rootPtr;

    }



    function ptr(string memory k) internal view returns (uint) {

        return akap.hashOf(rootPtr, k.asBytes());

    }



    function tokenAccessPtr() public view returns (uint) {

        return ptr("token-access");

    }



    function tokenAccess() public view returns (address) {

        return akap.seeAddress(tokenAccessPtr());

    }



    function exists(uint tile) external view returns (bool) {

        return _exists(tile);

    }



    modifier withTokenAccess() {

        require(msg.sender == tokenAccess(), "No token access");

        _;

    }



    function mint(address owner, uint tile) external withTokenAccess() returns (bool) {

        _mint(owner, tile);

        return true;

    }



    function burn(address owner, uint tile) external withTokenAccess() returns (bool) {

        _burn(owner, tile);

        return true;

    }



    function ownerChange(address from, address to, uint tile) external withTokenAccess() returns (bool) {

        _safeTransferFrom(from, to, tile, "");

        return true;

    }



    function setTokenURI(uint tile, string calldata uri) external withTokenAccess() {

        _setTokenURI(tile, uri);

    }

}



// File: contracts/MillionDai.sol



// Copyright (C) 2020  Christian Felde



// Licensed under the Apache License, Version 2.0 (the "License");

// you may not use this file except in compliance with the License.

// You may obtain a copy of the License at



// http://www.apache.org/licenses/LICENSE-2.0



// Unless required by applicable law or agreed to in writing, software

// distributed under the License is distributed on an "AS IS" BASIS,

// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

// See the License for the specific language governing permissions and

// limitations under the License.



pragma solidity ^0.5.0;























contract MillionDai {

    using StringLib for string;

    using AddressLib for address;

    using Uint256Lib for uint;

    using BytesLib for bytes;



    IDomainManager public dm;

    IAKAP public akap;

    uint public rootPtr;



    bool private lock;



    enum TileAction {ENTER, EXIT}

    event Tile(uint indexed tile, address indexed actor, TileAction indexed action, uint amount);

    event Value(uint indexed tile, address indexed actor, bytes value);

    event URI(uint indexed tile, address indexed actor, string uri);

    event Vote(uint indexed tile, address indexed actor);



    constructor() public {}



    function ptr(string memory k) internal view returns (uint) {

        return akap.hashOf(rootPtr, k.asBytes());

    }



    function erc721Ptr() public view returns (uint) {

        return ptr("erc-721");

    }



    function daiPtr() public view returns (uint) {

        return ptr("dai");

    }



    function rdaiPtr() public view returns (uint) {

        return ptr("rdai");

    }



    function dataMapPtr() public view returns (uint) {

        return ptr("data-map");

    }



    function daiMapPtr() public view returns (uint) {

        return ptr("dai-map");

    }



    function tileBlockMapPtr() public view returns (uint) {

        return ptr("tile-block-map");

    }



    function voteTileMapPtr() public view returns (uint) {

        return ptr("vote-tile-map");

    }



    function voteBlockMapPtr() public view returns (uint) {

        return ptr("vote-block-map");

    }



    function adminRootPtr() public view returns (uint) {

        return ptr("admin");

    }



    function adminPtr() public view returns (uint) {

        address a = msg.sender;

        return akap.hashOf(adminRootPtr(), a.asBytes());

    }



    function erc721() public view returns (MillionDaiToken) {

        return MillionDaiToken(akap.seeAddress(erc721Ptr()));

    }



    function dai() public view returns (IERC20) {

        return IERC20(akap.seeAddress(daiPtr()));

    }



    function rdai() public view returns (RTokenLike) {

        return RTokenLike(akap.seeAddress(rdaiPtr()));

    }



    function dataMap() public view returns (ISimpleMap) {

        return ISimpleMap(akap.seeAddress(dataMapPtr()));

    }



    function daiMap() public view returns (ISimpleMap) {

        return ISimpleMap(akap.seeAddress(daiMapPtr()));

    }



    function tileBlockMap() public view returns (ISimpleMap) {

        return ISimpleMap(akap.seeAddress(tileBlockMapPtr()));

    }



    function voteBlockMap() public view returns (ISimpleMap) {

        return ISimpleMap(akap.seeAddress(voteBlockMapPtr()));

    }



    function voteTileMap() public view returns (ISimpleMap) {

        return ISimpleMap(akap.seeAddress(voteTileMapPtr()));

    }



    function tilePrice(uint tile) public view returns (uint) {

        bytes memory value = daiMap().get(tile.asBytes());



        return value.asUint256();

    }



    function get(uint tile) external view returns (bytes memory value, string memory uri, uint price, uint minNewPrice, address owner, uint blockNumber) {

        value = dataMap().get(tile.asBytes());



        MillionDaiToken token = erc721();



        if (token.exists(tile)) {

            uri = token.tokenURI(tile);

            owner = erc721().ownerOf(tile);

        } else {

            uri = "";

            owner = address(0);

        }



        price = tilePrice(tile);



        uint minPrice = 100000000000000000000; // 100 DAI

        uint minIncrement = 1000000000000000000; // 1 DAI

        uint minAmount = price + minIncrement;



        if (minPrice > minAmount) {

            minNewPrice = minPrice;

        } else {

            minNewPrice = minAmount;

        }



        blockNumber = tileBlockMap().get(tile.asBytes()).asUint256();

    }



    modifier withValidTile(uint tile) {

        uint lower = uint(-1) / 2;

        uint higher = lower + 10000;

        require(tile >= lower && tile < higher, "Invalid tile");

        _;

    }



    function set(uint tile, bytes calldata value, string calldata uri) external withValidTile(tile) {

        require(value.length == 38, "Wrong value size");

        MillionDaiToken token = erc721();

        require(msg.sender == token.ownerOf(tile), "Not owner");

        token.setTokenURI(tile, uri);

        dataMap().put(tile.asBytes(), value);

        emit Value(tile, msg.sender, value);

        emit URI(tile, msg.sender, uri);

    }



    function setTileValue(uint tile, bytes calldata value) external withValidTile(tile) {

        require(value.length == 38, "Wrong value size");

        MillionDaiToken token = erc721();

        require(msg.sender == token.ownerOf(tile), "Not owner");

        dataMap().put(tile.asBytes(), value);

        emit Value(tile, msg.sender, value);

    }



    function setTileURI(uint tile, string calldata uri) external withValidTile(tile) {

        MillionDaiToken token = erc721();

        require(msg.sender == token.ownerOf(tile), "Not owner");

        token.setTokenURI(tile, uri);

        emit URI(tile, msg.sender, uri);

    }



    function enter(uint tile, uint amount) external withValidTile(tile) {

        require(!lock, "Lock failure");

        lock = true;



        uint minPrice = 100000000000000000000; // 100 DAI

        uint minIncrement = 1000000000000000000; // 1 DAI

        uint existingAmount = tilePrice(tile);

        uint minAmount = existingAmount + minIncrement;



        MillionDaiToken token = erc721();

        RTokenLike rtoken = rdai();



        require(amount >= minPrice && minAmount > existingAmount, "Insufficient price");



        bool tokenExists = token.exists(tile);



        if (tokenExists) {

            require(rtoken.redeemAndTransfer(token.ownerOf(tile), existingAmount), "RDai redeem failure");

        }



        if (tokenExists && token.ownerOf(tile) != msg.sender) {

            require(amount >= minAmount, "Insufficient increase in price");

            require(token.ownerChange(token.ownerOf(tile), msg.sender, tile), "Owner change failure");

        } else if (!tokenExists) {

            require(token.mint(msg.sender, tile), "Token mint failure");

        }



        require(dai().transferFrom(msg.sender, address(this), amount), "Transfer failure");

        require(rtoken.mint(amount), "RDai mint failure");



        tileBlockMap().put(tile.asBytes(), block.number.asBytes());

        daiMap().put(tile.asBytes(), amount.asBytes());



        emit Tile(tile, msg.sender, TileAction.ENTER, amount);



        require(lock, "Lock failure");

        lock = false;

    }



    function exit(uint tile) external withValidTile(tile) {

        require(!lock, "Lock failure");

        lock = true;



        bytes memory value = tileBlockMap().get(tile.asBytes());

        uint blockEnter = value.asUint256();



        require(block.number > blockEnter, "Mint too fresh");



        require(erc721().burn(msg.sender, tile), "Token burn failure");



        uint existingAmount = tilePrice(tile);

        daiMap().put(tile.asBytes(), "");



        require(rdai().redeemAndTransfer(msg.sender, existingAmount), "RDai redeem failure");



        emit Tile(tile, msg.sender, TileAction.EXIT, existingAmount);



        require(lock, "Lock failure");

        lock = false;

    }



    function vote(uint tile) external withValidTile(tile) {

        bytes memory value = dataMap().get(tile.asBytes());

        require(value.length > 0, "No tile");



        address a = msg.sender;

        voteTileMap().put(a.asBytes(), tile.asBytes());

        voteBlockMap().put(a.asBytes(), block.number.asBytes());



        emit Vote(tile, a);

    }



    function getVote(address actor) external view returns (uint tile, uint blockNumber) {

        tile = voteTileMap().get(actor.asBytes()).asUint256();

        blockNumber = voteBlockMap().get(actor.asBytes()).asUint256();

    }



    modifier onlyAdmin() {

        require(akap.seeAddress(adminPtr()) == msg.sender, "Not admin");

        _;

    }



    function withHat(address[] calldata recipients, uint32[] calldata proportions) external onlyAdmin() {

        RTokenLike rd = rdai();

        dai().approve(address(rd), uint(-1));

        rd.createHat(recipients, proportions, true);

    }

}
