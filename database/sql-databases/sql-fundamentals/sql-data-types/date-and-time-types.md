# Date & Time Types

## About

**Date and time data types** are used to store temporal values such as dates, times, and timestamps. These types allow querying, sorting, and arithmetic with time-based data like birthdays, events, or logs.

Standard SQL defines several temporal types, though support varies between vendors.

## 1. **DATE**

* Stores both **date and time** components in standard SQL.
* Some databases (like Oracle) include time, while others (like MySQL) store only the date part.

**Example:**\
`DATE '2024-06-01'`\
May include `2024-06-01 00:00:00` in systems that store time.

## 2. **TIME \[(p)]**

* Stores **time only**, without a date.
* `p` is optional precision for fractional seconds.

**Example:**\
`TIME '14:30:00'` or `TIME(3) '14:30:00.123'`&#x20;

## 3. **TIMESTAMP \[(p)]**

* Stores both **date and time**, including fractional seconds if specified.
* Used for tracking full temporal values like creation or modification times.

**Example:**\
`TIMESTAMP '2024-06-01 14:30:00'`

## 4. **TIME WITH TIME ZONE / TIMESTAMP WITH TIME ZONE**

* Stores time or timestamp **with a time zone offset**.
* Important for applications dealing with global users and multiple time zones.

**Example:**\
`TIMESTAMP '2024-06-01 14:30:00+05:30'`

## 5. **INTERVAL**

* Stores a **duration** or difference between two temporal values.
* Comes in two forms:
  * `INTERVAL YEAR TO MONTH`
  * `INTERVAL DAY TO SECOND`

**Example:**\
`INTERVAL '2-6' YEAR TO MONTH`\
`INTERVAL '5 12:30:10' DAY TO SECOND`&#x20;

## Vendor Support Overview

<table data-header-hidden data-full-width="true"><thead><tr><th width="118.24609375"></th><th width="96.015625"></th><th width="92.7890625"></th><th width="117.6640625"></th><th></th><th></th></tr></thead><tbody><tr><td>Database</td><td><code>DATE</code></td><td><code>TIME</code></td><td><code>TIMESTAMP</code></td><td>Time Zone Support</td><td><code>INTERVAL</code> Support</td></tr><tr><td><strong>Oracle</strong></td><td>Yes (includes time)</td><td>No separate type</td><td>Yes</td><td><code>TIMESTAMP WITH TIME ZONE</code></td><td>Yes (<code>INTERVAL</code> types)</td></tr><tr><td><strong>MySQL</strong></td><td>Yes (date only)</td><td>Yes</td><td>Yes</td><td>Limited via <code>CONVERT_TZ()</code></td><td>No built-in <code>INTERVAL</code>, but supports functions like <code>DATE_ADD()</code></td></tr><tr><td><strong>PostgreSQL</strong></td><td>Yes (date only)</td><td>Yes</td><td>Yes</td><td>Full support (<code>WITH TIME ZONE</code>)</td><td>Yes (full standard support)</td></tr><tr><td><strong>SQL Server</strong></td><td>Yes (date only)</td><td>Yes (<code>TIME</code>)</td><td>Yes (<code>DATETIME2</code>)</td><td>Limited; no native time zone storage</td><td>No native <code>INTERVAL</code>; uses <code>DATEDIFF()</code></td></tr><tr><td><strong>SQLite</strong></td><td>Yes (stored as TEXT/REAL)</td><td>Yes (via TEXT)</td><td>Yes</td><td>No native time zone support</td><td>No native <code>INTERVAL</code>, use math functions</td></tr></tbody></table>
