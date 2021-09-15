---
layout: post
title:  "Serverless Applications"
date:   2021-09-14 19:00:00 +0200
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

# References
https://geekflare.com/know-about-serverless/
https://en.wikipedia.org/wiki/Function_as_a_service