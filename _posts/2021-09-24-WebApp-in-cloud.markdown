---
layout: post
title:  "Web Apps in the Cloud"
date:   2021-09-24 11:00:00 +0200
categories: cloud, web, apps
---

### Assignment
Today we will create a ASP.NET web app and host it in Azure as an docker container. All source code is in my GitHub [repository](https://github.com/RobinAxelsson/FavouriteLinkWebApp).
### Theme
Its a remake on lasts post CTF, with similar code but instead of attempts to win the flag we now add favorite web links (to make it a more normal use case then a CTF). In a very simple UI (proof of concept) you will be able to input data that is posted to the backend using the ASP.NET OnPost, and the homepage will display all the links in the database. We will add an bonus admin endpoint that is able to delete the database. The secrets will be handled with KeyVault as in last assignment, also the CosmosClient from the Microsoft.Cosmos package will be used again. We will also add a build pipeline that builds and deploys the app on push to GitHub.
### Data Model
```csharp
public class Link
{
    [JsonProperty(PropertyName = "id")]
    public string Id { get; set; }
    public string Name { get; set; }
    public string Group { get; set; } //Partition
    public string Url { get; set; }

    public override string ToString() => JsonConvert.SerializeObject(this);
}
```
A custom Cosmos-class that does the hard work. The class gets injected in the .cshtml-pages on load. It needs the environment variables accountKey and accountEndpoint to work.
```csharp
public class LinkClient
{
    private static string accountEndpoint = Environment.GetEnvironmentVariable("accountEndpoint", EnvironmentVariableTarget.Process);
    private static string accountKey = Environment.GetEnvironmentVariable("accountKey", EnvironmentVariableTarget.Process);

    private static string databaseId = ConfigurationManager.AppSettings["databaseName"];
    private static string containerId = ConfigurationManager.AppSettings["containerName"];

    private Database database;
    private Container container;
    private CosmosClient cosmosClient = new CosmosClient(accountEndpoint, accountKey);

    private async Task InitDbEnvironment()
    {
        database = await cosmosClient.CreateDatabaseIfNotExistsAsync(databaseId);
        container = await database.CreateContainerIfNotExistsAsync(containerId, "/Group");
    }

    /// <summary>
    /// Checks if item already exist with id and partition key.
    /// If it does not exist it creates the item in the container.
    /// </summary>
    /// <param name="link"></param>
    /// <returns>Returns true if it was added, false if it wasn't.</returns>

    public async Task<bool> TryAddLink(Link link)
    {
        await InitDbEnvironment();
        try
        {
            await container.ReadItemAsync<Link>(link.Id, new PartitionKey(link.Group));
            return false;
        }
        catch (CosmosException ex)
        {
            await container.CreateItemAsync<Link>(link, new PartitionKey(link.Group));
            return true;
        }
    }
    /// <summary>
    /// Checks if item already exist with id and partition key.
    /// If it does exist it creates the item in the container. 
    /// </summary>
    /// <param name="id">The id string of the link-object</param>
    /// <param name="partitionKeyValue">The tag value of the link-object</param>
    /// <returns></returns>
    public async Task<bool> TryDeleteLink(string id, string partitionKeyValue)
    {
        await InitDbEnvironment();
        try
        {
            await container.ReadItemAsync<Link>(id, new PartitionKey(partitionKeyValue));
            await container.DeleteItemAsync<Link>(id, new PartitionKey(partitionKeyValue));
            return true;
        }
        catch (CosmosException ex)
        {
            return false;
        }
    }

    /// <summary>
    /// Runs a query (using Azure Cosmos DB SQL syntax) against the container "all" and retrieves all links.
    /// </summary>
    public async Task<List<Link>> GetAllLinksAsync()
    {
        await InitDbEnvironment();
        QueryDefinition queryDefinition = new QueryDefinition("SELECT * FROM all");
        FeedIterator<Link> queryResultSetIterator = container.GetItemQueryIterator<Link>(queryDefinition);

        var links = new List<Link>();

        while (queryResultSetIterator.HasMoreResults)
        {
            FeedResponse<Link> currentResultSet = await queryResultSetIterator.ReadNextAsync();
            foreach (Link link in currentResultSet)
            {
                links.Add(link);
                Console.WriteLine(link.ToString());
            }
        }
        return links;
    }
    /// <summary>
    /// Replace an item in the container
    /// </summary>
    public async Task ReplaceLinkItemAsync(Link link)
    {
        await InitDbEnvironment();
        ItemResponse<Link> linkResponse = await container.ReadItemAsync<Link>(link.Url, new PartitionKey(link.Group));
        var oldLink = linkResponse.Resource;
        linkResponse = await container.ReplaceItemAsync<Link>(link, oldLink.Url, new PartitionKey(oldLink.Group));
    }
    /// <summary>
    /// Delete the database and dispose of the Cosmos Client instance
    /// </summary>
    private async Task DeleteDatabaseAndCleanupAsync()
    {
        await InitDbEnvironment();

        DatabaseResponse databaseResourceResponse = await database.DeleteAsync();
        // Also valid: await this.cosmosClient.Databases["FamilyDatabase"].DeleteAsync();

        Console.WriteLine("Deleted Database: {0}\n", databaseId);

        //Dispose of CosmosClient
        cosmosClient.Dispose();
    }
}
```

Then how it is injected in the page and fetching all the objects in the database.

```csharp
public class IndexModel : PageModel
{
    private readonly ILogger<IndexModel> _logger;
    private readonly LinkClient _linkClient;
    public List<Link> _links = new List<Link>();

    public IndexModel(ILogger<IndexModel> logger, LinkClient linkClient)
    {
        _logger = logger;
        _linkClient = linkClient;
    }

    public async Task<IActionResult> OnGet()
    {
        _links = await _linkClient.GetAllLinksAsync();
        return Page();
    }
}
```
### Azure set-up
To use docker containers in  azure we need a container registry. I did it through the portal.

![create-registry](/img/create-registry.png)

And an app-service that can host the application, this one was created in the azure extension in VS Code.

![create-app-service](/img/create-app-service.png)

### Building the image

I built the image first locally using my docker-compose file.
```yaml
# Please refer https://aka.ms/HTTPSinContainer on how to setup an https developer certificate for your ASP .NET Core service.

version: "3.4"

services:
  favouritelinkwebapp:
    image: favouritelinkwebapp
    build:
      context: .
      dockerfile: src/LinkAsp/Dockerfile
    ports:
      - 5000:5000

# Because I use environment variables for secrets I need to specify this to be able to run the container with access to the database.
    environment:
      - accountEndpoint=${accountEndpoint}
      - accountKey=${accountKey}
```

### Pushing the image to Azure Container Registry

Docker extensions for VS Code worked well for this (first you have to login with az login), then add the registry, push your image with the Docker extension and lastly you can deploy the image to your app service (also with the Docker extension). The process is described in detail in [this guide](https://code.visualstudio.com/docs/containers/app-service) which i followed.

### Error!
But we missed something, to run the application in the cloud we still need the secrets.

![error-secrets](/img/error-secrets.png)

The solution is as in last application to add the azure KeyVault secrets to the app and it works in exactly the same manner 
[(see last post for details on getting and setting secrets)]({% post_url 2021-09-22-CloudDatabase %}).

```shell
### Set Web app secret url
    az webapp config appsettings set -g "NET-YH" -n "FavouriteLink-01" --settings $VAR
```

After adding secrets to AppSettings we try to load the page again... And it works!

![load-favourites-app](/img/load-favourites-app.png)

### Prizing

The prize of just the app service (using [pricing calculator](https://azure.microsoft.com/en-us/pricing/calculator/)):
- Basic Tire
- Linux OS
- 1 Core
- 1.75 RAM
- 10 GB Storage

Prizes to $13.14 a month (Linux is considerably lower than Windows).

- Premium V3 Tire
- Linux OS
- 2 Cores
- 8 GB RAM
- 250 GB Storage

Prizes to $123 per month.

