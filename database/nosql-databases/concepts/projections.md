---
hidden: true
---

# Projections

## About

In NoSQL databases, **projections** refer to the ability to retrieve only specific fields or parts of a document or record during a read operation. Rather than returning the entire data object, projections allow clients to **selectively fetch** only the data they actually need.

This concept is especially important in document stores like **MongoDB**, but it also applies more broadly across other NoSQL systems that support field-level access—such as **Cassandra**, **DynamoDB**, or **ElasticSearch**.

For example, instead of retrieving an entire customer document with dozens of nested fields, a projection might retrieve only the customer’s name and email address.

This selective retrieval provides several important advantages:

* **Reduces data transfer size** over the network.
* **Improves query performance** by avoiding unnecessary disk I/O.
* **Enhances security and privacy** by hiding sensitive or irrelevant fields.
* **Simplifies application logic** by returning only what’s needed.

Projections align well with NoSQL's flexible schema and nested data structures, enabling efficient access patterns tailored to specific use cases.

## How Projections Work ?

