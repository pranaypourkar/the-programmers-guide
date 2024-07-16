# Openshift

## About

OpenShift is a comprehensive container orchestration platform developed by Red Hat. It is built on top of Kubernetes and provides a more user-friendly interface and additional tools to facilitate the management of containerized applications.&#x20;

OpenShift Container Platform is a private <mark style="background-color:purple;">platform-as-a-service (PaaS)</mark> for enterprises that run OpenShift on public cloud or on-premises infrastructure. It runs on the Red Hat Enterprise Linux (RHEL) operating system and functions as a set of Docker-based application containers managed with Kubernetes orchestration

OpenShift is a Docker-based system intended to help developers easily construct applications. Cluster management and orchestration of containers on multiple hosts is handled by Kubernetes.

{% hint style="info" %}
**What is container orchestration?**

Container orchestration is the automated management of the deployment, scaling, and operation of containerized applications. In simple terms, it is a way to manage and coordinate multiple containers that are used to run applications, ensuring they work together smoothly and efficiently.
{% endhint %}

## How Openshift differs from Kubernetes?

### Comparison Table

<table data-full-width="true"><thead><tr><th width="200">Feature</th><th width="357">Kubernetes</th><th>OpenShift</th></tr></thead><tbody><tr><td><strong>Base Platform</strong></td><td>Core container orchestration platform</td><td>Enterprise-grade container orchestration platform built on Kubernetes</td></tr><tr><td><strong>Installation &#x26; Setup</strong></td><td>Manual setup and configuration</td><td>Automated installation via Installer-Provisioned Infrastructure (IPI); User-Provisioned Infrastructure (UPI) for custom setups</td></tr><tr><td><strong>Developer Tools</strong></td><td>Requires integration of external CI/CD tools</td><td>Integrated CI/CD pipelines with Jenkins, Source-to-Image (S2I) builds, and a rich web console</td></tr><tr><td><strong>User Interface</strong></td><td>Basic dashboard</td><td>Feature-rich, user-friendly web console for developers and administrators</td></tr><tr><td><strong>Security</strong></td><td>Basic security features like RBAC; advanced security requires manual setup</td><td>Enhanced security with integrated policies, SELinux support, and Open Policy Agent (OPA) integration</td></tr><tr><td><strong>Multi-Tenancy</strong></td><td>Supported via namespaces and RBAC, requires additional configuration for secure isolation</td><td>Advanced multi-tenancy with robust isolation and security controls</td></tr><tr><td><strong>Networking</strong></td><td>Basic networking through CNI plugins</td><td>Advanced networking with OpenShift SDN, including network policies and enhanced security</td></tr><tr><td><strong>Storage</strong></td><td>Supports various storage solutions via CSI plugins</td><td>Seamless integration with Red Hat OpenShift Container Storage</td></tr><tr><td><strong>Service Mesh</strong></td><td>Supports Istio and other service meshes, requires manual setup</td><td>Integrated Istio-based service mesh for microservices communication, traffic management, and observability</td></tr><tr><td><strong>Operational Tools</strong></td><td>Requires third-party tools for monitoring, logging, and alerting</td><td>Built-in monitoring (Prometheus), logging (EFK stack), and alerting tools</td></tr><tr><td><strong>Image Management</strong></td><td>Uses Docker and other runtimes, lacks advanced image management features</td><td>Integrated container image registry with advanced features like image streams and automatic updates</td></tr><tr><td><strong>Updates &#x26; Upgrades</strong></td><td>Requires manual intervention for cluster updates and upgrades</td><td>Automated updates and upgrades with minimal downtime</td></tr><tr><td><strong>Support &#x26; Ecosystem</strong></td><td>Vast open-source community; enterprise support depends on chosen distribution (e.g., GKE, EKS)</td><td>Enterprise-grade support from Red Hat, curated ecosystem of tools and integrations</td></tr><tr><td><strong>Ease of Use</strong></td><td>Requires more manual setup and management</td><td>More user-friendly with additional tools and automated processes</td></tr><tr><td><strong>Scalability</strong></td><td>Supports automatic scaling with configuration</td><td>Advanced auto-scaling capabilities for applications and nodes</td></tr><tr><td><strong>Service Catalog</strong></td><td>Service Catalog requires additional setup</td><td>Built-in Service Catalog with a wide range of services and integrations</td></tr><tr><td><strong>Compliance</strong></td><td>Compliance features depend on distribution and additional setup</td><td>Enhanced compliance features with built-in security policies and controls</td></tr></tbody></table>

### Additional Points

#### Distribution

