---
layout: post
title:  "Network in the cloud"
date:   2021-09-29 11:00:00 +0200
categories: cloud, network
---

### Assignment
Today we will have a more theoretical blog post, no code or project will be present. Instead we are going to discuss a case where we are working on a company with an internal app that we want to modernize. This application uses internal servers and resources, and handles classified data that can't openly be sent over the internet. 

We want to implement an enterprise bus (Azure Service Bus), but our CTO says no because as mentioned the data can't be sent publicly. The assignment is therefor to convince our CTO and inform him/her about the available technologies to solve this problem (in the extension it will allow us developers to use more Azure PaaS services):
- Azure Private Link
- Azure Service Bus
- Virtual Privat Cloud

Hello mr CTO,

After listening to your directives according to keep security high on discussed data transfer, we have an suggestion of a solution to that, but also your other directives of being agile and flexible in our software systems are taken into consideration.

If we just imagine a service where we can extend our company network to the cloud without touching the public internet. With a cross premise Azure Virtual Network (since we are a .NET team) we can do just that and this lays the ground for more opportunities.

![network](/img/network.png)

The Service Bus we discussed earlier which was a bad idea to implement in our current network but with a vNET we can place the bus right in there if we use an Azure Service Bus. As you mentioned this morning we want our customer experience to be consequent, and satisfactory. With a service bus we can decouple our services and migrate towards micro services, for instance the email-client won't be dependent on the database, if there is downtime or a glitch the tasks will still stay in the Service Bus queue. 

So how to connect to our virtual network, how do we make it secure? Azure has also a service called Private Link that allows for secure connection through Microsofts own network to our virtual network, between different services, it will never see the public internet. We can also use this service for delivery directly to our customers.

So the proposal is to build our services in the cloud from ground up, this will simplify all our jobs, save time and to a lower cost. With a virtual private cloud as a developer platform we have more opportunity and easier to achieve this years goals.

Regards, Developer 143

[What is Azure Service Bus?](https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-messaging-overview)

[What is Azure Private Link?](https://docs.microsoft.com/en-us/azure/private-link/private-link-overview)

[Connect an on-premises network to a Microsoft Azure virtual network](https://docs.microsoft.com/en-us/microsoft-365/enterprise/connect-an-on-premises-network-to-a-microsoft-azure-virtual-network?view=o365-worldwide)