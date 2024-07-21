# Low-Level Design (LLD)

## About

Low-Level Design, also known as detailed design or micro-level design, provides detailed information about the system's components and their interactions. It focuses on the internal structure and workings of the system.

{% hint style="info" %}
LLD is like the detailed floor plan of the building. It goes into the specifics of each room, the layout of furniture, wiring, plumbing, etc.
{% endhint %}

### **Key Aspects**

1. **Class Diagrams:** Defines the classes, their attributes, methods, and relationships.
2. **Sequence Diagrams:** Describes the sequence of interactions between different components for specific use cases.
3. **Data Structures:** Specifies the data structures to be used and their organization.
4. **Algorithms:** Details the algorithms to be implemented and their logic.
5. **Component Design:** Provides detailed design of individual components and modules.
6. **Database Design:** Describes the database schema, including tables, relationships, and indexes.

### **Purpose**

* Provides a detailed design specification for developers to implement the system.
* Ensures that all components and modules are well-defined and their interactions are clear.
* Serves as a guide for writing code and unit tests.

### Example of a web-based e-commerce application

**Class Diagram:**

* User class with attributes (userId, userName, password) and methods (login(), register()).
* Product class with attributes (productId, productName, price) and methods (getProductDetails()).

**Sequence Diagram:**

* Sequence for user login: User enters credentials -> System validates credentials -> System fetches user data -> User is logged in.

**Data Structures:**

* User: HashMap to store user sessions.
* Product: ArrayList to store product details.

**Algorithms:**

* Search algorithm for product catalog using binary search.

**Component Design:**

* Detailed design of the Shopping Cart component, including methods for adding, removing, and updating items.

**Database Design:**

* User table with columns (userId, userName, password).
* Product table with columns (productId, productName, price).

