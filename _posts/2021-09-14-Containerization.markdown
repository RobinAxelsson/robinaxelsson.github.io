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
### Working with Docker Commands
You can either build the docker image from the "Dockerfile" with configuration done with the CLI parameters or build the image pre-configured with the docker-compose file. When I worked with the Dockerfile I used following commands:
```shell
# docker build -t image-name:tag -f <Dockerfile-path> <url>  
# builds image of the Dockerfile blueprint
docker build -t ASP-IMG:v0.1 -f . .
```
```shell
docker images
# use to get image id|name
```
```shell
# docker container run -p <host-port>:<container-port> --name <new-container-name> <image>
# Creates and starts a container with port mapped to host port.
docker container run -p 8080:5000 --name asp-container ASP-IMG
```

```shell
docker ps
# display running containers
```
```shell
# To check the web-app is running
curl http://localhost:8080/
#$ Hello World!%
```
### Configuring with docker-compose
Docker compose is a configuration file that simplify the creation of an image from a Dockerfile. Instead of long commands like the "docker container run -p..." command above you can edit the docker-compose file and simply run:
```shell
docker-compose up
```
This helps the automation of the image build but also shows intent of the developer. Following yaml is from the repos docker-compose.yml
```yml
version: "3.4"

services:
  asphelloworlddocker:
    image: asphelloworlddocker
    build:
      context: . # this states the directory of compose-file
      dockerfile: ./Dockerfile # path to Dockerfile
    ports:
      - 8080:5000
```

### GitHub Pipeline
![image actions](/img/ghactions2.png)

### Secrets
When it comes to using tokens, we can predefine token-variables on GitHub that is available to the GitAction Runner.
To protect them from entering logs and even being visual on screen I added the token inside my macOS keychain that needs an elevated password to retrieve them. I retrieve them to clipboard and pipe them as standard input to the command I need.
```shell
pbpaste | docker login ghcr.io --username <github-user-name> --password-stdin
# macOS command pbpaste pipes what contained in clipboard to std.in to next command
```