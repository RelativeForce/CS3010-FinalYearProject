"use strict";

exports.send = function(requestData){

    var isNode = new Function("try {return this===global;}catch(e){return false;}");

    if(isNode()){
        return false;  
    }

    var token = document.getElementsByName("__RequestVerificationToken")[0].value;
    
    var request = new XMLHttpRequest();
    request.open(requestData.method, requestData.url, false); 
    request.setRequestHeader("Content-Type", "application/json");
    request.setRequestHeader("RequestVerificationToken", token);
    request.send(requestData.json);

    if (request.status !== 200) {
        console.log("Request Failed");
    }

    if(request.responseText === undefined)
        return true;

    return JSON.parse(request.responseText);
};