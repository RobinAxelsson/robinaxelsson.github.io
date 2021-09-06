Basically, asynchronous applications makes real time communication possible, allowing multiple clients to interact with the server and receive information while interacting with each other.

## Traditional (Synchronous) Applications

Synchronous websites interacts with users behaving on user interactions. Even with the use of AJAX techniques (that makes asynchronous requests), those requests are still generated based on user interaction, so the process remains synchronous. The user trigger a request and once the request have been answered, the communication stops and waits until user's next action.

Example:

> User fills a form in a web application.
> The server responds to the user's requests by returning the data back to the user.
> At this point, the form is updated and the synchronous communication loop is done. A new synchronous communication loop will begin when the user takes another action.

The synchronous application offers poor interaction and is limited due to the lack of instant request updates. Even if it's designed to make automated refreshes from the application server, it's not instant. It couldn't be a problem for most applications where data changes doesn't happen constantly. A news website, for example, could have a synchronous application for their news feed without compromising the user experience.

## Asynchronous Applications

Asynchronous applications enables the client (browser) to react instantly to changes on the server, without compromising the user's experience and delivering spontaneous presentation changes to the user as the state of a dynamic system changes, without the need for the user to interact with the interface, so even with no user's interaction, the server keeps *ready* to response when something new happens.

Some applications relies on real-time server communication and allows multiple requests simultaneously. They need to constantly keep in touch with the server so when data updates happens, the user gets noticed instantly, and each client has its own data updated without compromising other's information.

As an example, real-time applications such as Facebook and Gmail, Slack Web app, or even a simple chat system.