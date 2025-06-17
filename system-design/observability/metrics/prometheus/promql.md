# PromQL

## About

Prometheus is a time-series database and monitoring system that collects metrics from our applications and infrastructure. It uses a powerful query language called **PromQL (Prometheus Query Language)** to extract, filter, and aggregate metrics over time.

In OpenShift, Prometheus is often used as the backend for monitoring the cluster, workloads, nodes, and custom applications. We can execute PromQL queries directly from the **OpenShift Web Console** (under _Observe → Metrics_) or via the Prometheus UI.

## **Purpose of Prometheus Queries in OpenShift**

* Monitor pod or node CPU/memory usage
* Track container restarts or failures
* Measure request rates, latencies, and errors
* Create custom dashboards or alerts
* Troubleshoot performance or resource issues
