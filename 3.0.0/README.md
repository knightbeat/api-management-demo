# Demo Script

## 1.Delivery Service ##

[Backend URL] 
`http://localhost:9098/deliveries`

POST
```
{
  "houseNumber": 73,
  "street": "Regent street",
  "postCode": "N1 6DS",
  "city": "London",
  "key":"0005"
}
```
GET 0004

## 2.GraphSQL Schema ##
`countries-api-schema.graphql`

API Name = `CountriesDataAPI`
context = `/countries`
version = `1.0.0`
Backend URL `https://countries.trevorblades.com/`

Try POST `https://localhost:8243/countries/1.0.0` with API-M

```
{
    continent(code:"EU")
    {
        code 
        name 
        countries
        {
            code 
            name
            languages
            {
                code
                name
            }
        }
    }
}
```


## 3.Import API using apictl ##

#### Register Environment ####
`./apictl add-env -e dev --registration https://localhost:9443/client-registration/v0.15/register --apim https://localhost:9443 --token https://localhost:8243/token`

#### Add Swagger Petstore ####
`./apictl init PetstoreAPI --oas https://petstore.swagger.io/v2/swagger.json`

PetstoreAPI » Meta-information » api.yaml
```
status: PUBLISHED
productionUrl: http://petstore.swagger.io/v2
```

`./apictl import-api --file ./PetstoreAPI --environment dev -k`

## 4.MicroGateway ##
`micro-gw init petstore`

`cp ../petstore-oas-1.0.3.yaml petstore/api_definitions`

`micro-gw build petstore`

`cd /Users/.../microgateway/bin`

`./gateway /Users/.../mgw-workspace/petstore/target/petstore.balx`

OR

`docker run -d -v /Users/.../mgw-workspace/petstore/target/:/home/exec/ -p 9095:9095 -p 9090:9090 -e project="petstore"  wso2/wso2micro-gw:latest`

## 5.API Product concept ##