Kubernetes is an open-source container orchestration platform, with several vendors providing managed services based on the platform, including Amazon Elastic Kubernetes Service, Azure Kubernetes Service, Google Kubernetes Engine and Rancher. OpenShift is based on Kubernetes but is not considered a Kubernetes distribution. It is distinct from other Kubernetes distributions as it offers extensions and add-ons.

#### Workflow and configuration

OpenShift uses Kubernetes as its foundation, so it shares the same core principles. To deploy containerized applications across server clusters, the user writes configuration files that define how the applications should deploy. Both Kubernetes and OpenShift support the YAML and JSON configuration languages and offer load-balancing and routing capabilities. You can run either platform on-premises or in the public cloud.

#### APIs and integrations

OpenShift’s compliance with Kubernetes APIs means that applications that can be deployed on Kubernetes can be deployed on OpenShift. The main difference between OpenShift and Kubernetes is that OpenShift supports different tools and extensions.

#### Command line tools

Kubernetes distributions typically use `kubectl` as the primary command-line tool for managing clusters. The OpenShift command line is `oc` and is similar to kubectl but offers additional features to simplify complex administrative tasks.

#### Logging and dashboards

Kubernetes is compatible with a variety of logging tools, so users can choose how they manage logging. In OpenShift, log management depends on EFK (Elasticsearch, Fluentd and Kibana). Kubernetes offers a dashboard as an add-on, which is not a core part of Kubernetes. OpenShift has a web management console built in.

#### Operating system support

Kubernetes nodes can run on any Linux OS (and worker nodes can also run on Windows), while OpenShift nodes require Red Hat Enterprise Linux CoreOS.

#### Platform Support

OpenShift can be installed on the following platforms:

* OpenShift 3—Red Hat Enterprise Linux (RHEL) or Red Hat Atomic.
* OpenShift 4—Red Hat CoreOS for the control plane, and either CoreOS or RHEL for worker nodes.

Kubernetes can be installed on almost any Linux distribution, including the popular Ubuntu, Debian, and other alternatives.

## Core Concepts

### 1. Containers

Containers are the basic units of an OpenShift Container Platform application. They are a lightweight mechanism for isolating processes and can only interact with specified resources on the host machine. We can use Kubernetes and OpenShift Container Platform to orchestrate Docker containers across multiple hosts.

### 2. Images

OpenShift Container Platform uses standard Docker images to create containers. Images are binaries that include all requirements for running containers, along with descriptive metadata..

### 3. Container Image Registries

An image registry is necessary to manage container images and allow OpenShift to store and retrieve images when provisioning resources. You can use either Docker Hub, any other registry, or the OpenShift Container Platform’s internal image registry.

### 4. Pods

In Kubernetes, a pod is the smallest operating unit of a cluster, letting you deploy one or more containers on a host machine, and scale out to additional machines as needed. Pods are roughly equivalent to machine instances, with each pod having an internal IP address and its own port space—the containers in a pod share networking and local storage.OpenShift Container Platform doesn’t support changes to pod definitions while they are running. Changes are implemented by terminating a pod and recreating a modified version. Pods are expendable and don’t maintain state when reconstituted, so they should be managed by a higher-level controller and not by users.

### 5. Services

Kubernetes services act as internal load balancers—they identify sets of replicated pods and help proxy their connections. You can add or remove pods from a service, and the service always remains available, allowing other objects to refer to the service’s consistent address. Default service clusterIP addresses allow pods to access each other.

### 6. Users

Users are the agents that interact with the OpenShift Container Platform—user objects can be given role-based permissions, either individually or as groups. Users must authenticate to access the platform; unauthenticated API requests are treated as requests by an anonymous user. Roles and policies determine what each user is authorized to do.

### 7. Builds

Builds are the process of creating an object based on input parameters, usually resulting in a runnable image. BuildConfig objects are definitions for entire build processes. OpenShift Container Platform creates Docker containers from build images and pushes them to a container image registry.

### 8. Image Streams

Image streams and their associated tags provide abstractions for referencing container images in OpenShift Container Platform. They do not contain image data, but rather present a visualization of related images and changes made to them. You can set up builds and deployments that respond to image stream notifications

## OCP Architecture

