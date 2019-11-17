"use strict";

exports.sendRequest = function(left){
    return function(right){
        return function(requestData){
            var isNode = new Function("try {return this===global;}catch(e){return false;}");

            if(isNode()){
                return right(false);  
            }

            var localRequest = findInLocalStore(requestData);

            if(localRequest){

                if(localRequest.isWaiting){
                    console.log("Waiting");
                    return left("Waiting");
                }

                console.log("Removed");
                remove(localRequest);

                return right(localRequest.result);
            }

            send(requestData);

            return left("Waiting");
        }
    }
};

function send(requestData){

    var token = document.getElementsByName("__RequestVerificationToken")[0].value;

    $.ajax({
        type: requestData.method,
        url: requestData.url,
        contentType: "application/json",
        dataType: "json",
        data: requestData.json,
        headers: {
            'RequestVerificationToken': token,
        },
        success : function(result, status, xhr) {
        
            var localRequest = findInLocalStore(requestData);

            if (status !== "success") {
                console.log("Request Failed");
                remove(requestData);
                return;
            }

            console.log("Request Success");
            localRequest.isWaiting = false;

            if(result){
                localRequest.result = JSON.parse(result);
            }
            else{
                localRequest.result = true;
            }
        }
    });

    console.log("Sent");
    requestData.isWaiting = true;
    serverLocalStore[serverLocalStore.length] = requestData;
}

function findInLocalStore(requestData){

    for (var index = 0; index < serverLocalStore.length; index++) {
        const element = serverLocalStore[index];
        
        if(requestData.url === element.url){
            return element;
        }
    }

    return null;
}

function remove(requestData){

    var indexToRemove = undefined;

    for (var index = 0; index < serverLocalStore.length; index++) {
        const element = serverLocalStore[index];
        
        if(requestData.url === element.url){
            indexToRemove = index;
        }
    }

    if(indexToRemove){
        serverLocalStore = serverLocalStore.splice(indexToRemove, 1);
    }
}