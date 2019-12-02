import ballerina/http;
import ballerina/log;

type Address record {
    int houseNumber;
    string street;
    string postCode;
    string city;
};

Address address1 = {houseNumber:15, street:"Wales street", postCode:"NN15 7EL", city:"Rothwell"};
Address address2 = {houseNumber:11, street:"Rokingham road", postCode:"NN16 8XN", city:"Kettering"};
Address address3 = {houseNumber:27, street:"Midland cresent", postCode:"NN13 ERF", city:"Corby"};
Address address4 = {houseNumber:12, street:"Gypsy lane", postCode:"NN11 8HA", city:"Rushden"};

map<Address> addressMap = {"0001" : address1,"0002":address2,"0003":address3,"0004":address4};

@http:ServiceConfig {
  basePath: "/deliveries"
}
service deliveryService on new http:Listener(9098) {

    @http:ResourceConfig {
        path: "/addresses",
        methods: ["POST"]
    }
    resource function createBillingAddress (http:Caller caller, http:Request request) returns error? {
        json payload = <@untainted> check request.getJsonPayload();

        int _houseNumber = <int> payload.houseNumber;
        string _street = <string> payload.street;
        string _postCode = <string> payload.postCode;
        string _city = <string> payload.city;
        string _key = <string> payload.key;

        http:Response response = new;

        Address address = {houseNumber:_houseNumber, street:_street, postCode:_postCode, city:_city};

        addressMap[_key] = address;

        json responsePayload;

        Address newRecord = <Address> addressMap[_key];

        json | error nr = json.constructFrom(newRecord);

        if (nr is json) {
            responsePayload = {"message":"Record Created!","record":nr};
        }else{
            responsePayload = {"message":"Error!"};
        }

        response.setJsonPayload(responsePayload);
        var result = caller->respond(response);

        if (result is error) {
            log:printError("Error sending response", result);
        }

        return();
    }
    @http:ResourceConfig {
        path: "/addresses",
        methods: ["PUT"]
    }
    resource function updateBillingAddress (http:Caller caller, http:Request request) returns error? {
        json payload = <@untainted> check request.getJsonPayload();

        int _houseNumber = <int> payload.houseNumber;
        string _street = <string> payload.street;
        string _postCode = <string> payload.postCode;
        string _city = <string> payload.city;
        string _key = <string> payload.key;

        http:Response response = new;

        json responsePayload;

        Address address = {houseNumber:_houseNumber, street:_street, postCode:_postCode, city:_city};

        addressMap[_key] = address;

        Address newRecord = <Address> addressMap[_key];

        json | error nr = json.constructFrom(newRecord);

        if (nr is json) {
            responsePayload = {"message":"Record Updated!","record":nr};
        }else{
            responsePayload = {"message":"Error!"};
        }

        response.setJsonPayload(responsePayload);
        var result = caller->respond(response);

        if (result is error) {
            log:printError("Error sending response", result);
        }
        return();
    }
    

    @http:ResourceConfig {
        path: "/addresses/{key}",
        methods: ["GET"]
    }
    resource function getBillingAddress (http:Caller caller, http:Request request, string key) returns error? {

        string _key = <@untainted> key;

        http:Response response = new;

        json responsePayload = {"message":"Record not found!"};

        any newRecord = addressMap[_key];

        json | error nr;
        if (newRecord is Address){
            nr = json.constructFrom(newRecord);
        }else{
            nr = {"message":"Record not found!"};
        }

        if (nr is json) {
            responsePayload = nr;
        }else{
            responsePayload = {"message":"Error!"};
        }

        response.setJsonPayload(responsePayload);
        var result = caller->respond(response);

        if (result is error) {
            log:printError("Error sending response", result);
        }
        return();
    }
    @http:ResourceConfig {
        path: "/addresses/{key}",
        methods: ["DELETE"]
    }
    resource function deleteBillingAddress (http:Caller caller, http:Request request, string key) returns error? {

        string _key = <@untainted> key;

        http:Response response = new;

        Address removedAddress = addressMap.remove(_key);

        json responsePayload = {"message":"Record was not deleted!"};

        response.setJsonPayload(responsePayload);
        var result = caller->respond(response);

        if (result is error) {
            log:printError("Error sending response", result);
        }
        return();
    }

}