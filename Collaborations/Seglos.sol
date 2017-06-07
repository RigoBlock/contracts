contract Seglos {

   function Seglos(address _drago, address _oracle) {
      admin = msg.sender;
      drago = _drago;
      exchangeOpen = true;
      tradeMinimum = 100 finney;
      tradeMaximum = 10 ether;
      PriceContract = CoinbasePriceTicker(_oracle);
    }

    function finalize(address _cfd, uint24 _id) {
      exitTrade(uint256(_id));
    }

    function exitTrade(uint _tradeId) {
	require ((msg.sender == trade.user || msg.sender == drago) || marginCall);
    }

    function deposit(address _token, uint _amount) payable dragoOnly returns (bool success) {
	require(_token == address(0));
	depositLiquidity.value(_amount)();
    }
    
    function depositLiquidity() payable dragoOnly {}

    function withdraw(address _token, uint _amount) dragoOnly returns (bool success) {  
	withdrawLiquidity(_amount);
    }

    function withdrawLiquidity(uint _eth) dragoOnly {}

    function door(bool _door) adminOnly {}

    function setFee(uint _fee) adminOnly {}
}
