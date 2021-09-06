---
layout: lecture
title: Internet och moln
lectureDate: Måndag den 6:e September 2021
permalink: /cloud-lectures/introduction
---

Lektion 1 av 12

I denna lektion börjar vi med en repetition av dom teori-delar ni har haft tidigere kurs som rör denna kurs, dock byggar hela kursen på primärt webbutveckling backend.

Utover repetition av speciellt nätverksteori, kommer vi att prata mere om molnet, vad är det och vad kan det.

## Lektionsplan

{% include lectureplan.html lectureWeek=0 lectureDay=0 lectureCaption="Lektion från kl. 8:30 till kl. 16:30" %}

## Lektionslitteratur
*Detta är material (artiklar, videoer, blogs, podcasts etc) som är den teoretiska bas för denna lektion, det antas att du har läst/set/lystnad detta innan lektionen starter.*

Estimerat samlat "läs"-tid för lektionslittertur är **{{site.data.lecture_internet_och_moln.contentTimeTotal.literatureTime}} min** (för den frivilliga fördjupningslitteratur gäller {{site.data.lecture_internet_och_moln.contentTimeTotal.optionalLiteratureTime}} min)

{% include lecturenontopics.html lectureData="lecture_internet_och_moln" %}
{% include lecturetopics.html lectureData="lecture_internet_och_moln" %}

# Övningsuppgifter med buddy

Gå tillsammans två och två (kanske tre, men helst två)

## Pris uppgift

Ta fram prisen per månad för en virtuell server hos olika moln operatör.

* Azure: [Pricing calculator](https://azure.microsoft.com/en-us/pricing/calculator)
* AWS: [Calculator](https://calculator.aws/)
* Google Cloud: [Pricing Calculator](https://cloud.google.com/products/calculator/)
* etc

Hitta en eller fler hosting företag (svenska, nordiska eller inom EU), och sammanhåll prisen med dom stora jätterna (Azure, AWS och Google).

Hitta priset för att drifta en server (24x7x365), tänk att servern ska köra en simple websida med en enkel databas, alt installerat på samma server. Kanske krävs 2 CPUs, 8GB RAM och 10 GB disk på en Linux server i Europa.

# Indviduella övningsuppgifter

## Kurs om huvudprinciperna bakom molntjänster

Gå igenom denna kurs (62 min): [Molnbegrepp – principerna bakom molnbaserad databehandling](https://docs.microsoft.com/sv-se/learn/modules/principles-cloud-computing/)


## Skåpa en blogg på GitHub med Jekyll

GitHub gir möjlighet till att skåpa en "page" för vilket som helst repository, man kan även skåpa en page for en profil eller oganization, och det är det du ska i denna övning.

Tanken är du ska skåpa en egen websita/blog med hjälp av GitHub, så om du har GitHub-använder *123koder*, kommer din nya websita/blog att finnas på *123koder.github.io*, man kan även knyta ett äget domännamn (eller subdomän) till en GitHub-page.

PS. om du redan har en GitHub page för din profil (eller av något skäll inte önskar att använda din profil page till detta), skåpa ett nytt repo för denna blogg

Gör följande:
* Gå till: [Websites for you and your projects](https://pages.github.com/)
* Följ instruktionen
* Testa din nya Hello World sida
* Nu är det dags för innehåll. Installera [Jekyll](https://jekyllrb.com/docs/) lokalt i Windows eller i WSL.
* Följ guiden, kommandon `jekyll new` gir dig en helt grundläggand blogg
* Styla din nya blogg med en Jekyll mall, där finns en del gratis maller på: [Free Jekyll Themes](https://jekyllthemes.io/free)

# Individuell inlämningsuppgift

Inlämnas via PingPong, men sparas i GitHub

## Blogg post

**Deadline** för inlämning via PingPong, Tisdag den 07:e September kl 23:55. Posta ett länk till dagens blog-post i PingPong inlämningen.

Skriv din blogg på Svenska eller Engelska.

Skriv ett blogg post som följer denna lektion ska innehålla en text som svara på dissa frågor:
* Vad är molnet?
* Vilka för delar och nackdelar kan molnet introducera?
* Din konklussion av eran pris undersökning

Om du vill kan du nu välja att dela denna första blogpost på sociala media (Linked, Twitter, Facebook etc.) kom ihåg att använda lämpliga hashtags som: #cloud #azure #myfirstblog #pricing #moln