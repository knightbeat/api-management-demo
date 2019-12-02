import ballerina/http;
import ballerina/log;

type Loan record {
    int id;
    float amountAuthorised;
};

@http:ServiceConfig {
    basePath: "/loan-service"
}
service loanStatusService on new http:Listener(9093){

    @http:ResourceConfig {
        path: "/approval/{customerId}",
        methods: ["GET"]
    }
    resource function getApprovedAmountForCustomerID(http:Caller caller, http:Request request, int customerId) returns error?{

        // Create object to carry data back to caller
        http:Response response = new;

        json responsePayload;
        int customerIdentifier = <@untainted> customerId;
        float amountAuthorised = 0.0;

        table<Loan> tableLoans = table {
            { key id, amountAuthorised },
            [ 
                { 1, 1000600.10 },
                { 2, 1900546.07 },
                { 3, 1003034.34 },
                { 4, 2003456.08 }
            ]
        };

        foreach var x in tableLoans {
            if(x.id == customerIdentifier){
                amountAuthorised = x.amountAuthorised;
            }
        }

        responsePayload = {"CustomerID":customerIdentifier,"AmountAuthorised":amountAuthorised};
        response.setJsonPayload(responsePayload);

        var result = caller->respond(response);

        if (result is error) {
            log:printError("Error sending response", result);
        }
        return();
    }
}
