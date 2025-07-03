# Cron Expression

## About

A **cron expression** is a string that represents a **schedule** in time. It is commonly used to trigger tasks at **specific times or intervals**. In Spring, we can use cron expressions with the `@Scheduled` annotation to run methods automatically at a configured time.

Cron expressions provide fine-grained control over **when** a task should run, making them a powerful tool for backend scheduling.

## Importance

Cron expressions are essential in scheduling for the following reasons:

* **Precise Scheduling**: Define exact times, days, or months for a job to run.
* **Flexible**: You can schedule tasks every second, minute, hour, or only on specific days of the week/month.
* **Externalized Config**: Can be moved to properties files to make them dynamic and configurable without code changes.
* **Time Zone Support**: Specify time zones for region-specific tasks.
* **Widely Supported**: Cron is a standardized pattern supported by many systems including Unix/Linux, Spring, Kubernetes, and Quartz.

## Syntax

Spring supports a 6-field cron expression format:

```
second minute hour day-of-month month day-of-week
```

Spring also supports a 7-field version (with optional year field), but the 6-field version is more commonly used.

#### Field Breakdown

<table><thead><tr><th width="164.0130615234375">Field</th><th width="256.2821044921875">Allowed Values</th><th>Description</th></tr></thead><tbody><tr><td>Seconds</td><td>0–59</td><td>The second of the minute</td></tr><tr><td>Minutes</td><td>0–59</td><td>The minute of the hour</td></tr><tr><td>Hours</td><td>0–23</td><td>The hour of the day (24-hour format)</td></tr><tr><td>Day of Month</td><td>1–31</td><td>The day of the month</td></tr><tr><td>Month</td><td>1–12 or JAN–DEC</td><td>The month</td></tr><tr><td>Day of Week</td><td>0–6 or SUN–SAT (0 = Sunday)</td><td>The day of the week</td></tr></tbody></table>

## Special Characters

<table><thead><tr><th width="104.8072509765625">Symbol</th><th>Description</th></tr></thead><tbody><tr><td><code>*</code></td><td>Matches all possible values for the field</td></tr><tr><td><code>?</code></td><td>No specific value (used in day-of-month or day-of-week to avoid conflicts)</td></tr><tr><td><code>-</code></td><td>Specifies a range (e.g., <code>10-12</code> means 10, 11, 12)</td></tr><tr><td><code>,</code></td><td>Specifies a list of values (e.g., <code>MON,WED,FRI</code>)</td></tr><tr><td><code>/</code></td><td>Specifies increments (e.g., <code>*/5</code> means every 5 units)</td></tr><tr><td><code>L</code></td><td>Last day of the month/week (Quartz only)</td></tr><tr><td><code>#</code></td><td>nth day of the month (e.g., <code>MON#3</code> is 3rd Monday) (Quartz only)</td></tr></tbody></table>

{% hint style="success" %}
NoteNot all features like `L` or `#` are supported in Spring’s basic cron parser. These are used in Quartz-based scheduling.
{% endhint %}

{% hint style="info" %}
Use `?` to tell the scheduler:

> "I don't care what value is in this field. Ignore it."



Don't use `?` in:

* **seconds**
* **minutes**
* **hours**
* **month**

It’s valid **only** in:

* **day-of-month**
* **day-of-week**
{% endhint %}

## Examples

<table><thead><tr><th width="256.14410400390625">Cron Expression</th><th>Meaning</th></tr></thead><tbody><tr><td><code>0 * * * * *</code></td><td>Every minute at second 0</td></tr><tr><td><code>*/10 * * * * *</code></td><td>Every 10 seconds</td></tr><tr><td><code>0 */5 * * * *</code></td><td>Every 5 minutes</td></tr><tr><td><code>0 0 */2 * * *</code></td><td>Every 2 hours (at hour 0, 2, 4...)</td></tr><tr><td><code>0 0 9-17 * * *</code></td><td>Every hour from 9 AM to 5 PM</td></tr><tr><td><code>0 0 12 * * MON</code></td><td>Every Monday at 12 PM</td></tr><tr><td><code>0 0 12 ? * MON</code></td><td>Every Monday at noon (<code>?</code> avoids day-of-month ambiguity)</td></tr><tr><td><code>0 0 0 1 * ?</code></td><td>On the 1st day of every month at midnight</td></tr><tr><td><code>0 15 10 ? * *</code></td><td>Every day at 10:15 AM</td></tr><tr><td><code>0 0/30 8-18 * * MON-FRI</code></td><td>Every 30 minutes between 8 AM and 6 PM on weekdays</td></tr><tr><td><code>0 0 9,15,21 * * *</code></td><td>At 9 AM, 3 PM, and 9 PM every day</td></tr><tr><td><code>0 0 0 1 1 *</code></td><td>At midnight on January 1st every year</td></tr><tr><td><code>0 0 8 * * MON,WED,FRI</code></td><td>At 8 AM every Monday, Wednesday, and Friday</td></tr><tr><td><code>0 0 0 1,15 * *</code></td><td>At midnight on the 1st and 15th of every month</td></tr><tr><td><code>0 0 0 * * 0,6</code></td><td>At midnight every Saturday and Sunday (0=Sunday, 6=Saturday)</td></tr><tr><td><code>0 0 0 * 1,7 *</code></td><td>At midnight every day during January and July</td></tr><tr><td><code>0 0 0 13 * FRI</code></td><td>At midnight on the 13th of any month if it's a Friday</td></tr><tr><td><code>0 0/5 9-17 * * ?</code></td><td>Every 5 minutes between 9 AM and 5 PM every day</td></tr><tr><td><code>0 15 14 1 * ?</code></td><td>At 2:15 PM on the 1st of every month</td></tr><tr><td><code>0 0 12 1/2 * ?</code></td><td>Every 2 days starting on the 1st of the month at noon</td></tr><tr><td><code>0 0 9-17 * * MON-FRI</code></td><td>Every hour from 9 AM to 5 PM on Monday through Friday</td></tr><tr><td><code>0 0 6 ? * TUE,THU</code></td><td>Every Tuesday and Thursday at 6 AM</td></tr><tr><td><code>0 0 12 15 5 ?</code></td><td>At 12 PM on May 15th every year</td></tr><tr><td><code>0 0 12 * * ?</code></td><td>Every day at 12 PM, no specific day-of-week</td></tr><tr><td><code>0 0 9 ? * MON-FRI</code></td><td>Every weekday at 9 AM, ignore day-of-month</td></tr><tr><td><code>0 0 12 1 * ?</code></td><td>On the 1st of every month at 12 PM, ignore day-of-week</td></tr><tr><td><code>0 0 8 ? * 2</code></td><td>Every Tuesday at 8 AM, ignore day-of-month (<code>2</code> = Tuesday)</td></tr></tbody></table>

## Usage in Spring

#### Basic Syntax

```java
@Scheduled(cron = "0 0 12 * * *")
public void runAtNoon() {
    // logic
}
```

#### With Time Zone

```java
@Scheduled(cron = "0 0 7 * * *", zone = "Asia/Kolkata")
public void morningTask() {
    // logic
}
```

**With Configuration in application.properties**

```properties
myapp.scheduling.cron=0 0 23 * * *
```

```java
@Scheduled(cron = "${myapp.scheduling.cron}")
public void nightlyJob() {
    // logic
}
```
