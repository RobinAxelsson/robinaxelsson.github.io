---
layout: post
title:  "Serverless Applications"
date:   2021-09-17 19:00:00 +0200
categories: cloud
---

<!-- What is Serverless and FaaS?
Describe the calculator:
  The code
  How does it run in Azure functions?
    - display screenshots, scripts, pipelines
  How did you test the application?
  What security threats is there to your application?
  What have you done to prevent those?
  (hint: OWASP top 10 - Interpretation for Serverless)
-->

### What is Serverless?
"Serverless or serverless computing is a cloud-based execution model in which cloud service providers provision on-demand machine resources and manage the servers by themselves instead of customers or developers. It is a way that combines services, strategies, and practices to help developers build cloud-based apps by letting them focus on their code rather than server management." - [Amrita Pathak, Geekflare](https://geekflare.com/know-about-serverless/)

In other words serverless does't mean there is no servers, the server still exists in the background but it is managed by a cloud provider and abstracted away from the developer process. There are two main overlapping services in Serverless. FaaS or Function as a Service and BaaS backend as a service.

### What is FaaS?
FaaS or Function as a Service is deployment of code with all the software infrastructure and provided, the developer only provides the code for the actual application. The model of payment differs from normal pay per minute/hour, if FaaS its more normal to pay per execution/request or by computing.

### Calculator function
This blog posts assignment is to write and deploy an Azure Function (Http Trigger function) that takes two number inputs, validates them an then returns the sum of the inputs if they are valid inputs. You can see the entire source code in my public [repo](https://github.com/RobinAxelsson/AzureFunctionsDotnetCoreCalculator).

### Set-Up
I started out trying writing a function in the web interface in an scripting version of .NET-Core, this didn't work out for me and later I realized that I used .NET-5 syntax for C# where you are allowed to set primitive datatypes to null. I started all over locally with vs code and tried different project setups where I landed in a .NET-core 3 (which is LTS in Azure Functions), with an x-unit test project. VS Code informed me about the C# code that wasn't available in .NET Core.

### Function Source Code
```csharp
public static class HttpTrigger
{
public static readonly string DefaultResponse = "Add query parameters ?a=1&b=3 to use the calculator.";
public static string responseCalculation(string decimalA, string decimalB) => $"{Convert.ToDecimal(decimalA) + Convert.ToDecimal(decimalB)}";
public static string ValidateInput(string input)
{
    //Null check
    if (input == null) return null;

    //Check for decimal type overflow
    if (input.Length > 20) return null;

    //At least one digit
    if (input.ToList().Aggregate(0, (acc, c) => 
        char.IsDigit(c) ? acc + 1 : acc + 0) == 0) return null;

    // Only digits and "." or "-"
    if (input.ToList().TrueForAll(c => 
        !char.IsDigit(c) && c != '.' && c != '-')) return null;

    //Only one "."
    if (input.ToList().Aggregate(0, (acc, x) =>
        x == '.' ? acc + 1 : acc + 0) > 1) return null;

    //dot is not first
    if (input.ToList().Aggregate(0, (acc, x) =>
        x == '.' ? acc + 1 : acc + 0) == 1 && input[0] == '.') return null;

    //Only one "-"
    if (input.ToList().Aggregate(0, (acc, x) =>
        x == '-' ? acc + 1 : acc + 0) > 1) return null;

    //"-" is first
    if (input.ToList().Aggregate(0, (acc, x) =>
        x == '-' ? acc + 1 : acc + 0) == 1 && input[0] != '-') return null;
    return input;
}
[FunctionName("HttpTrigger")]
public static IActionResult Run(
    [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
    ILogger log)
{
    log.LogInformation("------------------NEW REQUEST-----------------");
    log.LogInformation("C# HTTP trigger function processed a request.");

    string a = req.Query["a"];
    string b = req.Query["b"];

    string response = ValidateInput(a) != null && ValidateInput(b) != null ?
        responseCalculation(a, b) : null;

    //If no value is null, calculation is returned with status code 200.
    if (response != null) return new OkObjectResult(response);

    //else response is the default message with status code 400.
    return new BadRequestObjectResult(DefaultResponse);
}

```
### Testing

A lot of lines are to validate the input to make it really hard to input malicious code and also two testing steps are made, first just the code functions and then end to end test with curl.
```csharp
StartUp() => Assert.True(true);
InputDots() => Assert.Null(HttpTrigger.ValidateInput("1.."));
InputDots3() => Assert.Null(HttpTrigger.ValidateInput("..."));
InputDotLast() => Assert.Equal("1.", HttpTrigger.ValidateInput("1."));
InputBraces2() => Assert.Null(HttpTrigger.ValidateInput("["));
InputBraces3() => Assert.Null(HttpTrigger.ValidateInput("("));
InputQoute() => Assert.Null(HttpTrigger.ValidateInput("\""));
InputSingleQoute() => Assert.Null(HttpTrigger.ValidateInput("'"));
InputAlpha() => Assert.Null(HttpTrigger.ValidateInput("abcd"));
InputAlpha2() => Assert.Null(HttpTrigger.ValidateInput("你好，世界"));
InputRocket() => Assert.Null(HttpTrigger.ValidateInput("🚀"));
InputDot() => Assert.Null(HttpTrigger.ValidateInput("."));
InputMiddleMinus() => Assert.Null(HttpTrigger.ValidateInput("1-1"));
IsOne() => Assert.Equal("1", HttpTrigger.ValidateInput("1"));
IsOnePointOne() => Assert.Equal("1.0", HttpTrigger.ValidateInput("1.0"));
IsOnePoint__() => Assert.Equal("1.0000", HttpTrigger.ValidateInput("1.0000"));
```

### Test endpoint with Bash
The bash command cUrl or curl is a preinstalled unix command line tool that can send http-requests. I wrote a Bash-Script that I used on the localhost, but also in production. One example from the script below and full script [here](https://github.com/RobinAxelsson/AzureFunctionsDotnetCoreCalculator/blob/master/curltests.sh).
```shell
    # concatinates url with querystring
    url="$hostUrl"a=1\&b=2

    # Sends a get request as url?a=1&b=2
    response=$(curl -s "$url")

    # Checks if response is 3
    if [[ $response == 3 ]]; then
        Points=$((Points + 1)) # True => adds points
    else
        echo error # False => prints error to the console
    fi
```

### Host the function locally with bash
For this we need [Azure Functions Core Toolkit](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=macos%2Ccsharp%2Cportal%2Cbash%2Ckeda)
```script
#!/usr/bin/env bash
cd ./Azure_DotnetCore
func start --csharp
```

### Deploy
I used VS Code extension tools to create and start my function.
![VS Code Azure Function image](/img/azure-extension-tools.png)\
### Start and stop with Azure CLI
```script
az login -u <username> -p <password>
az functionapp start --name <function-name> --resource-group <group-name> # or stop
```
### Setting up GitHub workflow for deployment and test
First Azure helps us generate a template (scroll down to preview file button).\
![template](/img/generate-action.png)
### YAML workflow
Below is the generated template from Azure, but I had to do so some adjustments. I wanted my test project to run and also my endpoint tests. 

```yaml
# Docs for the Azure Web Apps Deploy action: https://github.com/azure/functions-action
# More GitHub Actions for Azure: https://github.com/Azure/actions

name: Build and deploy dotnet core project to Azure Function App - FunctionCalculator

on:
  push:
    branches:
      - master
  workflow_dispatch:

env:
  AZURE_FUNCTIONAPP_PACKAGE_PATH: '.' # set this to the path to your web app project, defaults to the repository root
  DOTNET_VERSION: '3.1.301'  # set this to the dotnet version to use

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
    - name: 'Checkout GitHub Action'
      uses: actions/checkout@v2

#>>> Added login
    - name: 'Login via Azure CLI'
      uses: azure/login@v1
      with:
        creds: ${ { secrets.AZURE_RBAC_CREDENTIALS } }
#<<<

    - name: Setup DotNet ${ { env.DOTNET_VERSION } } Environment
      uses: actions/setup-dotnet@v1
      with:
        dotnet-version: ${ { env.DOTNET_VERSION } }

#>>> Added test build
    - name: 'Run source unit tests'
      shell: bash
      run: |
        pushd './${ { env.AZURE_FUNCTIONAPP_PACKAGE_PATH } }'
        dotnet test
        popd
#<<<
    
    - name: 'Resolve Project Dependencies Using Dotnet'
      shell: bash
      run: |
        pushd './${ { env.AZURE_FUNCTIONAPP_PACKAGE_PATH } }'
        dotnet build --configuration Release --output ./output
        popd

    - name: 'Run Azure Functions Action'
      uses: Azure/functions-action@v1
      id: fa
      with:
        app-name: 'FunctionCalculator'
        slot-name: 'production'
        package: '${ { env.AZURE_FUNCTIONAPP_PACKAGE_PATH } }/output'
        publish-profile: ${ { secrets.AzureAppService_PublishProfile_fee41ad0921045b1a67961f689821848 } }

#>>> Added endpoint tests
    - name: 'Test endpoint with curl'
      shell: bash
      run: |
        pushd './${ { env.AZURE_FUNCTIONAPP_PACKAGE_PATH } }'
        bash testRunner.sh ${ { secrets.AZURE_FUNCTION_URL } }
        popd
#<<<
```
![error](/img/error-function-action.png)/\
The given template did not work out of the box so I had to remove the configuration in Azure. I also needed to add the login workflow and a json-formatted secret from azure that was generated by CLI.
```shell
az ad sp create-for-rbac --name "FunctionCalculator" --role contributor \
    --scopes /subscriptions/<subscription-id>/resourceGroups/<resource-group> \
    --sdk-auth
```
It should look like below and is added to repo secrets.AZURE_RBAC_CREDENTIALS.
```json
{"clientId": "<GUID>",
  "clientSecret": "<GUID>",
  "subscriptionId": "<GUID>",
  "tenantId": "<GUID>",
  (...)}
```
### Final Git Pipeline
![final pipeline](/img/final-action-function.png)\
All 16 tests passed, great!
### Security
Serverless apps and functions has the same vulnerabilities as other code connected to the internet. I think that the validation of input data and being extra careful with credentials is whats applicable to this assignment.
# References
<https://geekflare.com/know-about-serverless/>\
<https://en.wikipedia.org/wiki/Function_as_a_service>\
<https://github.com/RobinAxelsson/AzureFunctionsDotnetCoreCalculator>