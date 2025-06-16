# Distributed Scheduling

## About

In Spring Boot, if we need to execute tasks at a scheduled time, we can use **@Scheduled** annotation. However, if there are multiple instances of the application and if we want to ensure that a scheduled task runs only once across all instances, in such case we need distributed scheduling.

There are different libraries that support distributed scheduling such as **ShedLock** , **Quartz** , **Akka Scheduler** etc.
