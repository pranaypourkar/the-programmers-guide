# Deployment Patterns

### What are Deployment Patterns?

Deployment patterns refer to various strategies and methodologies used in software deployment to ensure the smooth transition of new code or updates into production environments while minimizing disruption and risk. These patterns help in achieving goals such as maintaining system availability, ensuring reliability, and reducing downtime during deployments.

Some common deployment patterns include:

### **Canary Release**&#x20;

In this pattern, a new version of the software is gradually rolled out to a small subset of users or servers before being deployed to the entire infrastructure. This allows for early detection of issues and reduces the impact of bugs or performance problems.

### **Blue-Green Deployment**&#x20;

This involves maintaining two identical production environments, one active (blue) and the other inactive (green). The new version of the software is deployed to the inactive environment, and once the deployment is successful and verified, traffic is switched from the active environment to the updated one. This pattern minimizes downtime and allows for easy rollback if issues arise.

### **Rolling Deployment**

In a rolling deployment, updates are gradually applied across different parts of the infrastructure while maintaining service availability. This is typically achieved by updating one or a few instances at a time, allowing the system to continue serving traffic throughout the deployment process.

### **Feature Toggle (Feature Flags)**&#x20;

Feature toggles allow developers to enable or disable certain features of the software at runtime. This pattern enables gradual rollout of new features to users and provides the ability to turn off features quickly in case of issues. For example, Mobile App using Remote Config BE API to enable or disable certain features. This Remote Config changes can be done via UI console as well without BE deployment. Or by creating feature flag API which allows certain features based on time based restriction (like payments can only be done after a day when user registered)

### **A/B Testing**&#x20;

A/B testing involves releasing multiple versions of a feature to different segments of users and measuring their performance or user feedback to determine the most effective version. This pattern helps in making data-driven decisions and optimizing the user experience.

### **Dark Launching**&#x20;

In dark launching, new features or updates are deployed to production environments but are not exposed to end-users. Instead, they are tested internally or with a small subset of users to gather feedback and ensure stability before fully releasing them.

### **Traffic Splitting**

Traffic splitting involves dividing user traffic between different versions or instances of the software based on predefined criteria, such as geographical location or user preferences. This pattern enables gradual rollout of updates and can be used in conjunction with other deployment patterns.
