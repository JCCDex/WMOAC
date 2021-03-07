pragma solidity =0.5.16;

import "jcc-solidity-utils/contracts/math/SafeMath.sol";
import "jcc-solidity-utils/contracts/utils/AddressUtils.sol";
import "jcc-solidity-utils/contracts/utils/Payload.sol";
import "jcc-solidity-utils/contracts/owner/Administrative.sol";
import "./IWMOAC.sol";

contract WMOAC is IWMOAC, Administrative, Payload {
    using SafeMath for uint256;
    using AddressUtils for address;

    mapping(address => uint256) _balances;

    mapping(address => mapping(address => uint256)) _allowed;

    uint8 private _decimals = 18;
    uint256 private _totalSupply = 0;
    string private _name = "Wrapped MOAC";
    string private _symbol = "WMOAC";

    constructor() public {}

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
  不是所有的ERC20都遵循uint8，比如USDT是uint256，对于不同类型，需要做转换
   */
    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _who) public view returns (uint256) {
        return _balances[_who];
    }

    function allowance(address _owner, address _spender)
        public
        view
        returns (uint256)
    {
        return _allowed[_owner][_spender];
    }

    function approve(address _spender, uint256 _value)
        public
        onlyPayloadSize(2 * 32)
        returns (bool)
    {
        // 检查设置数量和允许数量，防止重入修改
        require(
            (_value == 0) || (_allowed[msg.sender][_spender] == 0),
            "check value not equal zero"
        );

        /**
    不检查value和maxSupply是因为可以授权一个很大的数字，用户可以在业务中反复流转多次
     */
        _allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    function _transfer(
        address from,
        address to,
        uint256 value
    ) internal {
        require(!to.isZeroAddress(), "can not send to zero account");
        require(value <= _totalSupply, "More than total supply");
        require(_balances[from] >= value, "Not enough value");

        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);

        emit Transfer(from, to, value);
    }

    function transfer(address _to, uint256 _value)
        public
        onlyPayloadSize(2 * 32)
        returns (bool)
    {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public onlyPayloadSize(3 * 32) returns (bool) {
        require(_allowed[_from][msg.sender] >= _value, "Not enough value");

        _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
        _transfer(_from, _to, _value);

        return true;
    }

    function increaseAllowance(address _spender, uint256 _addedValue)
        public
        onlyPayloadSize(2 * 32)
        returns (bool)
    {
        require(!_spender.isZeroAddress(), "can not send to zero account");

        _allowed[msg.sender][_spender] = _allowed[msg.sender][_spender].add(
            _addedValue
        );
        emit Approval(msg.sender, _spender, _allowed[msg.sender][_spender]);

        return true;
    }

    function decreaseAllowance(address _spender, uint256 _subtractedValue)
        public
        onlyPayloadSize(2 * 32)
        returns (bool)
    {
        require(!_spender.isZeroAddress(), "can not send to zero account");

        _allowed[msg.sender][_spender] = _allowed[msg.sender][_spender].sub(
            _subtractedValue
        );
        emit Approval(msg.sender, _spender, _allowed[msg.sender][_spender]);

        return true;
    }

    // fallback function
    function() external {
        require(false, "never receive fund.");
    }

    // only owner can kill
    function kill() public {
        if (msg.sender == owner()) selfdestruct(msg.sender);
    }

    function deposit() public payable {
        _balances[msg.sender] = _balances[msg.sender].add(msg.value);
        _totalSupply = _totalSupply.add(msg.value);
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 wad) public {
        require(_balances[msg.sender] >= wad, "no more");
        _balances[msg.sender] = _balances[msg.sender].sub(wad);
        _totalSupply = _totalSupply.sub(wad);
        msg.sender.transfer(wad);
        emit Withdrawal(msg.sender, wad);
    }
}
