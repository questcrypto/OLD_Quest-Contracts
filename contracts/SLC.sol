// SPDX-License-Identifier: MIT

pragma solidity >=0.6.2;

interface SLFcontract{
     function mint(address,uint256) external;
}

contract SLC{
     using SafeMaths for uint256;
    
    address private SLf_contract_address;      
    string  public name = "SLC";
    string  public symbol = "S";
    uint256 public decimals = 0;
    uint256 private current_region_no = 1;
    uint256 public totalSupply;
    mapping(address =>uint256) public balances;
    mapping(address =>mapping(address=>uint256)) public allowance;
    mapping(address => uint8) private _owners;
    mapping(uint => address) region_no_to_admin_address;
    
    uint constant MIN_SIGNATURES = 2;
    uint private _transactionIdx;

    struct Transaction {
      address to;
      uint amount;
      uint tokenid;
      uint8 signatureCount;
      mapping (address => uint8) signatures;
    }

    mapping (uint => Transaction) public _transactions;
    uint[] private _pendingTransactions;
    uint private count_pending_transactions;

    
event Transfer(
    address indexed _from,
    address indexed _to,
    uint256 _value
    );

event Approval(
    address indexed _owner,
    address indexed _spender,
    uint256 _value
    );

    address public owner;

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    
    modifier isAdmin(address _address){
        require(_owners[_address]==1);
        _;
    }
    
      modifier validOwner() {
        require(msg.sender == owner || _owners[msg.sender] == 1);
        _;
    }
    
    event ownerAdded(
        address owner
    );

    event ownerRemoved(
        address owner
    );
     event DepositFunds(address from, uint amount);
    event TransactionCreated(address to, uint amount, uint transactionId);
    event TransactionCompleted(address to, uint amount, uint transactionId);
    event TransactionSigned(address by, uint transactionId);

    constructor(uint256 _initialSupply) 
    public {
        owner = msg.sender;
        balances[msg.sender] = _initialSupply;
        totalSupply=_initialSupply;
        emit Transfer(address(0),msg.sender,_initialSupply);
    }
    
    function setSLF_contract_address(address _address) public onlyOwner{
        SLf_contract_address = _address;
    }
    
    function add_region_admin(address _address)
    public
    onlyOwner{
        region_no_to_admin_address[current_region_no++] = _address;
    }
     
     function change_region_admin(uint256 _region_no ,address _address)
    public
    {
        require(msg.sender == owner || region_no_to_admin_address[_region_no] == msg.sender);
        region_no_to_admin_address[_region_no] = _address;
    }
    
    function modify(address _oldAddress ,address _newAddress)
    public
    onlyOwner
    isAdmin(_oldAddress){
        removeOwner(_oldAddress);
        addOwner(_newAddress);
     }
    
    function transferFrom(address from ,address _to, uint256 _value) private  returns (bool success) {
        require(_value>0);
         require(balances[from]>=_value);
        
        balances[from] = balances[from].sub(_value);     
        balances[_to] =balances[_to].add(_value);
        emit Transfer(from, _to, _value);
        return true;
    }
    //   function safetransferFrom(address _from, address _to, uint256 _value) public payable returns (bool success) {
    // require (_value>0);
    //  require(_value <= allowance[_from][msg.sender]); 
    //  balances[_from]= balances[_from].sub(_value);
    //         balances[_to] = balances[_to].add(_value);
    //  allowance[_from][msg.sender]=allowance[_from][msg.sender].sub(_value);
    //   emit Transfer(_from, _to, _value);
    //         return true;
    // }
    
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] += _value;                               
        emit Approval(msg.sender,_spender, _value);
        return true;
    }
    function balanceOf(address request) public view returns (uint256){
        return balances[request];
    }

    
    
       function addOwner(address _owner)
        onlyOwner
        public {         
        //require(_owners[owner]==0);        // we may check that owner is already the Owner...
        _owners[_owner] = 1;
        emit ownerAdded(owner);
    }

    function removeOwner(address _owner)
        onlyOwner
        public {
        _owners[_owner] = 0;
        emit ownerRemoved(_owner);
    }

    receive()
        external
        payable {
        emit DepositFunds(msg.sender, msg.value);
    }

    function withdraw(uint tokenid,uint property_region,uint amount)
        public returns(uint256){
        require(msg.sender == SLf_contract_address);
        return transferTo(tokenid,region_no_to_admin_address[property_region], amount);
    }

    function transferTo(uint tokenid,address to, uint amount)
        internal returns(uint256) {
        //require(balances[msg.sender] >= amount);
        uint transactionId = ++_transactionIdx;

        Transaction memory transaction;
        transaction.to = to;
        transaction.amount = amount;
        transaction.tokenid = tokenid;
        transaction.signatureCount = 0;

        _transactions[transactionId] = transaction;
        _pendingTransactions.push(transactionId);
        count_pending_transactions++;
        emit TransactionCreated(to, amount, transactionId);
        return transactionId;
    }
    
    function mint(address account, uint256 amount) private  {
        
        totalSupply = totalSupply.add(amount);
        balances[account] = balances[account].add(amount);
        emit Transfer(address(0), account, amount);
        
    }

    function getPendingTransactions()
      view
      validOwner
      public
      returns (uint[] memory) {
      uint[] memory temp = new uint[](count_pending_transactions);
      uint j;
      for(uint i = 0; i < _pendingTransactions.length; i++) {
              if (_pendingTransactions[i] != 0) {
                temp[j++] = _pendingTransactions[i];
              }
      }
          
      return temp;
    }

    function signTransaction(uint transactionId)
      validOwner
      public payable{

      Transaction storage transaction = _transactions[transactionId];

      // Transaction must exist
      //require(address(0) != transaction.from);
      // Creator cannot sign the transaction
      //require(msg.sender != transaction.from);
      // Cannot sign a transaction more than once
      require(transaction.signatures[msg.sender] != 1);

      transaction.signatures[msg.sender] = 1;
      transaction.signatureCount++;

      emit TransactionSigned(msg.sender, transactionId);

      if (transaction.signatureCount >= MIN_SIGNATURES) {
        //require(balances[transaction.from] >= transaction.amount);   
        // transaction.to.transfer(transaction.amount);
        mint(transaction.to,transaction.amount);
        SLFcontract(SLf_contract_address).mint(transaction.to,transaction.tokenid);
        emit TransactionCompleted(transaction.to, transaction.amount, transactionId);
        deleteTransaction(transactionId);
      }
    }

    function deleteTransaction(uint transactionId)
      validOwner
      public {
      
      for(uint i = 0; i < _pendingTransactions.length; i++) {
         if (transactionId == _pendingTransactions[i]) {
          _pendingTransactions[i] = 0;
          break;
        }
      }
      count_pending_transactions--;
      delete _transactions[transactionId];
    }

    function walletBalance()
      view
      public
      returns (uint) {
      return address(this).balance;
    }
    
}

library SafeMaths {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
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
     *
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
     *
     * - Subtraction cannot overflow.
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
     *
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
     *
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
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
     *
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
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}