Reference: [https://redhat-scholars.github.io/openshift-starter-guides/rhs-openshift-starter-guides/4.7/\_images/common-environment-ocp-architecture.png](https://redhat-scholars.github.io/openshift-starter-guides/rhs-openshift-starter-guides/4.7/\_images/common-environment-ocp-architecture.png)

<figure><img src="../../.gitbook/assets/common-environment-ocp-architecture-1.png" alt=""><figcaption></figcaption></figure>

### Infrastructure Layer

This layer lets us host applications on virtual servers or physical servers, as well as private or public cloud infrastructure

### Service Layer

This layer lets us define pods and access policies. Here are several features of the service layer:

* Provides a permanent IP address and host name for your pods.
* Lets us connect applications together
* Enables us to use simple internal load balancing for distributing tasks across multiple application components.

The service layer runs our clusters. An OpenShift cluster uses two types of nodes—**main nodes** (responsible for managing the cluster, also called master nodes) and **worker nodes** (responsible for running applications).

### **Main Nodes**

Main nodes are in charge of managing the OpenShift cluster, performing four key tasks:

API and authentication—administration requests must go through APIs. Each request is encrypted by SSL and authenticated to ensure the cluster remains secure.

Data store—the state and any information related to the environment and application is kept in data stores.

Scheduler—pod placements are determined by schedulers, which take into account the current environment and utilization aspects like CPU and memory.

Health and scaling—health of pods is monitored and scaled by self-healing and auto-scaling processes that take into account CPU utilization. Once a pod fails, the main node automatically restarts it. If a pod fails too often, the automated process marks it as a bad pod and stops restarting it for a temporary period of time.

### **Worker Nodes**

Each worker consists of pods. In OpenShift, a pod is the smallest unit you can define, deploy, and manage. A pod can host one or more containers.

A container hosts applications and relevant dependencies. You can deploy containers as stateless or stateful.

Containers located in the same pod share an IP address, local storage, and attached storage volumes. A pod can host a sidecar container, which you can use to add components like a service mesh, logging or monitoring tools.

### Persistent Storage

Containers are ephemeral and are often restarted or deleted. This is not ideal for storing data. To prevent data loss, you can use persistent storage, which lets you define stateful applications and data.

### Routing Layer

This layer provides external access to cluster applications from any device. The routing layer also performs auto-routing and load balancing for unhealthy pods.



## Components of OpenShift

One of the key components of OpenShift architecture is to manage containerized infrastructure in Kubernetes. Kubernetes is responsible for Deployment and Management of infrastructure. In any Kubernetes cluster, we can have more than one master and multiple nodes, which ensures there is no point of failure in the setup.

{% hint style="info" %}
The openshift environment consists of the following systems:

\-> Master node(s)\
\-> Worker or "application" nodes\
\-> Dynamic Provisioned Storage

OpenShift container platform is available in two package levels.

**OpenShift Container Local** − This is for those developers who wish to deploy and test applications on the local machine. This package is mainly used by development teams for developing and testing applications.

**OpenShift Container Lab** − This is designed for extended evaluation of application starting from development till deployment to pre-prod environment.

There are **three ways** to interact with OpenShift: the command line, the web interface, and the RESTful API.
{% endhint %}

<div>

<figure><img src="../../.gitbook/assets/image.png" alt=""><figcaption></figcaption></figure>

 

<figure><img src="../../.gitbook/assets/image (1).png" alt=""><figcaption></figcaption></figure>

</div>

### Kubernetes Master Machine Components

<figure><img src="../../.gitbook/assets/image (2).png" alt="" width="308"><figcaption></figcaption></figure>

#### Kubernetes Master Machine Components

**Etcd** − It stores the configuration information, which can be used by each of the nodes in the cluster. It is a high availability key value store that can be distributed among multiple nodes. It should only be accessible by Kubernetes API server as it may have sensitive information. It is a distributed key value Store which is accessible to all.

**API Serve**r − Kubernetes is an API server which provides all the operation on cluster using the API. API server implements an interface which means different tools and libraries can readily communicate with it. A kubeconfig is a package along with the server side tools that can be used for communication. It exposes Kubernetes API”.

**Controller Manager** − This component is responsible for most of the collectors that regulate the state of the cluster and perform a task. It can be considered as a daemon which runs in a non-terminating loop and is responsible for collecting and sending information to API server. It works towards getting the shared state of the cluster and then make changes to bring the current status of the server to a desired state. The key controllers are replication controller, endpoint controller, namespace controller, and service account controller. The controller manager runs different kind of controllers to handle nodes, endpoint, etc.

**Scheduler** − It is a key component of Kubernetes master. It is a service in master which is responsible for distributing the workload. It is responsible for tracking the utilization of working load on cluster nodes and then placing the workload on which resources are available and accepting the workload. In other words, this is the mechanism responsible for allocating pods to available nodes. The scheduler is responsible for workload utilization and allocating a pod to a new node.





