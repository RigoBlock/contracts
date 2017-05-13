contract GabcoinFace {

	event Buy(address indexed from, address indexed to, uint256 indexed amount, uint256 revenue);
	event Sell(address indexed from, address indexed to, uint256 indexed amount,uint256 revenue);
	event DepositCasper(uint amount, address indexed who, address indexed validation, address indexed withdrawal);
 	event WithdrawCasper(uint deposit, address indexed who, address casper);
 
	function() payable {}
	function deposit(address _token, uint _amount) payable returns (bool success) {}
	function withdraw(address _token, uint _amount) returns (bool success) {}
	function buyGabcoin() payable returns (bool success) {}
	function sellGabcoin(uint256 amount) returns (bool success) {}
	function depositCasper(address _validation, address _withdrawal, uint _amount) returns (bool success) {}
  function withdrawCasper(uint _validatorIndex) {}
	function changeRatio(uint256 _ratio) {}	
	function setTransactionFee(uint _transactionFee) {}	
	function changeFeeCollector(address _feeCollector) {}	
	function changeGabcoinDAO(address _gabcoinDAO) {}

	function balanceOf(address _from) constant returns (uint) {}
	function getVersion() constant returns (string) {}
	function getName() constant returns (string) {}
	function getSymbol() constant returns (string) {}
	function getPrice() constant returns (uint256) {}
	function getCasper() constant returns (address) {}
	function getTransactionFee() constant returns (uint) {}
	function getFeeCollector() constant returns (address) {}
}
