---
layout: post
title:  "Continuous Integration CI"
date:   2021-09-09 19:00:00 +0200
categories: cloud
---

## Definition

"Continuous integration (CI) is a software development practice in which developers merge their changes to the main branch many times per day. Each merge triggers an automated code build and test sequence, which ideally runs in less than 10 minutes. A successful CI build may lead to further stages of continuous delivery."

*Marko Anastasov , co-founder of Semaphore*

## Assignment
*Implement a CI-pipeline with a GiHub Action workflow, using a .NET application (on GitHub).*

### Project files overview
```shell
├── .github
│   └── workflows
│       └── dotnet-desktop.yml
├── .gitignore
├── .vscode
│   └── settings.json
├── CI-Net-solution.sln
├── ConsoleApp
│   ├── ConsoleApp.csproj
│   ├── Program.cs
│   ├── bin
│   │   ├── Debug
│   │   └── Release
│   └── obj
│       ├── ConsoleApp.csproj.nuget.dgspec.json
│       ├── ConsoleApp.csproj.nuget.g.props
│       ├── ConsoleApp.csproj.nuget.g.targets
│       ├── Debug
│       ├── Release
│       ├── project.assets.json
│       ├── project.nuget.cache
│       └── ref
├── README.md
└── Tests
    ├── Tests.csproj
    ├── UnitTest.cs
    ├── bin
    │   ├── Debug
    │   └── Release
    └── obj
        ├── Debug
        ├── Release
        ├── Tests.csproj.nuget.dgspec.json
        ├── Tests.csproj.nuget.g.props
        ├── Tests.csproj.nuget.g.targets
        ├── project.assets.json
        └── project.nuget.cache
```
## CI/CD Pipeline
![Image](https://wpblog.semaphoreci.com/wp-content/uploads/2020/11/ci-and-delivery-pipeline-1024x943.png)

The above image describes the steps from new code til deployment. The idea is to automate every possible step along "the pipe" so that the software can have many small releases that all can be tracked and tested under version control. ***The part of the pipe mapped to Continuous integration is the CI-pipe and this is what the assignment is about.***
## GitHub Actions
  GitHub Actions is event driven code/macro/script that executes on a remote server *inside the given GitHub repo*. You configure the Action inside a yaml-file under .github/workflows directory (See following source).
  
  Basically, first you define on what event, then the jobs to run, inside the jobs you write what you need in terms of os and runtime - then executes your scripts with the command line interface (as if it was your computer running a terminal).
  
  Then after the script is committed to the repo GitHub will listen on the events that was registered and when invoked start the server, checkout the repo/workspace and run the scripts.

## Yaml configuration file
On GitHub inside your repo you can choose:
-> GitHubActions
-> New workflow
-> Choose a template or custom

This creates a yaml configuration file that configures the GitHub Actions. In our case it defines the CI pipeline for our .NET-project. You need to know the build CLI commands of your framework/compiler to be able to configure the scripts.

```yaml
name: Manage .NET Project

on: # adding eventlisteners
  push: # event
    branches: '**' # event triggered when "git push" from any branch
    
jobs:

  build:

    strategy:
      matrix:
        configuration: [Release]

    runs-on: ubuntu-latest # What O/S to use on the server

    env: # repo paths
      Solution_Name: CI-Net-solution.sln
      Test_Project_Path: Tests\Tests.csproj

    steps:
    - name: Checkout # checks out our repo to the VM workflow
      uses: actions/checkout@v2
      with:
        fetch-depth: 0
        
    - name: Build Project
      run: dotnet build
      
    - name: Execute Unit-tests
      run: dotnet test --no-build
    
    - name: Publish App
      run: dotnet publish -c Release --no-restore
```
## .NET CLI
From the dotnet-SDK we use the following commands in our pipe:
```shell
dotnet restore
```
Checking that the packages and dependencies are present and if not installs them before build/publish (runs automatically with build and publish).
```shell
dotnet build
```
Runs dotnet restore then compiles the source code to Intermediate Language (IL) binaries and makes it runnable locally.
```shell
dotnet test --no-build
```
Runs all the projects unit tests if registered in solution file, skipping to build again.
```shell
dotnet publish -c Release 
```
Compiles source but also compiles all the dependencies. The app can now be deployed on other systems. The flag -c means configuration and Release is the configuration. -> the command compiles to the release folder instead of publishing to debug.

[Microsoft .NET CLI Docs](https://docs.microsoft.com/en-us/dotnet/core/tools/)

## Author Reflection
CI is a straight forward practice but you need to know what tools to use and you need to be comfortable with the command line interfaces. As always I believe it comes down to the developers and the culture of the team/company to implement these practices that are easily said then done.