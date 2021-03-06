pragma solidity =0.5.16;

import "jcc-solidity-utils/contracts/erc/ERC20Factory.sol";
import "./IWMOAC.sol";

contract WMOAC is ERC20Factory, IWMOAC {
    // string public name     = "Wrapped Ether";
    // string public symbol   = "WETH";
    // uint8  public decimals = 18;

    event Deposit(address indexed dst, uint256 wad);
    event Withdrawal(address indexed src, uint256 wad);

    function deposit() public payable {
        _balances[msg.sender] = _balances[msg.sender].add(msg.value);
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 wad) public {
        require(_balances[msg.sender] >= wad, "");
        _balances[msg.sender] = _balances[msg.sender].sub(wad);
        msg.sender.transfer(wad);
        emit Withdrawal(msg.sender, wad);
    }
}
