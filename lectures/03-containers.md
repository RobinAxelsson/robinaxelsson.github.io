---
layout: lecture
title: Containrar
lectureDate: Måndag den 13:e September 2021
permalink: /cloud-lectures/containers
---

Lektion 3 av 12

Vi har tidigere pratat om containere och Docker, denna lektion kommer att bli litet repitaion på denna snak. Men med fokus på hur vi själv kan bygga en ett docker image och använda det,

## Lektionsplan

{% include lectureplan.html lectureWeek=1 lectureDay=0 lectureCaption="Lektion från kl. 8:30 till kl. 16:30" %}

## Lektionslitteratur
*Detta är material (artiklar, videoer, blogs, podcasts etc) som är den teoretiska bas för denna lektion, det antas att du har läst/set/lystnad detta innan lektionen starter.*

Estimerat samlat "läs"-tid för lektionslittertur är **{{site.data.lecture_containrar.contentTimeTotal.literatureTime}} min** (för den frivilliga fördjupningslitteratur gäller {{site.data.lecture_containrar.contentTimeTotal.optionalLiteratureTime}} min)

{% include lecturenontopics.html lectureData="lecture_containrar" %}
{% include lecturetopics.html lectureData="lecture_containrar" %}

# Övningsuppgifter

ca 30 min
https://ibm.com/cloud/architecture/content/course/kubernetes-101/kubernetes-101




# Övning 1: Bygg en container

Vi har nu en webb applikation som vi vill gör om till en container, och i första vända kunna köra lokalt på vår dator, men i senare övningar få den at köra i molnet.

## Övning 1a: Hello World i Docker

**Mål med denna övning**: Bygg en container som kan hålla Hello World webb applikationen (samma om vi använda i förra lektion). Och få applikationen att köra i Docker, så att du kan komma åt den med webbläsare: localhost:80.

1. Installera Docker på din dator: [Get Docker](https://docs.docker.com/get-docker/)
2. Starta om din dator
3. Klona ner ["Hello world" .NET Core webb applikationen](https://github.com/skjohansen/SimpleWebHalloWorld) 
4. Lägg till en "Dockerfile"
   * Tutorial: [Getting Started With ASP.NET Core & Docker](https://morioh.com/p/5414a74be39d) 
   * Tutorial: [How YOU can Dockerize a .Net Core app](https://softchris.github.io/pages/dotnet-dockerize.html)
5. Bygg din container
6. Kör din container

Hints:

* Ni kan behöva att se över port mapningen
* Ni kan behöva att byta base-image i förhållande till tutorials
* Mindre kod ändringar kan behövas

Blogg:

* Se till att beskriva dom olika delar av container filen

## Övning 1b: Hello World med Docker Compose

Ni har nu en Docker container som innehåller vår Hello World applikation

**Mål med denna övning**: Gör en Docker compose fil som kan köra din nya Hello World-Docker container 

1. Skåpa en `docker-compose.yml` fil som beskivar hur eran docker container ska köras
	* [Get started with Docker Compose](https://docs.docker.com/compose/gettingstarted/)
	* [A Practical Introduction to Docker Compose](https://hackernoon.com/practical-introduction-to-docker-compose-d34e79c4c2b6)
2. Starta eran applikation med `docker-compose up`

Docker Compose är speciellt smidigt för lokala utvecklingsmiljö vart man har behov av flera containers (services) jobbar ihop i en applikation. I detta exempel är där endast en service så där finns inte ett jätte behov av en compose fil, men så fort applikationen växer blir den relevant.

**OBS**: Ni kommer inte att använda denna compose fil mer i denna övning

# Övning 2: Publicera Hello World container image

Ni har nu en Docker container som innehåller vår Hello World applikation (och en Docker Compose definition).

**Mål med denna övning**: Är att skåpa ett Docker image och publicera det till "Github packages" eller "Azure container registry". Ni väljer själv vilken av dom två system ni vill använda.

Hints:

* [Docker + GitHub Package Registry](https://medium.com/@sujaypillai/docker-github-package-registry-9e805f16feab)
* [Configuring Docker for use with GitHub Packages](https://docs.github.com/en/packages/using-github-packages-with-your-projects-ecosystem/configuring-docker-for-use-with-github-packages)
* [Create a private container registry using the Azure CLI](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-get-started-azure-cli)
* Video (11 min): [Create a .Net Core Docker Container and Deploy it to Azure](https://www.youtube.com/watch?v=q8nXv56gWms) (denna video innehåller också en demo på hur man konfigurera en webservice detta ska ni såklart det bort ifrån)
* Video (22 min): [How to Deploy Containers cheaply to Azure](https://www.youtube.com/watch?v=2hokqjFr22s) (denna video rör fler olika ämnen så ta enbart dom delar som är relevanta för denna övning)

**OBS**: Detta behövs för att kunna hosta ert image på en annan maskin eller server (man måste kunna komma åt imaget från internet).

Ni kan nu testa att köra ert image via [Play with Docker](https://labs.play-with-docker.com/), beskriv också detta i eran blogg.

* Starta en ny instans
* Pull ert image från Github Package eller Azure Conatainer Registry
* Kör ert image och testa det

# Övning 3: Deploy och kör Hello World containrar

Ni har nu skåpat ett Docker image som ligger tillgängligt på internet (äntlig på Github eller Azure), och denna övning handlar om att få vår container att köra någon stans i molnet.

Där finns många sätt at få den att köra i Azure och vi kommer att träna två ACI och AKS. Vart AKS är det mer avancerade variant. 


# Individuell inlämningsuppgift
## Blogg post

Gör ett nytt inlägg på din blog som du gjorde i samband med lektion 1. Det rekomenderas att skriva på samma språk som din första blogg post.

Deadline på PingPong, XXdag den XX:e XXX kl 23:55. Posta ett länk till dagens blog post.

Skriv ett blogg post som följer denna lektion ska innehålla en text som svara på dissa frågor:
* 1
* 2

Om du vill kan du nu välja att dela denna blogpost på sociala media (Linked, Twitter, Facebook etc.) kom ihåg att använda lämpliga hashtags som: #1 #2

Skriv en tutorial i stil med dissa ([1](https://softchris.github.io/pages/dotnet-dockerize.html) eller [2](https://morioh.com/p/5414a74be39d)), men vart i stället ta utgångspunkt i dissa övningar, lägg gärna till litet teori (vad är en container etc).

* Vad har in installerat
* Hur har ni fått applikationen att kör i en container
* Vad innehåller ern Docker Compose
* Hur fick ni upp Containeren i Azure Container Instance
* Hur fick den den att funka i AKS

*OBS* Akta vad ni skriver i eran blogg, så att ni inte skriver lösenord etc.

