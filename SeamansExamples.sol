pragma solidity ^0.4.24;

import "./seaman/usingCaptainJS.sol";

contract SeamansExamples is usingCaptainJS, IsOwnableAndDestructable {

    uint constant CENTIMETER_JOB = 1;
    uint constant WOLFRAMALPHA_JOB = 2;
    uint constant SHIPS_BELL_RING = 3;

    constructor () public {
        ChangeVoucherCode("Seaman 'Luke'");
    }

    function CallbackExample() public {
        // simply call this contract in 1 minute back
        RingShipsBell(SHIPS_BELL_RING, 2, DEFAULT_GAS_UNITS, DEFAULT_GAS_PRICE);
        emit ResultLog("RingShipsBell successfully submitted ;-)");
    }


    function WolframAlphaExample(string Country) public returns (uint JobId) {
        bool Success = Run(
            /* give the job a unique ID */
            WOLFRAMALPHA_JOB,
            /* JavaScript code I want to execute: */
            concat (
                "module.exports = async function(CaptainJSIn) { ",
                "   const axios = require('axios'); ",
                "   const WAlpha = await axios.get('http://www.wolframalpha.com/queryrecognizer/query.jsp?appid=DEMO&mode=Default&i=' + CaptainJSIn + '&output=json'); ",          
                "   return JSON.stringify(WAlpha.data); ",
                "}"
            ),
            /* Input parameter */
            Country,
            /* Nodejs libraries we need */
            "axios", 
            /* we need a maximum of 2 runtime slices */
            1, 
            /* the returned string will have default maximum size */
            MAX_OUTPUT_LENGTH, 
            /* we will transfer the default amount of gas units for return */
            DEFAULT_GAS_UNITS, 
            /* we will transfer the default gas price for return */
            DEFAULT_GAS_PRICE
        );    
        
        if(Success) 
            emit ResultLog("WolframAlphaExample successfully submitted ;-)");
        else
            emit ResultLog("WolframAlphaExample was not submitted :-(");
    }

    function CentimeterToInchExample(string Centimeter) public returns (uint JobId) {
        bool Success = Run(
            /* give the job a unique ID */
            CENTIMETER_JOB,
            /* JavaScript code I want to execute: */
            "module.exports = function(CaptainJSIn) { var math = require('mathjs'); return math.eval(CaptainJSIn + ' cm to inch'); }", 
            /* Input parameter */
            Centimeter,
            /* Nodejs libraries we need */
            "mathjs", 
            /* we need a maximum of 2 runtime slices */
            2, 
            /* the returned string will have default maximum size */
            MAX_OUTPUT_LENGTH, 
            /* we will transfer the default amount of gas units for return */
            120000, 
            /* we will transfer the default gas price for return */
            DEFAULT_GAS_PRICE
        );    
        
        if(Success) 
            emit ResultLog("CentimeterToInchExample successfully submitted ;-)");
        else
            emit ResultLog("CentimeterToInchExample was not submitted :-(");
    }

    function CaptainsResult(uint UniqueJobIdentifier, string Result) external onlyCaptainsOrdersAllowed {
        // analyse the return results
        if(UniqueJobIdentifier == CENTIMETER_JOB) {
            // OK. It worked and we got a result
            emit ResultLog(concat("CentimeterToInchExample returned the following result: <", Result, ">", "", ""));
            // set the dummy flag, so that the event log gets raised
            DummyFlagToForceEventSubmission = true;
        } else 
        
        if(UniqueJobIdentifier == WOLFRAMALPHA_JOB) {
            // OK. It worked and we got a result
            emit ResultLog(concat("WolframAlphaExample returned the following result: <", Result, ">", "", ""));
            // set the dummy flag, so that the event log gets raised
            DummyFlagToForceEventSubmission = true;
        }
    }
    
    function CaptainsError(uint UniqueJobIdentifier, string Error) external onlyCaptainsOrdersAllowed {
        // analyse the return results
        if(UniqueJobIdentifier == CENTIMETER_JOB) {
            // OK. It didn't work :-/
            emit ResultLog(concat("CentimeterToInchExample did not work. Returned error is: <", Error, ">", "", ""));
            // set the dummy flag, so that the event log gets raised
            DummyFlagToForceEventSubmission = true;
        }
        else 
        
        if(UniqueJobIdentifier == WOLFRAMALPHA_JOB) {
            // OK. It worked and we got a result
            emit ResultLog(concat("WolframAlphaExample did not work. Returned error is: <", Error, ">", "", ""));
            // set the dummy flag, so that the event log gets raised
            DummyFlagToForceEventSubmission = true;
        }
    }

    function RingRing(uint UniqueIdentifier) external onlyCaptainsOrdersAllowed {
        // OK. It worked and we got a result
        emit ResultLog(concat("Ring Ring Seaman! Calling ship's bell worked! JobId = ", uintToString(UniqueIdentifier)));
        // set the dummy flag, so that the event log gets raised
        DummyFlagToForceEventSubmission = true;
    }


    event ResultLog(string Text);

    function () public payable {
        // accept some cash
    }
    
    bool DummyFlagToForceEventSubmission = false;

    // --------------------> helpers
    
    function uintToString(uint v) internal pure returns (string str) {
        uint maxlength = 100;
        bytes memory reversed = new bytes(maxlength);
        uint i = 0;
        while (v != 0) {
            uint remainder = v % 10;
            v = v / 10;
            reversed[i++] = byte(48 + remainder);
        }
        bytes memory s = new bytes(i);
        for (uint j = 0; j < i; j++) {
            s[j] = reversed[i - 1 - j];
        }
        str = string(s);
    }

    function concat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        bytes memory _bc = bytes(_c);
        bytes memory _bd = bytes(_d);
        bytes memory _be = bytes(_e);
        string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
        bytes memory babcde = bytes(abcde);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
        for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
        for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
        for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
        for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
        return string(babcde);
    }

    function concat(string _a, string _b) internal pure returns (string) {
        return concat(_a, _b, "", "", "");
    }


}