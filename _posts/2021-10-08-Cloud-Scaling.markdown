---
layout: post
title:  "Cloud Scaling"
date:   2021-10-08 11:00:00 +0200
categories: cloud, network
---

![monitor](/img/monitor.png)

### Assignment

In todays post we will examine scaling and calculate the prize of scaling, first in an Azure App Service and second a virtual machine. The [Azure Prizing Calculator]() will be used.

### Scaling

In cloud development the concept of scaling is quite important. When your app leaves the development stage and hits production the load on the application and its hardware will be very different, probably a lot more requests a lot more data processing, maybe some daily peaks, maybe monthly or yearly. Sometimes there is no traffic or you might need to release a new version. If your application (and the underlying software/hardware infrastructure) is running smoothly in all the different challenges thrown on it, your app is *resilient*. You should always strive for a resilient app (at least relative to the domain your app is operating in).

So where does scaling come into the picture? If your app can scale up/down, in/out after the different loads and amount of requests it will automatically have high resilience. Scaling up means that the VM(s) that you already using are boosting up their hardware (see picture below). Scaling out means that additional servers/VM:s are added. Needless to say reverse applies for scale in and scale down.

![scaling](/img/Scaling.png)

Before cloud services it was not easy to have flexible scaling for your application, now it is possible but we need to be careful, it is always more cost to have an always running, always ready for traffic peaks -application.

## Scaling an Virtual Machine (VM)

There are a lot of different virtual machines in Azures product catalog. I chose the D-series because it is [described as a "General purpose compute" VM.](https://azure.microsoft.com/en-us/pricing/details/virtual-machines/series/) More specifically we compare D1, D2, D3, D4, D5.

![vm-table](/img/vm-table.png)

![vm-scatters](/img/vm-scatters.png)

If we compare scaling hardware against scaling instances we get the following table where I compare the price of having the same compute power in separate D1:s or scaling up the D1 to D2, D3 etc (prize is still dollars per hour).

![compare-scaling](/img/compare-scaling.png)

According to this data from Azure the prize is quite proportional - the prize difference in scaling up or out is minimal (at least in our D-series sample).

## Scaling an Azure App Service

![appservice-prizing](/img/appservice-prizing.png)

Data table from [AppService prizing](https://azure.microsoft.com/en-us/pricing/details/app-service/windows/). You can buy different types of app-service or Tires and not all have the same possibilities to scale. Tier Standard and above implements auto-scaling which is the most simple way to handle scaling. You can predefine rules for when and how your app should scale in the App Service Plan.

![appservice-standard-table](/img/appservice-standard-table.png)

When you scale up an App Service you are limited in what VM-hardware you can choose from. There are a limited number for each Tier type. The example above shows the same relation as the VM-scaling-scatter plots (further above) - we pay for the computing power proportionally. The [pay as you go](https://azure.microsoft.com/en-us/pricing/purchase-options/pay-as-you-go/) payment model makes it possible to have no expense when nothing is running but when scaling horizontally multiplies the prize also proportionally.

So can we compare VM-prize and App Service? Maybe we can, at least comparing the same set of cores and memory side by side.

![app-vm-table](/img/app-vm-table.png)

## Bottom Line

- In Azure, scaling up/out does not make a difference in prize between the two comparing at computing hardware.

- App service is more expensive then the VM in our last comparison and that is to be expected when the App Service abstracts away the Operating System.

- App Service Standard to Premium Tiers with autoscaling is a strong alternative for modern resilient app development.
