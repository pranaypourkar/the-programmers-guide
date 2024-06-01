# Entity Relationship Diagram (ERD)

## Description

An Entity-Relationship (ER) Diagram is a type of flowchart that visually represents the entities (real-world objects) and their relationships within a database system. It's a conceptual modeling tool that helps database designers understand and plan the structure of a database before they create the physical tables and columns. ER diagrams help to explain the logical structure of databases.

ER diagrams are created based on three basic concepts: <mark style="background-color:yellow;">entities, attributes and relationships</mark>. ER Diagrams contain different symbols. The purpose of ER Diagram is to represent the entity framework infrastructure.

**Entities:** These represent real-world objects or concepts that we want to store information about in the database. They are the core elements within an ER model, typically depicted as rectangles in ER diagrams. Examples of entities could be customers, products, orders, employees, or any relevant objects in your system.

**Attributes:** These define the characteristics or properties of an entity. Each entity has attributes that capture its specific details. Attributes are shown as ovals connected to their corresponding entities in an ER diagram. Examples of attributes for a "Customer" entity might be "CustomerID", "CustomerName", "Email", and "Address".

**Relationships:** These represent the associations or connections between different entities. They are illustrated as diamonds connecting entities in an ER diagram. There are three main types of relationships:

* **One-to-One:** An entity instance in one entity can be linked to only one entity instance in another entity. (e.g., A customer can have one shipping address, and a shipping address belongs to one customer)
* **One-to-Many:** An entity instance in one entity can be related to multiple entity instances in another entity. (e.g., A customer can place many orders, but an order belongs to only one customer)
* **Many-to-Many:** Multiple entity instances in one entity can be associated with multiple entity instances in another entity. (e.g., A course can have many students enrolled, and a student can enroll in many courses)

## Sample ER Diagram

<figure><img src="../../../../.gitbook/assets/one-to-many-erd (1).png" alt=""><figcaption></figcaption></figure>

{% hint style="info" %}
#### What is ER Model?

ER Model, which stands for Entity Relationship Model, is a high-level conceptual data model diagram. ER model helps to systematically analyze data requirements to produce a well-designed database. The ER Model represents real-world entities and the relationships between them. Creating an ER Model in DBMS is considered as a best practice before implementing your database.

ER Modeling helps to analyze data requirements systematically to produce a well-designed database. It is considered a best practice to complete ER modeling before implementing database.
{% endhint %}



## ER Diagrams Symbols & Notations

Entity-Relationship (ER) Diagrams use a specific set of symbols and notations to visually represent the entities, attributes, and relationships within a database. These symbols provide a common language for database designers to communicate and document the structure of a database.

Following are the main components and its symbols in ER Diagrams:

<figure><img src="../../../../.gitbook/assets/image (3) (1) (1) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

### **Entity**:

Represented by a <mark style="background-color:green;">rectangle</mark>. Represents a real-world thing or concept that we want to store information about in the database. Examples include customers, products, orders, or employees.

Entities are further categorized into strong and weak entities based on their dependence on other entities for their existence.

#### **Strong Entity:**

* A self-sufficient entity whose existence doesn't rely on another entity. It has a well-defined identity independent of other entities.
* Strong entities possess a primary key, a unique identifier that can be used to distinguish each instance (row) of the entity within the table. The primary key enforces data integrity and allows for efficient data retrieval.
* **Example of Strong Entity:** \
  **Customer:** In a customer database, the Customer entity would be considered strong. Each customer has a unique identifier (e.g., CustomerID), attributes like name, address, email, etc., and can exist independently in the system without relying on any other entity.

#### **Weak Entity:**

* A dependent entity that partially relies on another entity (strong entity) for its existence. It cannot be uniquely identified by its own attributes alone.
* Weak entities lack a primary key of their own. Instead, they rely on a combination of a foreign key referencing the primary key of the strong entity (called a determinant) and their own unique identifier (often called a partial key) to form a composite identifier.
* **Example of Weak Entity:**\
  **Order Items:** In an order database, the Order Items entity is a weak entity. An order item represents a specific product included in an order. It **cannot exist independently** because it doesn't make sense to have an order item without an associated order. Order Items lack a primary key of their own. They typically have: **Partial Key**: An attribute (or combination of attributes) that uniquely identifies the order item within the context of a specific order. This could be "OrderItemID" or a combination of "OrderID" and a sequence number within that order. **Foreign Key:** A reference to the primary key of the strong entity (Order table) with which it's associated. This is typically the "OrderID" of the customer's order.

| Feature     | Strong Entity                               | Weak Entity                                                |
| ----------- | ------------------------------------------- | ---------------------------------------------------------- |
| Existence   | Independent - exists on its own             | Dependent - relies on a strong entity                      |
| Primary Key | Has a primary key for unique identification | Doesn't have a primary key. Can have a partial key         |
| Identifier  | Uniquely identified by its own attributes   | Identified by a combination of foreign key and partial key |

{% hint style="info" %}
An entity set is a group of similar kind of entities. It may contain entities with attribute sharing similar values.
{% endhint %}

### **Attribute**:

Shown as an <mark style="background-color:purple;">oval or ellipse</mark> connected to its corresponding entity by a line. Represents a characteristic or property of an entity. Each entity will have multiple attributes that define its data points. Examples of attributes for a "Customer" entity might be "CustomerID", "CustomerName", "Email", and "Address".

