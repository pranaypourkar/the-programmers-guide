# Planned Maintenance Activity

## **Problem Statement**

In mobile applications backed by microservices, there are scenarios where **planned maintenance** is required on backend systems.\
The challenge is to **prevent users from accessing services during maintenance windows** while:

1. Minimizing disruption to **existing active sessions**.
2. Providing clear feedback to mobile users about maintenance timing.
3. Ensuring consistent behavior across all backend services accessed through a **gateway**.

Without a proper mechanism, users may experience **failed requests, inconsistent responses, or partial functionality**, leading to poor user experience.

## **Assumptions**

* Mobile apps communicate with backend APIs via **Spring REST APIs**.
* A **gateway** (API Gateway) routes all mobile requests to respective backend services and will remain up during the maintenance window.
* Maintenance windows are **scheduled** in advance and communicated through a configuration service or static page.
* Existing sessions may still be active when maintenance begins.

## **Solution 1 - API-Level Maintenance Check**

**Flow**

1. Mobile app calls a **pre-login API** to check if maintenance is enabled:

```json
{
  "isMaintenance": true,
  "message": "System maintenance ongoing",
  "fromTime": "2025-10-01T00:00:00Z",
  "toTime": "2025-10-01T02:00:00Z"
}
```

2. Mobile app uses the response to:
   * Show a maintenance screen **before login**.
   * Optionally disable certain features.
   * Warn the user about the upcoming maintenance window.

**Advantages**

* Simple to implement at the backend API level.
* Mobile apps can gracefully handle maintenance.
* Flexible: supports messages, start/end time, optional features.

**Disadvantages / Limitations**

* Existing sessions **already authenticated** may still send requests to backend APIs and get errors.
* Requires every mobile request to optionally handle maintenance logic.

## **Solution 2 - Traffic Redirection via Gateway (Istio or Nginx)**

**Flow**

1. **Configure gateway** or service mesh (Istio) rules to redirect traffic to a **maintenance service** or static page during the maintenance window.

{% hint style="success" %}
**Istio**

* Istio is a **service mesh** for microservices that runs alongside your services in Kubernetes. It provides **traffic management, security, and observability** without requiring changes to application code.
* **Relevance for Maintenance**
  * Istio can **intercept and route HTTP requests** at the ingress or service-to-service level.
  * During maintenance windows, Istio rules can **redirect traffic** from backend services to a **maintenance handler** or static page.
  * Supports **fine-grained routing** (specific APIs, paths, or services).
{% endhint %}

{% hint style="success" %}
**Nginx**

* Nginx is a widely used **web server and reverse proxy**. In microservices, it often serves as an **API gateway or ingress controller**.
* **Relevance for Maintenance**
  * Nginx can **redirect or serve a static maintenance page** during planned downtime.
  * It handles **existing connections gracefully** without involving backend services.
  * Provides **high performance** and minimal configuration overhead.
{% endhint %}

**Example Istio Rule**

```yaml
istio:
  enabled: true
  customHttpRoutes:
    edge:
      - match:
          - uri:
              exact: /api/
          - uri:
              exact: /auth/
        route:
          - destination:
              host: custom-maintenance-service
              port:
                number: 8080
```

2. All API requests during the maintenance window are automatically routed to a **maintenance handler** or static page.
3. Backend services **remain unaffected**, and users receive a uniform maintenance response.

**Advantages:**

* Handles **existing sessions automatically**, no changes needed in mobile apps.
* Centralized: rules are applied at the gateway level, not per service.
* Can be extended for partial maintenance (specific APIs only).

**Disadvantages / Considerations:**

* Slightly more complex to configure in Istio/Nginx.
* Requires careful testing to avoid **accidentally blocking non-maintenance traffic**.
* Maintenance messages may need to be **dynamic** if static pages are used.

## **Best Practices**

1. **Combine both solutions for a robust approach:**
   * API-level check for **pre-login mobile experience**.
   * Gateway-level redirect for **active sessions during maintenance**.
2. **Configuration Management:**
   * Centralized maintenance config in a service or ConfigMap.
   * Dynamic updates without redeploying gateways or apps.
3. **User Experience:**
   * Always provide `fromTime` / `toTime` in API responses.
   * Show clear maintenance screens in mobile apps.
   * Log redirected requests for monitoring and auditing.
4. **Testing:**
   * Test with **active mobile sessions** to ensure graceful handling.
   * Simulate gateway rules to confirm redirection works under load.
