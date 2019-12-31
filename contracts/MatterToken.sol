pragma solidity >=0.4.23;

// ----------------------------------------------------------------------------
// Entity:          Dragon Den 
// Token Name:      MatterToken 
// Deployed To:     0xe2bfA9a1882644d34360CE6267ee285040Fa3b41
// symbol:          MTR
// MaxSupply:       2971215073
// Mintable Chunk:  1000
// Authored By:     Baxter Finch
// Description:     Custom minting function with
//                  time based and ETH address verification
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Safe maths
// 
// ----------------------------------------------------------------------------
contract SafeMath {
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function safeDiv(uint a, uint b) public pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}


// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
// ----------------------------------------------------------------------------
contract ERC20Interface {
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}


// ----------------------------------------------------------------------------
// Contract function to receive approval and execute function in one call
//
// Borrowed from MiniMeToken
// ----------------------------------------------------------------------------
contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
}


// ----------------------------------------------------------------------------
// Owned contract
// ----------------------------------------------------------------------------
contract Owned {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}


// ----------------------------------------------------------------------------
// ERC20 Token, with the addition of symbol, name and decimals and assisted
// token transfers
// ----------------------------------------------------------------------------
contract MatterToken is ERC20Interface, Owned, SafeMath {
    string public symbol;
    string public  name;
    uint8 public decimals;
    uint public _totalSupply;
    uint private _MaxSupply;
    uint private _lastMintedBlockTimestamp;
    uint private _mintMTRChunk;
    uint private _minimumTimePassedToMint;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;


    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor() public {
        symbol = "MatterToken";
        name = "MatterToken";
        decimals = 18;
        _totalSupply = 1000000000000000000000;
        _mintMTRChunk = 1000000000000000000000;
        _lastMintedBlockTimestamp = block.timestamp;
        _minimumTimePassedToMint = 250; // Seconds
        _MaxSupply = 2971215073000000000000000000;
        balances[0xe2bfA9a1882644d34360CE6267ee285040Fa3b41] = _totalSupply;
        emit Transfer(address(0), 0xe2bfA9a1882644d34360CE6267ee285040Fa3b41, _totalSupply);
    }


    // ------------------------------------------------------------------------
    // Total supply
    // ------------------------------------------------------------------------
    function totalSupply() public view returns (uint) {
        return _totalSupply  - balances[address(0)];
    }


    // ------------------------------------------------------------------------
    // Get the token balance for account tokenOwner
    // ------------------------------------------------------------------------
    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }


    // ------------------------------------------------------------------------
    // Transfer the balance from token owner's account to to account
    // - Owner's account must have sufficient balance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Token owner can approve for spender to transferFrom(...) tokens
    // from the token owner's account
    //
    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
    // recommends that there are no checks for the approval double-spend attack
    // as this should be implemented in user interfaces
    // ------------------------------------------------------------------------
    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Transfer tokens from the from account to the to account
    //
    // The calling account must already have sufficient tokens approve(...)-d
    // for spending from the from account and
    // - From account must have sufficient balance to transfer
    // - Spender must have sufficient allowance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Returns the amount of tokens approved by the owner that can be
    // transferred to the spender's account
    // ------------------------------------------------------------------------
    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }


    // ------------------------------------------------------------------------
    // Token owner can approve for spender to transferFrom(...) tokens
    // from the token owner's account. The spender contract function
    // receiveApproval(...) is then executed
    // ------------------------------------------------------------------------
    function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
        return true;
    }

    // ------------------------------------------------------------------------
    // @notice Will mint 1000 MTR 
    // @notice only if the _totalSupply + _mintMTRChunk doesnt exceed the _MaxSupply
    // @param _to The address that will receive the coin.
    // ------------------------------------------------------------------------

    function mint(address _to) private {
        if (_totalSupply + _mintMTRChunk < _MaxSupply) {
            require(msg.sender == owner); // assuming you have a contract owner
            balances[_to] += _mintMTRChunk;
            _totalSupply += _mintMTRChunk;
            require(balances[_to] >= _mintMTRChunk && _totalSupply >= _mintMTRChunk); // overflow checks
            emit Transfer(address(0), _to, _mintMTRChunk);
        } else {
            uint _finalMint = _MaxSupply - _totalSupply;
            require(msg.sender == owner); // assuming you have a contract owner
            balances[_to] += _finalMint;
            _totalSupply += _finalMint;
            require(balances[_to] >= _finalMint && _totalSupply >= _finalMint); // overflow checks
            emit Transfer(address(0), _to, _finalMint);
        }
    }


    // Time-based function that only allows you to mint if a certain amount of time has passed
    function mintVerifier(address _to) public {
        uint thisTimestamp = block.timestamp;

        if (thisTimestamp - _lastMintedBlockTimestamp > _minimumTimePassedToMint) {
            _lastMintedBlockTimestamp = block.timestamp;
            mint(_to);
        } else {
            return;
        }
    }


    // ------------------------------------------------------------------------
    // Don't accept ETH
    // ------------------------------------------------------------------------
    function () external payable {
        revert();
    }


    
  // ------------------------------------------------------------------------
	// Owner can transfer out any accidentally sent ERC20 tokens
	// ------------------------------------------------------------------------
	function transferAnyERC20Token(address tokenAddress, address toAddress, uint tokens) public onlyOwner returns (bool success) {
		return ERC20Interface(tokenAddress).transfer(toAddress, tokens);
	}
}
