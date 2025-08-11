# Consumers & Providers

## About

Understanding the distinction between **API Consumers** and **API Providers** is essential to working with APIs. APIs are built around the concept of communication between systems—**one side offers a service**, and **the other side uses it**.

## What is an API Provider ?

An **API Provider** is the system or organization that **creates and exposes the API**. It is responsible for:

* **Defining the interface** (what endpoints exist, what parameters they accept, what responses are returned)
* **Hosting the API** (making it accessible over the internet or within an internal network)
* **Implementing business logic** that runs behind the API
* **Securing the API** to ensure only authorized access
* **Maintaining documentation** for others to understand and use the API

#### Examples of API Providers

* Stripe provides payment APIs.
* Twitter provides APIs to post tweets or fetch user data.
* Our own backend service, when exposing REST endpoints to our frontend app.

## What is an API Consumer ?

An **API Consumer** is the **system, application, or developer that uses the API** to access the functionality or data it provides. It **makes requests** to the API endpoints, following the defined contract.

The consumer doesn't need to know how the provider processes the request internally—it only needs to understand how to call the API and handle the response.

#### What Consumers Do

* Construct HTTP requests (with correct method, headers, parameters)
* Parse and use the response data
* Handle errors, retries, and failures
* Follow authentication procedures (like using API keys, tokens)

#### Examples of API Consumers

* A mobile app fetching user data from a backend service.
* A frontend React app calling an internal inventory API.
* A third-party developer integrating Google Maps into their website.

## Example

Let’s say we have an **e-commerce platform**

* The **backend** team builds and publishes APIs for products, orders, and payments → they are the **API providers**.
* The **frontend** team builds a React or Android app that consumes those APIs to show products or place orders → they are the **API consumers**.
