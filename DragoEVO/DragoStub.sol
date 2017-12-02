//! The drago-library contract.
//!
//! Copyright 2017 Gabriele Rigo, RigoBlock, Rigo Investment Sagl.
//!
//! Licensed under the Apache License, Version 2.0 (the "License");
//! you may not use this file except in compliance with the License.
//! You may obtain a copy of the License at
//!
//!     http://www.apache.org/licenses/LICENSE-2.0
//!
//! Unless required by applicable law or agreed to in writing, software
//! distributed under the License is distributed on an "AS IS" BASIS,
//! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//! See the License for the specific language governing permissions and
//! limitations under the License.
//!
//! This code may be distributed under the terms of the Apache Licence
//! version 2.0 (see above) or the MIT-license, at your choice.

pragma solidity ^0.4.19;

contract Authority {

    // METHODS
    
    function getDragoLibrary() public constant returns (address) {}   
}

contract Drago {
    function Drago(string _dragoName,  string _dragoSymbol, uint _dragoID, address _owner, address _authority) internal {
        AUTHORITY = _authority;
        // Signature of the Drago Library's init function
        // bytes4 sig = bytes4(sha3("Drago(string,string,uint,address,address)"));
        bytes4 sig = 0x86cc4621;

        // Compute the size of the call data : arrays has 2
        // 32bytes for offset and length, plus 32bytes per element ;
        // plus 2 32bytes for each uint
        uint argarraysize = (5);
        uint argsize = (2 + argarraysize) * 32;

        // total data size:
        //   4 bytes for the signature + the arguments size
        uint size = 4 + argsize;
        bytes32 m_data = _malloc(size);

        // copy the signature and arguments data to the
        // data pointer
        assembly {
            // Add the signature first to memory
            mstore(m_data, sig)
            // Add the call data, which is at the end of the code
            codecopy(add(m_data, 0x4), sub(codesize, argsize), argsize)
        }

        // execute the call (to initWallet)
        _call(m_data, size);
    }

    // delegate any contract calls to
    // the library
    function() payable {
        uint size = msg.data.length;
        bytes32 m_data = _malloc(size);

        assembly {
            calldatacopy(m_data, 0x0, size)
        }

        bytes32 m_result = _call(m_data, size);

        assembly {
            return(m_result, 0x20)
        }
    }

    // allocate the given size in memory and return
    // the pointer
    function _malloc(uint size) private returns(bytes32) {
        bytes32 m_data;

        assembly {
            // Get free memory pointer and update it
            m_data := mload(0x40)
            mstore(0x40, add(m_data, size))
        }

        return m_data;
    }

    // make a delegatecall to the target contract, given the
    // data located at m_data, that has the given size
    //
    // @returns A pointer to memory which contain the 32 first bytes
    //          of the delegatecall output
    function _call(bytes32 m_data, uint size) private returns(bytes32) {
        Authority auth = Authority(AUTHORITY);
        address target = auth.getDragoLibrary();
        bytes32 m_result = _malloc(32);
        bool failed;

        assembly {
            failed := iszero(delegatecall(sub(gas, 10000), target, m_data, size, m_result, 0x20))
        }

        require(!failed);
        return m_result;
    }
    
    address public AUTHORITY;
}
