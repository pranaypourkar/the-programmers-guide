# CRUD Operations

## About

CRUD stands for **Create, Read, Update, and Delete -** the four fundamental operations used to manage and manipulate data in any database system. While the term originates from traditional relational databases, the concept applies just as strongly to NoSQL databases, though the implementation and behavior of these operations often differ significantly.

In the NoSQL world, CRUD operations are tailored to the nature of the underlying data model - whether it’s **document-based**, **key-value**, **column-family**, or **graph-based**. Because many NoSQL systems prioritize scalability and flexibility, CRUD operations may be **eventually consistent**, **schema-less**, or **optimized for specific access patterns**.

Understanding how each NoSQL database handles CRUD operations is essential for:

* **Modeling data effectively** based on use case.
* **Designing scalable APIs** that map naturally to backend behavior.
* **Optimizing read/write performance** for real-time applications.

Each CRUD operation comes with its own considerations - such as atomicity, concurrency control, indexing, and support for partial updates - which vary widely across NoSQL systems.

## Create

The **Create** operation is used to **insert new data** into a NoSQL database. Unlike traditional relational databases, where new records must conform to a predefined schema, NoSQL databases often allow for **schema-less** or **flexible-schema** inserts. This provides greater freedom in how data is structured, particularly in document stores and key-value databases.

Create operations are central to many real-time, high-throughput applications such as logging systems, user activity tracking, IoT platforms, and content publishing systems where new data is written frequently and at scale.

#### **How It Works (Depending on the Model) ?**

**1. Document Stores (e.g., MongoDB, Couchbase)**

* Documents are inserted as JSON or BSON objects.
* Each document typically has a unique key (`_id` in MongoDB).
* New fields can be added without altering any schema.

**Example (MongoDB)**

```js
db.users.insertOne({
  name: "Alice",
  email: "alice@example.com",
  createdAt: new Date()
});
```

**2. Key-Value Stores (e.g., Redis, DynamoDB)**

* Data is stored as a key-value pair.
* The value can be a primitive, string, binary, or structured object (like JSON).
* Keys must be unique; inserting a new value with an existing key may overwrite or fail based on configuration.

**Example (Redis)**

```bash
SET user:1001 "{ \"name\": \"Alice\", \"email\": \"alice@example.com\" }"
```

**3. Column-Family Stores (e.g., Cassandra, HBase)**

* Rows are inserted by specifying a partition key and column values.
* Columns can be added dynamically at insert time.

**Example (Cassandra)**

```sql
INSERT INTO users (user_id, name, email)
VALUES ('1001', 'Alice', 'alice@example.com');
```

**4. Graph Databases (e.g., Neo4j)**

* New nodes and relationships are created using a graph-specific syntax.
* Nodes can be labeled and contain properties; relationships define how nodes are connected.

**Example (Neo4j)**

```cypher
CREATE (a:User {name: "Alice", email: "alice@example.com"})
```

## Read

The **Read** operation retrieves data from a NoSQL database based on specific criteria such as keys, filters, queries, or graph traversals. While the essence of reading data remains the same across database types, NoSQL systems offer a variety of read strategies optimized for **high performance**, **flexibility**, and **distributed environments**.

Read operations can be simple (e.g., get-by-key in a key-value store) or complex (e.g., filtering documents by nested attributes in a document store or querying paths in a graph database).

#### **How It Works (Depending on the Model) ?**

**1. Document Stores (e.g., MongoDB, Couchbase)**

* Documents are queried using flexible query languages (often JSON-based).
* Support for filters, field projections, nested querying, and aggregations.

**Example (MongoDB)**

```js
db.users.find({ name: "Alice" }, { email: 1, _id: 0 });
```

This returns only the `email` field of users named "Alice".

**2. Key-Value Stores (e.g., Redis, DynamoDB)**

* Reads are typically key-based (fast and predictable).
* Range reads or prefix reads may be supported depending on the system.

**Example (Redis)**

```bash
GET user:1001
```

**Example (DynamoDB)**

```js
docClient.get({
  TableName: "Users",
  Key: { userId: "1001" }
});
```

**3. Column-Family Stores (e.g., Cassandra, HBase)**

