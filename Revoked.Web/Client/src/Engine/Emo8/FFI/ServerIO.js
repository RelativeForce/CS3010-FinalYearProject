"use strict";

exports.send = function(requestData, responseReader){

    var request = new XMLHttpRequest();
    request.open(requestData.method, requestData.url, false); 
    request.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    request.send(requestData.data);

    if (request.status !== 200) {
        console.log("Request Failed");
    }

    return responseReader(request.responseText);
};