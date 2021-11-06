---
layout: post
title:  "Blobs in the clouds"
date:   2021-10-01 11:00:00 +0200
categories: cloud, network
---

![Rorschach-blob](/img/rorschach-blob.png)
### Assignment
In todays post we will create a console application that will do CRUD-operations (create, read, update, delete) to an Azure Storage Container (and account). All code is shared on GitHub in this [repo: ConsoleBlobApp](https://github.com/RobinAxelsson/ConsoleBlobApp).

### Tools
- Visual Studio Code
- MacOS
- GitHub
- dotnet SDK
- Azure Storage Account
- Azure Storage Container

### What is a Blob?
"A binary large object (BLOB) is a collection of binary data stored as a single entity. Blobs are typically images, audio or other multimedia objects, though sometimes binary executable code is stored as a blob. They can exist as persistent values inside some databases, or exist at runtime as program variables in some languages." [//Wikipedia](https://en.wikipedia.org/wiki/Binary_large_object)

Or with my own words: any data that you want to store in the cloud in a unstructured, no-SQL way.

### Types of Blobs
In Azure there are [three types of blobs:](https://docs.microsoft.com/en-us/rest/api/storageservices/understanding-block-blobs--append-blobs--and-page-blobs)
- ***Page Blobs*** a collection of 512-byte pages, used for storing structures like OS and disks for VMs and DBs.
- ***Block Blobs*** blob composed of blocks optimized for upload/download.
- ***Append Blobs*** similar to block blobs but update and delete operations is not supported.

In our assignment we will only use block blobs because we need to do CRUD operations.

### What is Azure Storage Account?

"The Azure Storage platform is Microsoft's cloud storage solution for modern data storage scenarios. Core storage services offer a massively scalable object store for data objects, disk storage for Azure virtual machines (VMs), a file system service for the cloud, a messaging store for reliable messaging, and a NoSQL store." [//Microsoft](https://docs.microsoft.com/en-us/azure/storage/common/storage-introduction)

Or a account where you can create containers for storing blobs, with CRUD-operations accessible through: Azure Portal, AZ CLI, multiple language APIs and as in this assignment .NET-objects.

### The application
I wanted to make my first .NET console application with proper in-arguments from the command line. I also wanted to have highly configurable application where the user/developer could manage settings and secrets in flexible way.

```
.
├── README.md
├── img
│   ├── bowline.png
│   ├── diamondknot.png
│   └── half-hitch.png
├── output
├── run.sh
├── src
    └── BlobCI
        ├── BlobCI.csproj
        ├── Options.cs
        ├── Program.cs
        ├── appsettings.yml

```
### Dependencies
```xml
<!-- project file -->
  <ItemGroup>
    <PackageReference Include="Azure.Storage.Blobs" Version="12.10.0" />
    <PackageReference Include="CommandLineParser" Version="2.8.0" />
    <PackageReference Include="Microsoft.Extensions.Configuration" Version="5.0.0" />
    <PackageReference Include="Microsoft.Extensions.Configuration.CommandLine" Version="5.0.0" />
    <PackageReference Include="Microsoft.Extensions.Configuration.EnvironmentVariables" Version="5.0.0" />
    <PackageReference Include="Microsoft.Extensions.Configuration.UserSecrets" Version="5.0.0" />
    <PackageReference Include="NetEscapades.Configuration.Yaml" Version="2.1.0" />
  </ItemGroup>
```

### Connection String & Configuration
```csharp
//Loads all variables from multiple sources, overrides if reoccurrence.
var config = new ConfigurationBuilder()
.AddYamlFile("appsettings.yml")
.AddUserSecrets<Program>() //User secrets commands our found in README.md
.AddEnvironmentVariables()
.Build();

//Sets connection string from configuration settings if not using Azure Emulator Storage.
var cs = config["UseDevelopmentStorage"] == "true" ? "UseDevelopmentStorage=true;" : config["CONNECTION_STRING"] ??
    throw new ArgumentNullException("You need to enter a connection string");

```
Above is the ConfigurationBuilder used to add all the possible configurations, as a user/developer you can add variables from either: appsettings.yml, User-Secrets or as environment variables. The order is important because the builder will override the variables with the same name in every method.

```shell
dotnet user-secrets init
dotnet user-secrets set CONNECTION_STRING "mystring"
dotnet user-secrets list
```
Dotnet User Secrets is the most secure way to add the connection string to the application for local use. It is a simple way to store key-value pairs that are added with the ".AddUserSecrets\<Program\>" method and then the above commands in the shell.

```yaml
CONNECTION_STRING: #empty is default

#For azure storage emulator
UseDevelopmentStorage: "true" #true is default
```
If you want to use the Azure storage emulator for using local blob storage (or not spending any money sending data), set the UseDevelopmentStorage to true.

### Making commands
As stated above this application is aimed to be a highly automatable and scriptable command line app. The Nuget package [CommandLineParser](https://github.com/commandlineparser/commandline#command-line-parser-library-for-clr-and-netstandard) is a widely used and very handy to add action verbs, flags and input args to make the app similar to git CLI or az CLI for instance.

```shell
# Create
dotnet BlobCI.dll add -c mycontainer --uri ./img/example1.png ./img/example2.png

# Read
dotnet BlobCI.dll download --container mycontainer --blob-names example.png example2.png --output-folder ./output # download blobs to folder
dotnet BlobCI.dll list --container mycontainer #list all blob names

# Update
dotnet BlobCI.dll update -c mycontainer -u ./img/example1.png ./img/example2.png

# Delete
dotnet BlobCI.dll delete --container mycontainer --blob-names example1.png example2.png
dotnet BlobCI.dll delete --container mycontainer --delete-all
```
For more information check out the [Options.cs](https://github.com/RobinAxelsson/ConsoleBlobApp/blob/master/src/BlobCI/Options.cs)
### Azure Storage Blobs Library
The simplest methods for create, read, update, delete was attempted to be used from this library.
```csharp
//All operations
container = new BlobContainerClient(cs, opt.Container); //opt.Container is an input arugument --container mycontainer
container.CreateIfNotExists();

//Create
container.GetBlobClient(Path.GetFileName(path)).Upload(path);

//Read
container.GetBlobs().ToList().ForEach(b => Console.WriteLine(b.Name)); //List all

var blobClient = container.GetBlobClient(name); //Download
blobClient.DownloadTo(Path.Combine(outpoutDir + "/" + name));

//Update
container.DeleteBlob(fileName); //delete the old blob first
container.GetBlobClient(fileName).Upload(path); //same as in create

//Delete
if (opt.DeleteContainer) //Deletes all blobs in one go by deleting the container.
    container.Delete();
else
    opt.BlobNames.ToList().ForEach(name => container.DeleteBlob(name));
```
### Data Flow
![blobflow](/img/blobflow.png)

The data flow is very simple in this application - and that is intended. With a fully automatable console app you can do CRUD operations at any scale you like.

### Pricing an app that reads and writes files in Azure?
But if you want to host images and view them at a web page as well, for instance a page similar to [Shutterstock.](https://www.shutterstock.com/)

I am using the [Azure Calculator](https://azure.microsoft.com/en-us/pricing/calculator/) and making some assumptions about the site and the traffic.\
![price](/img/price.png)


### Securing Data
Microsoft has a default that user data is not accessible for anyone else then the user. Always uses the least privilege thats is required and no administrator accounts in VMs. [Docs](https://docs.microsoft.com/en-us/azure/security/fundamentals/protection-customer-data)\
Everything is encrypted and backed up which is actually the easy part. The harder part is to protect the keys that we use to access the encrypted data in the cloud. Azure KeyVault helps us to store configuration variables in the cloud and on disc they provide dotnet user-secrets that is used in this project (and default in ASP.NET).

### Final
I like this way of storing data, we should have all our data this way and have apps to request the data from us.

### References
[https://github.com/commandlineparser/commandline#command-line-parser-library-for-clr-and-netstandard](https://github.com/commandlineparser/commandline#command-line-parser-library-for-clr-and-netstandard)

[https://docs.microsoft.com/en-us/dotnet/api/overview/azure/storage.blobs-readme](https://docs.microsoft.com/en-us/dotnet/api/overview/azure/storage.blobs-readme)
<!-- Console app
blob files
blob containers
push up image locally
create storage account
create new containers -->
