"use strict";

exports.send = function(requestData){

    var XMLHttpRequest = require("xmlhttprequest").XMLHttpRequest;
    var request = new XMLHttpRequest();
    request.open(requestData.method, requestData.url, false); 
    request.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    request.send(requestData.json);

    if (request.status !== 200) {
        console.log("Request Failed");
    }

    if(request.responseText === undefined)
        return true;

    return JSON.parse(request.responseText);
};