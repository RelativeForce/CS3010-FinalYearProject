"use strict";

exports.sendRequest = function(left){
    return function(right){
        return function(requestData){
            return function() {
                var isNode = new Function("try {return this===global;}catch(e){return false;}");

                if(isNode()){
                    return right(false);
                }

                // Check if request is in local store
                var localRequest = findInLocalStore(requestData);

                if(localRequest){

                    if(localRequest.isWaiting){
                        return left("Waiting");
                    }

                    // Remove from local store and return response
                    removeFromLocalStore(localRequest);
                    return right(localRequest.result);
                }

                // Send request
                send(requestData);
                return left("Waiting");
            }
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
                removeFromLocalStore(requestData);
                return;
            }

            localRequest.isWaiting = false;
            if(result){
                localRequest.result = result;
            }
            else{
                localRequest.result = true;
            }
        }
    });

    // Add request to local store
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

function removeFromLocalStore(requestData){

    var indexToRemove = undefined;

    for (var index = 0; index < serverLocalStore.length; index++) {
        const element = serverLocalStore[index];
        
        if(requestData.url === element.url){
            indexToRemove = index;
        }
    }

    if(indexToRemove !== undefined){
        serverLocalStore.splice(indexToRemove, 1);
    }
}