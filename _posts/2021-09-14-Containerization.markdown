---
layout: post
title:  "Containerization"
date:   2021-09-14 19:00:00 +0200
categories: cloud
---

## In this post we will use docker and GitHub to containerize an ASP.NET Hello World app

### What is a container?
A container is an application packaged with its own runtime environment. Like a shipping container it is standardized and modular to scale and be reused and shipped easily. Compared to virtual machines a container doesn't virtualize hardware and allocates memory, a container is therefor more flexible and more lightweight. Instead of an hypervisor the container runs by a container engine/runtime and is built from an container-image which in turn is built from an manifest file (in our case the Dockerfile).

Note that even if the containers have an isolated environment you can open and map ports (in the same sense as you open ports with any OS) for communicating with the outside environment. As a side note you can even bash into an containers command-line from the host machine.

There are a few different container technologies but for this assignment Docker is used.
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
In this project I have based the workflow on the docker-publish.yml which is one of the GitHub [starter-workflows.](https://github.com/actions/starter-workflows/blob/dda42cb8f2514b6ee4e8cc0a860512821ffaa9f7/ci/docker-publish.yml)
Its good to note that there are a lot of workflows to use for different scenarios and it is probably most efficient to start off with a given workflow/action. If you're looking for a workflow, search on the GitHub [Marketplace](https://github.com/marketplace?type=actions) where you can find all kinds.

```yaml
name: Docker-Modified
# Simplified the event trigger to on push
on:
  push
env:
  REGISTRY: ghcr.io # A container registry by github
  IMAGE_NAME: ${ { github.repository } } # Repository name variable

jobs:
  build:

    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      # Login against a Docker registry
      # https://github.com/docker/login-action # the repo for the action
      - name: Log into registry ${ { env.REGISTRY } }
        if: github.event_name != 'pull_request'
        uses: docker/login-action@28218f9b04b4f3f62068d7b6ce6ca5b26e35336c
        with:
          registry: ${ { env.REGISTRY } }
          username: ${ { github.actor } }
          password: ${ { secrets.ASP_NET_DOCKER } } # see secrets below

      # Extract metadata (tags, labels) for Docker
      # https://github.com/docker/metadata-action
      - name: Extract Docker metadata
        id: meta
        uses: docker/metadata-action@98669ae865ea3cffbcbaa878cf57c20bbf1c6c38
        with:
          images: ${ { env.REGISTRY } }/${ { env.IMAGE_NAME } }

      # https://github.com/docker/build-push-action
      - name: Build and push Docker image
        # uses keyword points to another workflow inside a github repository
        uses: docker/build-push-action@ad44023a93711e3deb337508980b4b5e9bcdc5dc
        with:
          # inparameters for the external workflow (defined in the repo action.yml file)
          context: .
          push: ${ { github.event_name != 'pull_request' } }
          tags: ${ { steps.meta.outputs.tags } }
          labels: ${ { steps.meta.outputs.labels } }
```


### Secrets
In the yaml above we have a few variables that hides secrets and tokens. For example:
```yaml
password: ${ { secrets.ASP_NET_DOCKER } }
```
This secret variable is stored inside the repository on GitHub and can be added through Repository -> Settings -> Secrets -> New Repository secret.\
![action secrets](/img/action-secrets.png)\
\
But we also need to generate them ourselves through our personal GitHub profile -> settings -> developer settings -> personal access token -> New personal access token.
![new token](/img/new-PAT.png)\
\
For publishing a container to the GitHub Registry we need to create a token that has write:packages Scope.

### Handling Tokens

To protect the secrets from entering logs and even being visual on screen I added the token inside my macOS keychain that needs an elevated password to retrieve them. I retrieve them to clipboard and pipe them as standard input to the command like below.
```shell
pbpaste | docker login ghcr.io --username <github-user-name> --password-stdin
# macOS command pbpaste pipes what contained in clipboard to std.in to next command
```
# References
[WTF is a container?](https://techcrunch.com/2016/10/16/wtf-is-a-container/?guce_referrer=aHR0cHM6Ly9wZ2JzbmgyMC5naXRodWIuaW8v&guce_referrer_sig=AQAAAE6RaDv_1OocX76Tu6g7PpP7pCYnRZMJvmn8zEaUt7OAQySmUMUY19J2WZPbFKkhbpuFfFAjl32XfEA2k7opGhEKChxV2hw0Y_PtcJqYB6bPXRqqKqKo3ddG3JpgDJpwSWsBJTJ3WpQDPqMFpfzPs2sNofI1Q6la2cr20IeU6Y1f) Article, 4 min\
[Containerization Explained](https://www.youtube.com/watch?v=0qotVMX-J5s) video, 8 min