#### **Types of Attributes**

<table data-full-width="true"><thead><tr><th width="214">Attribute Type</th><th width="335">Description</th><th>Example</th></tr></thead><tbody><tr><td>Simple Attribute</td><td>An atomic (indivisible) unit of data that cannot be further broken down into smaller meaningful units.</td><td><p>-> CustomerID (unique identifier for a customer)  </p><p>-> ProductName (name of a product) </p><p>-> Price (unit price of a product)</p></td></tr><tr><td>Composite Attribute</td><td>A logical group of simpler attributes that together define a single concept.</td><td><p>-> Address (composed of Street, City, State, Zip Code) </p><p>-> FullName (composed of FirstName and LastName) </p><p>-> DateOfBirth (composed of Year, Month, Day)</p></td></tr><tr><td>Derived Attribute</td><td>An attribute whose value is calculated or derived from other attributes in the table.</td><td><p>-> Age (calculated from DateOfBirth) </p><p>-> TotalAmount (calculated by multiplying Price with Quantity) </p><p>-> AverageRating (calculated from individual product ratings)</p></td></tr><tr><td>Multi-valued Attribute</td><td>An attribute that can hold multiple values for a single entity instance.</td><td><p>-> Skills (a customer can have multiple skills) </p><p>-> FavoriteColors (a customer can have multiple favorite colors)</p><p>-> PhoneNumbers (a customer can have multiple phone numbers)</p></td></tr></tbody></table>

### **Relationship**:

Depicted by a <mark style="background-color:blue;">diamond</mark> shape connecting two entities. Represents the association or connection between different entities. There are three main types of relationships denoted differently:&#x20;

\-> **One-to-One (1:1)**: A line is drawn connecting the two diamonds, representing a single instance in one entity relates to a single instance in another entity.&#x20;

\-> **One-to-Many (1:N)**: An arrow points from the "one" entity (crow's foot notation) or a line connects the diamond to the "many" entity (older notation), indicating a single instance in the "one" entity relates to multiple instances in the "many" entity.&#x20;

\-> **Many-to-Many (N:M)**: A separate associative entity (another rectangle) is created between the two entities, typically containing a primary key and foreign keys referencing the related entities. This is used to represent many-to-many relationships because relational databases inherently struggle with this type of relationship.

<figure><img src="../../../../.gitbook/assets/ERD-Notation (1).PNG" alt=""><figcaption></figcaption></figure>

### **Additional Notations:**

* **Primary Key:** An underline or asterisk within an attribute indicates it's the primary key attribute, uniquely identifying each entity instance.
* **Foreign Key:** An attribute (or combination of attributes) that references the primary key of another entity. Often denoted by a dotted line connecting the foreign key attribute to the primary key it references.

## Cardinality

It refers to the number of occurrences of an entity in a relationship. It describes how many instances of one entity relate to how many instances of another entity.

<figure><img src="../../../../.gitbook/assets/image (92).png" alt=""><figcaption></figcaption></figure>

Here are the different types of cardinal relationships:

* **One-to-One (1:1):** An entity instance in one entity can be linked to only one entity instance in another entity. (e.g., A customer can have one shipping address, and a shipping address belongs to one customer)
* **One-to-Many (1:N):** An entity instance in one entity can be related to multiple entity instances in another entity. (e.g., A customer can place many orders, but an order belongs to only one customer)
* **Many-to-Many (N:M):** Multiple entity instances in one entity can be associated with multiple entity instances in another entity. (e.g., A course can have many students enrolled, and a student can enroll in many courses)

## How to Create an Entity Relationship Diagram (ERD)

<figure><img src="../../../../.gitbook/assets/image (93).png" alt=""><figcaption></figcaption></figure>

### **1. Entity Identification:**

This is the foundation of the ERD. Here, we identify all the real-world things or concepts that we want to store information about in the database. These entities could be people, places, objects, events, or anything relevant to your system.

**Tips for Entity Identification:**

* Look for nouns in your system requirements or domain description. These often translate to entities.
* Consider what data elements you absolutely need to track and manage. Each data element could potentially belong to an entity.
* Start broad and then refine. We can always break down broader entities into more specific ones later.

### **2. Define Relationships:**

Once we have identified entities, we need to determine how they relate to each other. These relationships represent the associations or connections between entities.

**Tips for Defining Relationships:**

* Identify verbs that describe how entities interact. These verbs can indicate potential relationships.
* Think about how data gets used. If we often need to retrieve data from two entities together, they likely have a relationship.

### **3. Determine Cardinality:**

Cardinality specifies the number of occurrences of an entity instance in a relationship. It describes how many entities in one set relate to how many entities in another set.

### **4. Identify Attributes:**

After defining entities and their relationships, we need to identify the specific characteristics or properties of each entity. These are the attributes that will be used to store data about each entity instance (row) in your database tables.

* **Examples of Attributes:**
  * Customer: CustomerID, CustomerName, Email, PhoneNumber
  * Order: OrderID, OrderDate, CustomerID (foreign key)
  * Product: ProductID, ProductName, Price, Description
* **Tips for Identifying Attributes:**
  * Consider the data we need to capture about each entity to effectively represent it in the system.
  * Think about the kind of queries we might need to run on the data. The attributes should support those queries.

### **5. Create the ERD:**

Now that we have all the information, we can use a diagramming tool or even a simple drawing program to visually represent ERD.
