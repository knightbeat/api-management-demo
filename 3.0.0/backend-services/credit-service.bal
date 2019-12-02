import ballerina/http;
import ballerina/log;

type Customer record {
    int id;
    string fullName;
    int creditScore;
};

@http:ServiceConfig {
    basePath: "/credit-service"
}
service loanStatusService on new http:Listener(9092){

    @http:ResourceConfig {
        path: "/profile/{customerId}",
        methods: ["GET"]
    }
    resource function getProfileByCustomerID(http:Caller caller, http:Request request, int customerId)  returns error? {

        // Create object to carry data back to caller
        http:Response response = new;

        json responsePayload;
        int customerIdentifier = <@untainted> customerId;
        int creditScore = 0;
        string fullName = "Unidenfied customer";

        table<Customer> tableCustomers = table {
            { key id, fullName, creditScore },
            [ 
                { 1, "Jimmy McGill",  920 },
                { 2, "Mike Ehmantraut",  810 },
                { 3, "Nacho Varga", 870 },
                { 4, "Gustavo Fring", 990 }
            ]
        };

        foreach var x in tableCustomers {
            if(x.id == customerIdentifier){
                fullName = x.fullName;
                creditScore = x.creditScore;
            }
        }

        responsePayload = {"CustomerID":customerIdentifier,"FullName":fullName,"CreditScore":creditScore};
        response.setJsonPayload(responsePayload);

        var result = caller->respond(response);

        if (result is error) {
            log:printError("Error sending response", result);
        }
        return();
    }
}
