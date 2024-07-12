# Core Terminology

## Geography

Geography in cloud computing refers to the global regions where cloud providers operate their data centers. These regions are typically divided into continents or large geographic areas.

* **Examples:** America, Europe, Asia Pacific, Middle East, Africa.

## Region

A region in cloud computing is a geographical area containing multiple data centers that are in close proximity to each other, often within 100 miles. Each region is independent of other regions and is designed to be isolated from failures in other regions.

* **Examples:**
  * **North Europe:** A region in Europe (e.g., Azure North Europe).
  * **West US:** A region in the United States (e.g., AWS West US).

## Availability Zone

An availability zone (AZ) is a physically separate data center within a region. Availability zones are designed to be isolated from failures in other zones, providing redundancy and fault tolerance within the same region.

* **Examples:** Zone 1, Zone 2, etc. (e.g., AWS Availability Zones).

## Availability Sets

Availability sets are logical groupings of VMs within a data center that are isolated from each other to avoid single points of failure. VMs in different availability sets are placed in different fault domains and update domains to ensure high availability during maintenance events and hardware failures.

## Fault Domain

&#x20;A fault domain is a logical group of hardware within an availability set. VMs within the same fault domain share a common power source and network switch. Azure automatically distributes VMs across fault domains to minimize the impact of hardware failures or maintenance updates.

## Update Domain

An update domain is a logical group of VMs within an availability set that are updated and rebooted together during planned maintenance events. Azure ensures that VMs within the same update domain are not restarted at the same time to maintain application availability.

## Region Pair

A region pair consists of two Azure regions within the same geography (e.g., Americas, Europe) that are paired for data residency, compliance, and disaster recovery purposes. Data is asynchronously replicated between region pairs to ensure data durability and high availability.

## Resource Group

A resource group is a logical container that holds related Azure resources (VMs, databases, storage accounts, etc.) for management, billing, and access control purposes. Resources within the same resource group can be deployed, managed, and monitored as a single entity.

## Compute

<table><thead><tr><th width="248">Terminology</th><th>Description</th></tr></thead><tbody><tr><td><strong>Virtual Machine</strong></td><td>Virtualized computing instance running on a cloud infrastructure.</td></tr><tr><td><strong>Virtual Machine Scale Sets</strong></td><td>Automatically scales sets of identical VMs for high availability and load balancing.</td></tr><tr><td><strong>App Service</strong></td><td>Platform for building, deploying, and scaling web apps and APIs.</td></tr><tr><td><strong>App Functions</strong></td><td>Serverless compute service for event-driven applications.</td></tr></tbody></table>

## Networking

<table><thead><tr><th width="237">Terminology</th><th>Description</th></tr></thead><tbody><tr><td><strong>Virtual Network</strong></td><td>Isolated network in the cloud for connecting VMs and other resources.</td></tr><tr><td><strong>Load Balancer</strong></td><td>Distributes incoming network traffic across multiple VMs or services.</td></tr><tr><td><strong>VPN Gateway</strong></td><td>Establishes secure connections between on-premises networks and Azure/VPC networks.</td></tr><tr><td><strong>Application Gateway</strong></td><td>Web traffic load balancer that manages traffic to web applications.</td></tr><tr><td><strong>CDN (Content Delivery Network)</strong></td><td>Distributes content globally to reduce latency and improve user experience.</td></tr></tbody></table>

## Storage

<table><thead><tr><th width="198">Terminology</th><th>Description</th></tr></thead><tbody><tr><td><strong>Blob Storage</strong></td><td>Object storage service for unstructured data like images, videos, and documents.</td></tr><tr><td><strong>Disk Storage</strong></td><td>Persistent, high-performance storage disks for VMs.</td></tr><tr><td><strong>File Storage</strong></td><td>Managed file shares in the cloud, accessible via the SMB protocol.</td></tr><tr><td><strong>Archive Storage</strong></td><td>Low-cost, long-term storage for data that is infrequently accessed.</td></tr></tbody></table>

## Database

<table><thead><tr><th width="243">Terminology</th><th>Description</th></tr></thead><tbody><tr><td><strong>Cosmos DB</strong></td><td>Globally distributed, multi-model database service for NoSQL data.</td></tr><tr><td><strong>SQL Database</strong></td><td>Managed relational database service offering high availability and scalability.</td></tr><tr><td><strong>MySQL, PostgreSQL, etc.</strong></td><td>Traditional relational database management systems offered as managed services.</td></tr></tbody></table>

## IoT (Internet of Things)

<table><thead><tr><th width="194">Terminology</th><th>Description</th></tr></thead><tbody><tr><td><strong>IoT Hub</strong></td><td>Managed service to connect, monitor, and manage IoT devices.</td></tr><tr><td><strong>IoT Central</strong></td><td>SaaS solution for IoT applications, including device management and data visualization.</td></tr></tbody></table>

## Big Data and Analytics

<table><thead><tr><th width="228">Terminology</th><th>Description</th></tr></thead><tbody><tr><td><strong>SQL Data Warehouse</strong></td><td>Elastic data warehouse service for big data analytics.</td></tr><tr><td><strong>Data Lake Analytics</strong></td><td>Service to process big data and run large-scale analytics jobs.</td></tr><tr><td><strong>HDInsight</strong></td><td>Managed Apache Hadoop, Spark, HBase, and Hive clusters for big data processing.</td></tr></tbody></table>

## AI (Artificial Intelligence)

<table><thead><tr><th width="291">Terminology</th><th>Description</th></tr></thead><tbody><tr><td><strong>Machine Learning</strong></td><td>Service for building and deploying machine learning models.</td></tr><tr><td><strong>Azure Machine Learning Studio</strong></td><td>Integrated development environment for building AI solutions.</td></tr></tbody></table>

## Serverless Computing

<table><thead><tr><th width="185">Terminology</th><th>Description</th></tr></thead><tbody><tr><td><strong>Functions</strong></td><td>Event-driven, serverless compute service for running small pieces of code (functions).</td></tr><tr><td><strong>Event Grid</strong></td><td>Event routing service for connecting applications to events from various sources.</td></tr><tr><td><strong>Logic Apps</strong></td><td>Automates workflows and integrates with other services via a visual designer.</td></tr></tbody></table>
