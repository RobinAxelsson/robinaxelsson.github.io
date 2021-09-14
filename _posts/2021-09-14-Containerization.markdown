---
layout: post
title:  "Containerization"
date:   2021-09-14 19:00:00 +0200
categories: cloud
---

## In this Post we will use docker and GitHub to containerize an ASP.NET Hello World app

### System:
- MacOS Big Sur Version 11.5.2
- Visual Studio Code
  - Docker Extension
- macOS shell
- Docker Desktop Version 4.0.0
  - Docker CLI

### Docker installation
I tried a in a few ways to install docker CLI with Homebrew (macOS package manager), but in the end it worked when I installed it through the browser, Docker Desktop ships with Docker CLI.

### Setup Test-project ASP.NET
See dotnet CLI commands in last
[blog]({% post_url 2021-09-09-ContinuousIntegration %})

### Generate Docker files
Generated docker files automatically with [Visual Studio Code Docker Extension](https://code.visualstudio.com/docs/containers/overview)
```shell
├── Dockerfile
├── docker-compose.debug.yml
├── docker-compose.yml
```
### Dockerfile
The dockerfile is the blueprint of the image and it always starts from another image.\
Commands:\
FROM - points to another docker image to build upon.\
COPY - is a command that copies something from the build environment (host) to inside the container.\
WORKDIR - takes you to that directory, similar to shell "cd /src"\
ENTRYPOINT - Command line arguments that describes where to enter the container, what process to run.
### Working with docker commands
You can either build the docker image from the "Dockerfile" with configuration done with the CLI parameters or build the image pre-configured with the docker-compose file. When I worked with the Dockerfile I used following commands:
```shell
# docker build -t image-name:tag -f <Dockerfile-path> <url>  
docker build -t ASP-IMG:v0.1 -f . .
```
builds image of the Dockerfile blueprint
```shell
docker images
```
Views the image built
```shell

```