## Cloud Providers overview
https://www.datamation.com/cloud/aws-vs-azure-vs-google-cloud/
### AWS
- Focus on public cloud
- Largest provider
- Global reach
- Could be difficult to use with overwhelming options and complicated cost management
### Azure
- Better on enterprise and hybrid cloud
- Support for open source
- Broad feature set
- Incomplete management tooling
### Google Cloud
- Industry leading tools deep learning and AI
- Strong offering in containers
- Designed for cloud native business
- Commitment to open source and portability
- Fewer features and services

# Web Hosting with Amazon
https://aws.amazon.com/websites/

"whatever CMS you like" Wordpress, Drupal, Joomla
provides SDKs for platforms like Java, Ruby, PHP, Node.js and .Net.
pay-as-you-go or fixed monthly pricing

## AWS Simple Website Hosting
"simple websites normally use:"
- CMS eg WordPress
- eCommerce app eg Magneto
- or a development stack eg LAMP (Linux, Apache, MySQL, PHP)
"simple websites are best for medium traffic with multiple authors and more frequent content changes, such as marketing websites, content websites or blogs.
Low cost, only requires IT-administration of the web server and are not built to be highly scaleable beyond a few servers.

Best for:
- Website built on common applications Wordpress, Joomla, Drupal, Magento
- Popular stacks LAMP, LEMP, MEAN, Node.js
- Unlikely to scale beyond 5 servers
- Customers who want to manage their own web server(s) and resources
- Customers who want to console to mange their web server, DNS, and networking

**Recommended Product: Amazon LightSail**

includes:
- a VM
- SSD-based storage
- data transfer
- DNS management
- static IP

## Single Page Web App Hosting
As we know one load, backend data from API (Graph QL or REST), high performance.
Best for:
React JS, Vue JS, Angular JS and Nuxt
Static site generators Gatsby JS, react-static, jekyll, hugo
Progressive web apps (native performance! mobile! single code page)
pwa - qualify fast and accessible, work offline (use serviceworkers if browser supports it), cache urls in app view offline, manifest.json - fully qualify in lighthouse
website that not contain server side scripting, like php or ASP.NET
Websites that have server-less backends.

**AWS Amplify Console**
- continuous deployment on every code commit
- Deploys with CDN (Content Delivery Network), Amazon CloudFront (increases speed with local cache)
- Custom domain
- feature branch deployments