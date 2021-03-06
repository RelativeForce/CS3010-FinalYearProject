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

    // Get the anit-forgiery token from the page
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
        
            // Get the request from the local store
            var localRequest = findInLocalStore(requestData);

            // Remove request if it wasn't a success
            if (status !== "success") {
                removeFromLocalStore(requestData);
                return;
            }

            // Update the request result in the local store
            localRequest.isWaiting = false;
            if(result || result === []){
                localRequest.result = result;
            }
            else{
                localRequest.result = true;
            }
        },
        error : function (jqXHR, exception) {
            
            var msg = '';
            if (jqXHR.status === 0) {
                msg = 'Not connect.\n Verify Network.';
            } else if (jqXHR.status == 404) {
                msg = 'Requested page not found. [404]';
            } else if (jqXHR.status == 500) {
                msg = 'Internal Server Error [500].';
            } else if (exception === 'parsererror') {
                msg = 'Requested JSON parse failed.';
            } else if (exception === 'timeout') {
                msg = 'Time out error.';
            } else if (exception === 'abort') {
                msg = 'Ajax request aborted.';
            } else {
                msg = 'Uncaught Error.\n' + jqXHR.responseText;
            }
            
            // Log the error and remove the request from the store.
            console.log(msg);
            removeFromLocalStore(requestData);
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