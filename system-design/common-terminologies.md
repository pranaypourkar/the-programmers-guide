# Common Terminologies

Here are some of the terminologies commonly used in System Design.

## Upstream and Downstream System

In the context of systems exchanging information via an API, **upstream** and **downstream** refer to the direction in which data flows and how systems interact with each other in the overall architecture.

### 1. **Upstream System**

The **upstream system** refers to the system that **provides** or **sends** data to another system. It is typically the source of information in the data exchange process.

* If **System A** sends data to **System B** via an API, **System A** would be considered the upstream system.
* **Upstream systems** are responsible for processing, creating, or transforming data before sending it downstream.

Example: If System A is a financial application generating transaction records, and it sends this data to System B (an analytics system), then System A is the upstream system.

### 2. **Downstream System**

The **downstream system** is the system that **receives** data from another system. It typically consumes or processes the information it gets from the upstream system.

* In the case of **System A** and **System B** exchanging information, if **System A** sends data to **System B**, then **System B** is the downstream system.
* **Downstream systems** often act on the received data, either by storing, further processing, or integrating it into another workflow.

Example: System B might be a reporting service that takes the transaction data from System A and creates reports or generates analytics based on that data. In this case, System B is the downstream system.