* Reads are based on partition keys and optional clustering keys.
* Column selection allows reading only specific attributes.

**Example (Cassandra)**

```sql
SELECT name, email FROM users WHERE user_id = '1001';
```

**4. Graph Databases (e.g., Neo4j)**

* Reads involve traversing relationships using pattern-matching queries.

**Example (Neo4j)**

```cypher
MATCH (a:User {name: "Alice"})-[:FRIEND_OF]->(b:User)
RETURN b.name;
```

## Update

The **Update** operation modifies existing data in a NoSQL database. Unlike traditional relational systems, NoSQL databases often allow for **partial updates**, **atomic field-level changes**, and **dynamic field addition**, all without requiring a fixed schema. This flexibility is a key advantage, especially in fast-changing or evolving data environments.

Update operations vary depending on the data model - some are document-oriented and support deep-field manipulation, while others require updating the entire value associated with a key.

#### **How It Works (Depending on the Model) ?**

**1. Document Stores (e.g., MongoDB, Couchbase)**

* Supports field-level updates and modifiers (`$set`, `$inc`, `$unset`, etc.).
* Documents can be updated partially without replacing the entire document.

**Example (MongoDB)**

```js
db.users.updateOne(
  { _id: "1001" },
  { $set: { email: "new_email@example.com" } }
);
```

**2. Key-Value Stores (e.g., Redis, DynamoDB)**

* Typically replace the entire value unless the system supports structured data updates.
* In DynamoDB, specific attributes can be updated without replacing the full item.

**Example (DynamoDB)**

```js
UpdateExpression: "SET email = :e",
ExpressionAttributeValues: {
  ":e": "new_email@example.com"
}
```

**Example (Redis)**

```bash
SET user:1001 "{ \"email\": \"new_email@example.com\" }"
```

(This replaces the entire value.)

**3. Column-Family Stores (e.g., Cassandra, HBase)**

* Allows updates to specific columns within a row.
* Automatically creates the row if it doesn't exist (upsert behavior).

**Example (Cassandra)**

```sql
UPDATE users SET email = 'new_email@example.com' WHERE user_id = '1001';
```

**4. Graph Databases (e.g., Neo4j)**

* Nodes or relationships can be updated using `SET`, `REMOVE`, or `MERGE`.

**Example (Neo4j)**

```cypher
MATCH (u:User {userId: "1001"})
SET u.email = "new_email@example.com"
```

## Delete

The **Delete** operation removes data from a NoSQL database. This could be an entire record (document, row, node, key) or specific parts of a record (fields, columns, relationships). Deletion behavior depends on the NoSQL model and the consistency, replication, or versioning settings of the database.

While deletes may seem simple, they can be **logically complex in distributed systems**, especially under **eventual consistency**, where deleted data may temporarily persist on some replicas before being fully purged.

#### **How It Works (Depending on the Model) ?**

**1. Document Stores (e.g., MongoDB, Couchbase)**

* Allows deleting entire documents or matching subsets.
* Bulk deletes can be applied with filters.

**Example (MongoDB)**

```js
db.users.deleteOne({ _id: "1001" });
// or
db.users.deleteMany({ status: "inactive" });
```

**2. Key-Value Stores (e.g., Redis, DynamoDB)**

* Deletes are typically key-based.
* Some stores also allow deleting specific attributes from a value.

**Example (Redis)**

```bash
DEL user:1001
```

**Example (DynamoDB)**

```js
docClient.delete({
  TableName: "Users",
  Key: { userId: "1001" }
});
```

**3. Column-Family Stores (e.g., Cassandra, HBase)**

* Allows deletion of entire rows or specific columns within a row.
* Deletions often use **tombstones**, marking the data as deleted for later cleanup.

**Example (Cassandra)**

```sql
DELETE FROM users WHERE user_id = '1001';
```

**Delete a specific column**

```sql
DELETE email FROM users WHERE user_id = '1001';
```

**4. Graph Databases (e.g., Neo4j)**

* Requires explicit deletion of nodes and/or relationships.
* Relationships must be deleted before the node itself can be removed.

**Example (Neo4j)**

```cypher
MATCH (u:User {userId: "1001"}) DETACH DELETE u
```
