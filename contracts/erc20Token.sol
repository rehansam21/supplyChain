// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./erc20Interface.sol";

contract ERC20Token is ERC20Interface {

    uint256 constant MAX_UINT256 = 2**256 -1;
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) public allowed;

    uint256 public totSupply;
    string public name;
    uint256 public decimals;
    string public symbol;

    constructor(
        uint256 _initialAmount,
        string memory _tokenName,
        uint256 _decimalunits,
        string memory _tokenSymbol
    ) public {
        balances[msg.sender] = _initialAmount;
        totSupply = _initialAmount;
        name = _tokenName;
        decimals = _decimalunits;
        symbol = _tokenSymbol;

    }

    function transfer(address _to, uint256 _value) public  virtual override returns (bool success) {
        require(balances[msg.sender] >= _value,"Insufficient funds for transfer");
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value); 
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value)  public virtual override returns (bool success){
        uint256 _allowance = allowed[_from][msg.sender];
        require(balances[_from] >= _value && _allowance >= _value, "Insufficient allowed funds for transfer source");
        balances[_to] += _value;
        balances[_from] -= _value;
        if (_allowance < MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }
        emit Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) public view override returns (uint256){
        return balances[_owner];
    }

    function allowance(address _owner, address _spender) public view override returns (uint256){
        return allowed[_owner][_spender];
    }

    function approve(address _spender, uint256 _value) public override returns (bool success){
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function totalSupply() public view override returns (uint256 totSupp) {
        return totSupply;
    }
}