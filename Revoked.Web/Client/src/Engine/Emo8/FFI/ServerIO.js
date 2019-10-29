"use strict";

exports.send = function(requestData){

    var request = new XMLHttpRequest();
    request.open(requestData.method, requestData.url, false); 
    request.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    request.send(requestData.json);

    if (request.status !== 200) {
        console.log("Request Failed");
    }

    if(request.responseText === "")
        return true;

    return JSON.parse(request.responseText);
};