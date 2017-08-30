/*

  Copyright 2017 RigoBlock, Rigo Investment Sagl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity 0.4.16;

contract Inflation {

    function Inflation(address _rigoTok, uint _inflationFactor) external only_rigoblock {
        RigoTok rigoToken = RigoTok(_rigoTok);
        rigoTok.inflationFactor = _inflationFactor;
    }

    modifier is_max_inflation {
        RigoTok rigoToken = RigoTok(_rigoTok);
        assert(inflationTokens <= rigoTok.totalSupply * ( rigoTok.inflationFactor / 100 );
        _;
    }
    
    modifier proof_of_performance {
        require(msg.sender == k;
    }

    function mintInflation(address recipient, uint amount) external proof_of_performance is_max_inflation {
        RigoTok rigoToken = RigoTok(_rigoTok);
        rigoToken.mintToken(recipient, amount);
        balances[recipient] = safeAdd(balances[recipient], amount);
        inflationTokens = safeAdd(inflationTokens, amount);
    }

    function setInflationFactor(uint _inflationFactor, address _rigoTok) only_rigoblock {
	      RigoTok rigoToken = RigoTok(_rigoTok);
        rigoToken.inflationFactor(_inflationFactor);
    }
    
    uint public inflationTokens;
    uint startTime; //in order to reset at each subperiod
    uint endTime; //maybe each quarter, or even on a daily basis

}
