---
layout: post
title:  "Monitoring Cloud Apps"
date:   2021-10-06 11:00:00 +0200
categories: cloud, network
---

![monitor](/img/monitor.png)
### Assignment
In todays post we will implement logger to an web application and demonstrate how to query the log information in Azure.

### Tools
- Visual Studio Code
- MacOS
- GitHub
- dotnet SDK
- Azure Storage Account
- Azure Storage Container

### Logging to Azure Insights

Inject Application insights in Startup.cs class in the asp.net project directory.

```csharp
ConfigureServices(IServiceCollection services)
{
    services.AddApplicationInsightsTelemetry(Configuration); //Configuration holds all key-values in appsettings.
}
```

Configure your logging inside appsettings.json.

```json
"ApplicationInsights": {
      "LogLevel": {
        "Default": "Information",
        "Microsoft": "Error"
      }
    }
```

Inject ILogger in the controls or functions where you want to log information and specify when and where to log - and to what level. Possible are from low to high severity: trace, information, warning, error, critical.

```csharp
//Example of implementation
public static IActionResult Run(
    [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
    ILogger log)
{
    string Operation = Environment.GetEnvironmentVariable("Operation");
    bool isAdd = Operation == "ADDITION"
    ? true : Operation == "SUBTRACTION" ? false 
    : throw new ArgumentException("Input variables are incorrect", Operation);

    log.LogInformation($"-----------NEW REQUEST TO {Operation}-----------------");
    log.LogInformation("C# HTTP trigger function processed a request.");
```

Last step is to turn on azure insights in the portal by just clicking Application Insights inside the app service of interest and follow the [instructions](https://docs.microsoft.com/en-us/azure/azure-monitor/app/create-new-resource).

### App overview

With application insights activated we can have a nice overview of the app. The App serves as a online calculator (it is a app which were the exam in cloud services course) which has a web-app frontend/backend with ASP.NET connected to two Azure Functions which do the calculations and one CosmosDb database storing the calculations made. [GitHub-repo](https://github.com/RobinAxelsson/MolnTentaDeploy).

![overview-monitor](/img/overview-monitor.png)

### KQL

According to Microsoft: Kusto Query Language is a simple yet powerful language to query structured, semi-structured and unstructured data. It assumes relational data model of tables and columns with a minimal set of data types. The language is very expressive, easy to read and understand the query intent, and optimized for authoring experiences.

KQL is what is used in Application Insights to query data and it is well needed - because apps can produce so much data. Following is a few examples and responses of what queries you can have.

![kusto-requests](/img/kusto-requests.png)
Above we query the incoming requests the last 24 hours, its a good overview how the app is used.

```KQL
requests
| summarize Count=sum(itemCount) by operation_Name, success, url
```

Summarize exceptions:

```KQL
exceptions
| summarize Count=sum(itemCount) by method, message, outerType, operation_Name, severityLevel
```

Querying the log messages that are greater then severity 1.

```KQL
traces
| summarize Count=sum(itemCount) by message, severityLevel
| where severityLevel>1
```

## EOF

With .NET ILogger interface you can use a lot of different loggers, in above example we use the .NET built in logger but there are other alternatives, for instance Serilog is more used and has a good way of saving objects in the log as serialized json. But with above code it is very easy to change logger - so you can always change it, in some environments maybe you just log into the console - or to the cloud.