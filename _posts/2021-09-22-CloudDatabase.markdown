---
layout: post
title:  "Cloud Database & Capture The flag 🏴‍☠️"
date:   2021-09-22 11:00:00 +0200
categories: cloud
---

<!-- 
Describe the app, code and database.
How is it configured/created?
Use screenshots, scripts, pipelines
How do you reason about updating the database? Migrations?
What is the pricing? Scenario 1 few users, 2 massive amount of uses.
-->
### Assignment
In todays post we are going to look into Azure Cosmos DB and crate a no-SQL database with an SQL Api. To read and update the database we will use two http-trigger functions (one for each) hosted in one Azure Function.

[All code is on GitHub](https://github.com/RobinAxelsson/AzureCTF)

### Theme
We model an Capture the flag puzzle where the "attackers" are going to break the following encoded message: 🌎,dmFyaWFibGVz,R,🧊

[Repo and description of the CTF.](https://github.com/RobinAxelsson/Test-Endpoints-ENV-)

### Creating the database account
We use the VS-code extension for azure to create the db.
![image](/img/create-db.png)

### Getting account key and endpoint
This is needed for the functions to get access to the database, together they are called "Connection string".

![connection-string](/img/string.png)

This should be passed to an object of CosmosClient class to get access to the database account. But how do we do this without exposing our secrets?

```csharp
CosmosClient cosmosClient = new CosmosClient(accountEndpoint, accountKey);
```
### AzureKeyVault - Secret Security
The solution we will use here is to create a new KayVault and add the connection string as a secret - and then let the app retrieve them using the secrets in the cloud as environmental variables.

```shell
# Create keyvault using Azure CLI
az keyvault create --name "keyVaultName" --resource-group "myResourceGroup" --location "northEurope"

# Create secret
 az keyvault secret set --name MySecretName --vault-name MyKeyVault --value MySecretValue
```
Next step is to add the KeyVault access policy to the function, I followed the steps in this [guide](https://daniel-krzyczkowski.github.io/Integrate-Key-Vault-Secrets-With-Azure-Functions/) which also described how we will set and use the environment variables to manage our secrets.

When our app/function has access we need to add the references to the KeyVault secrets. They will look similar to this:
```json
    "accountEndpoint": "@Microsoft.KeyVault(SecretUri=https://linkmanagement.vault.azure.net/secrets/accountEndpoint/acdb9d5d6826482c8e7a99c66bb5d587)",
    "accountKey": "@Microsoft.KeyVault(SecretUri=https://linkmanagement.vault.azure.net/secrets/accountKey/66cfba1263ac410d80a34f3dff02126b)"
```
[An really good custom script to set new refs!](https://github.com/RobinAxelsson/AzureCTF/tree/master/azure)
```shell
# if we use the scripts in the link -> we will pipe the input
# getrefs.sh gets and formats the secrets with their names as input
# setrefs.sh does what it says

bash getrefs.sh <name1> <name2> | bash setrefs.sh
```
Now we have access to the keys and referenced them in our app settings in the cloud. Now we need to be able to set them locally. We will use the following script (as a startup script).
```shell
#!/usr/bin/env bash

# This function erases the variables on exit
function cleanup() {
    unset accountEndpoint
    unset accountKey
    exit
}

# Binds the cleanup to on exit
trap cleanup SIGINT

# reads in the secrets from a .secret folder that is added to .gitignore
export accountEndpoint=$(cat .secrets/accountEndpoint.secret)
export accountKey=$(cat .secrets/accountKey.secret)

# runs the function locally
func start --csharp
```
Inside the c# file.
```csharp
  private static string accountEndpoint = Environment.GetEnvironmentVariable("accountEndpoint", EnvironmentVariableTarget.Process);
  private static string accountKey = Environment.GetEnvironmentVariable("accountKey", EnvironmentVariableTarget.Process);
```
Now we can use our CosmosClient, our goal is to create a database, a collection, adding and reading items (but also delete the db).

### Data model
Because our database has the mission to store answers to the capture the flag puzzle our data model will be very simple.
```csharp
public class Answer
{
    [JsonProperty(PropertyName = "id")]
    public string Attempt { get; set; }
    public string Name { get; set; } //Partition key
    public override string ToString() => JsonConvert.SerializeObject(this);
}
```

### Setting up the code
As in previous posts we add a function project with VS Code additionally we will use the Nuget package for CosmosDb from Microsoft. I followed this [guide](https://docs.microsoft.com/en-us/azure/cosmos-db/sql/sql-api-get-started) when I wrote the project but cleaned it up as below method. See full code in [Functions folder](https://github.com/RobinAxelsson/AzureCTF/tree/master/src/Function).
```csharp
/// <summary>
/// Checks if item already exist with id and partition key.
/// If it does not exist it creates the item in the container.
/// </summary>
/// <param name="answer">An Answer object</param>
/// <param name="container">Database Container</param>
/// <returns>Returns true if it was added, false if it wasn't.</returns>
private static async Task<bool> TryAddAnswer(Answer answer, Container container){
    try{
        await container.ReadItemAsync<Answer>(answer.Id, new PartitionKey(answer.Name));
    }
    catch (CosmosException ex){
        await container.CreateItemAsync<Answer>(answer, new PartitionKey(answer.Name));
        return true;
    }
    return false;
}
```
I also made read all, delete database and update (but not implemented), when we have the cosmos account connection string we can do whatever we want with the databases and containers held inside it.

### Git Pipeline
[GitActions](https://github.com/RobinAxelsson/AzureCTF/blob/master/.github/workflows/master_azurectf-yh4.yml) is generated by Azure and is described in Function Calculator post.

## End to end tests
Get and post request to the azure functions endpoints with replies.
```shell
#!/usr/bin/env bash
echo -----------Starting Attempts------------
curl "https://azurectf-yh4.azurewebsites.net/api/HttpLinks?code=fYd5aVzdRWhNNqc4UKyNwN6nfLd0rzzZf9WBJGV2Sqtxp1mIOO/waw==&name=bob&answer=this,environment,are,big"
# You matched *******,*******,are,*******
curl "https://azurectf-yh4.azurewebsites.net/api/HttpLinks?code=fYd5aVzdRWhNNqc4UKyNwN6nfLd0rzzZf9WBJGV2Sqtxp1mIOO/waw==&name=albin&answer=who,are,this,cool"
# You matched *******,*******,*******,cool
curl "https://azurectf-yh4.azurewebsites.net/api/HttpLinks?code=fYd5aVzdRWhNNqc4UKyNwN6nfLd0rzzZf9WBJGV2Sqtxp1mIOO/waw==&name=Steffie&answer=global,environment,variables,are,cool"
# Your answer was accepted... But none of the words matched, you are welcome to try again!
echo
echo ------------------Admin----------------------
curl -d "" -X POST "https://azurectf-yh4.azurewebsites.net/api/HttpAdmin?code=FYKfR3JNceVhMhmVf0pJKC2szaZy/LUzdH8i1CItZfBcakvA7BjyBg=="
[
    {
        "id": "environment,vars,are,blue",
        "Name": "calle"
    },
    {
        "id": "global,envers,is,square",
        "Name": "calle"
    },
    {
        "id": "environment,variables,are,cool",
        "Name": "calle"
    },
    {
        "id": "this,environment,are,big",
        "Name": "bob"
    },
    {
        "id": "who,are,this,cool",
        "Name": "albin"
    },
    {
        "id": "global,environment,variables,are,cool",
        "Name": "Steffie"
    }
]
curl -d "" -X POST "https://azurectf-yh4.azurewebsites.net/api/HttpAdmin?code=FYKfR3JNceVhMhmVf0pJKC2szaZy/LUzdH8i1CItZfBcakvA7BjyBg==&cmd=delete"
# Database deleted
```

### Prizing
According to azure Calculator with one region of northern Europe the database and Function will be about $25 per month and because it is a Capture the Flag there won't be that much traffic if we have an firewall that blocks an address with to many requests. If we scale this competition to cover five regional data centers and $1,000,000,000 executions per month the prize will surge to (only) $635.8 per month.

### Migration
CosmosDb do not have a schema as you would expect from a SQL database, the documents or items in each container is a isolated entity and this makes it easier to change the data models but harder to query data. To track the changes in a container Azure provides a [Change feed](https://docs.microsoft.com/en-us/azure/cosmos-db/change-feed).

### Conclusion
Cloud database is a preferable choice in terms of economy and simplicity. If you migrate to CosmosDb you have the option to use the api:s of both MongoDb and SQL to make the transition as smooth as possible.