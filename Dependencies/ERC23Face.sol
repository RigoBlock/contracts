contract ERC23 {
  
  event Transfer(address indexed from, address indexed to, uint value);
  event Approval(address indexed owner, address indexed spender, uint value);

  function balanceOf(address who) constant returns (uint);
  function allowance(address owner, address spender) constant returns (uint);

  function transfer(address to, uint value) returns (bool ok) {}
  function transfer(address to, uint value, bytes data) returns (bool ok) {}
  function transferFrom(address from, address to, uint value) returns (bool ok) {}
  function approve(address spender, uint value) returns (bool ok) {}
  
  function balanceOf(address who) constant returns (uint) {}
  function allowance(address owner, address spender) constant returns (uint) {}
}
