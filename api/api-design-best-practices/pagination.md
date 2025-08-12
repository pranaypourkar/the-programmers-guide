# Pagination

## About

Pagination is the process of splitting large sets of data into smaller, manageable chunks (or "pages") when delivering results from an API or database query. Instead of sending thousands or millions of records in a single response which can overwhelm the server, network, and client - pagination allows the data to be delivered incrementally.

In APIs, pagination is typically implemented through query parameters, such as `page` and `limit`, or by using more advanced techniques like cursors or tokens. This not only improves performance but also enhances the user experience by providing faster load times and smoother navigation.

For example, an e-commerce API might paginate product results so that the client application can display 20 products at a time, allowing users to browse through pages without fetching the entire product catalog in one go.

Pagination plays a critical role in scalability and efficiency, especially for APIs serving data to multiple clients or handling real-time queries on large datasets. It ensures resources are used effectively while maintaining responsiveness and usability.

## Why Pagination Matters ?

Pagination is more than just a way to split data - it’s a crucial design choice for performance, scalability, and usability in APIs. Without it, large datasets can lead to long response times, increased bandwidth usage, and potential server overload.

**Key reasons pagination is important:**

1. **Performance Optimization**\
   Returning only a subset of data reduces processing time for the server and speeds up the client’s ability to display results.
2. **Reduced Bandwidth Usage**\
   Sending smaller payloads lowers network transfer costs and improves load times, especially for users with slower connections or mobile devices.
3. **Better User Experience**\
   Data arrives quickly and can be displayed incrementally, making the application feel faster and more responsive.
4. **Scalability**\
   For APIs serving many concurrent users, pagination ensures that server resources are not overwhelmed by large, single queries.
5. **Data Navigation**\
   Pagination allows users to navigate datasets more easily, moving forward, backward, or jumping to specific sections without loading everything at once.

In real-world systems - such as social media feeds, search engines, e-commerce sites, and analytics dashboards - pagination is essential to delivering information efficiently and reliably.

## Pagination Techniques

When working with large datasets, APIs need a way to send results in smaller, manageable chunks. This ensures that clients can load data quickly without overwhelming the network or the backend systems. Different pagination techniques exist, each with unique benefits, performance characteristics, and complexity levels.

### 1. Page Number Pagination

* **How it works:** The client specifies a `page` number and the number of results per page (`limit` or `per_page`).
*   **Example:**

    ```
    GET /products?page=3&limit=20
    ```

    This means: “Give me the third set of 20 results.”
* **Internally:** The server converts the page number into an offset → `(page - 1) * limit`.
* **Pros:**
  * Very user-friendly and intuitive.
  * Works well for front-end apps with direct page navigation (like a search results UI).
* **Cons:**
  * Suffers from performance issues for large page numbers because the database still has to scan and skip many rows.
  * Results can shift if data changes between requests (less stable for real-time data).

### 2. Offset-based Pagination

* **How it works:** The client specifies exactly how many items to skip before starting to return results.
*   **Example:**

    ```
    GET /products?offset=40&limit=20
    ```

    This means: “Skip the first 40 items, then return 20 results.”
* **Pros:**
  * Very flexible — can jump to any position in the dataset.
  * Simple to implement in SQL (`LIMIT x OFFSET y`).
* **Cons:**
  * Slow for very large offsets because the database must still process skipped rows.
  * Same data-shifting problem as page numbers in dynamic datasets.

### 3. Cursor-based Pagination

* **How it works:** Instead of a numeric offset, the server returns a **cursor** (a token or ID) pointing to a specific position in the data. The next request uses this cursor to get the following results.
*   **Example:**

    ```
    GET /products?after=eyJpZCI6IDEwMH0&limit=20
    ```

    (`after` here is a base64-encoded cursor containing the last ID from the previous page.)
* **Pros:**
  * Very efficient for large datasets and real-time applications.
  * Stable results even if new data is inserted between requests.
* **Cons:**
  * Harder to implement than offset/page number.
  * We can’t easily “jump” to an arbitrary page without walking through previous cursors.

### 4. Keyset Pagination

* **How it works:** Similar to cursor pagination, but uses the value of a sorted column (often an ID or timestamp) directly to find the next set of rows.
*   **Example:**

    ```
    GET /products?last_id=100&limit=20
    ```

    This means: “Return 20 results where `id > 100`.”
* **Pros:**
  * Extremely fast for large datasets (uses index lookups).
  * Naturally consistent for ordered data.
* **Cons:**
  * Requires a predictable sort order (usually by primary key or timestamp).
  * Doesn’t support skipping arbitrary amounts of data.

### 5. Time-Based Pagination

**How it works:** We request items before or after a specific timestamp. The server returns results ordered by time and bounded by the provided timestamp and a limit.

**Example:**

```
GET /events?start_time=2025-08-01T00:00:00Z&limit=50
GET /events?before=2025-08-01T12:00:00Z&limit=100
```

**Internally:** Query uses a timestamp index, e.g. `WHERE timestamp > :start_time ORDER BY timestamp ASC LIMIT :limit`.

**Pros:**

* Natural fit for time-series, logs, and feeds.
* Handles streaming/continuous data well (clients can ask “give me everything since X”).
* Simple to understand for chronological data.

**Cons:**

* Many records can share the same timestamp; we need tie-breakers to avoid duplicates or gaps.
* Requires correct, consistent timestamp generation (clock skew or non-monotonic timestamps cause issues).
* Harder to jump to arbitrary “pages.”

**Best for:** Logs, event feeds, analytics, chronological feeds where ordering by time is primary.

### 6. Seek Method with Composite Keys

**How it works:** A cursor-like approach that uses multiple fields (for example `timestamp` + `id`) as the position marker so ordering is stable even when primary sort field has duplicates.

**Example:**

```
GET /events?after_timestamp=2025-08-01T00:00:00Z&after_id=789&limit=25
```

**Internally:** Query uses a composite comparison and an index, e.g.\
`WHERE (timestamp, id) > (:timestamp, :id) ORDER BY timestamp, id LIMIT :limit`.

**Pros:**

* Deterministic ordering (avoids duplicates/missing rows when many items share the same timestamp).
* Efficient when backed by a composite index on the sort columns.
* Good for high-concurrency environments where stable results matter.

**Cons:**

* More complex to implement and to build the cursor parameters.
* Requires composite indexes and careful ordering rules.
* Client handling is slightly more involved (needs to store/return multiple fields).

**Best for:** Time-ordered datasets with non-unique timestamps, event stores, feeds that require strict deterministic ordering.

### 7. Hybrid Approaches

**How it works:** Mixes two or more pagination methods to balance usability and performance. Common patterns: cursor + time-filter, page-number for shallow navigation + cursor for deep/infinite scroll, or cursor with additional filters.

**Example:**

*   Cursor + filter:

    ```
    GET /products?after=eyJpZCI6MTAwfQ==&category=books&limit=20
    ```
* Page UI + cursor backend: the UI shows `page` links for shallow pages but the API uses cursors for deep requests.

**Internally:** Server decodes cursor (if present), applies additional filters/time-bounds, and runs an indexed keyset or composite query. Hybrid cursor tokens often encode filter state to ensure consistent continuation.

**Pros:**

* Flexible: supports multiple client needs (UI paging and infinite scroll).
* Can optimize for performance while preserving familiar UX patterns.
* Allows combining strengths (e.g., cursor stability + time filtering).

**Cons:**

* Increased complexity in implementation, documentation, and testing.
* Cursors may need to encode filter/sort state to remain valid across requests.
* Potential for subtle bugs if filters or sort orders change between requests.

**Best for:** APIs that serve varied clients (web UI + mobile + third-party), systems that need both jump-to-page convenience and performant deep paging, or APIs that require rich filtering along with efficient continuation.

## Choosing the Right Technique

The right pagination method depends on our **data size**, **access patterns**, **performance needs**, and **user experience expectations**.\
Below is a decision framework to help guide the choice.

#### 1. If **Jump-to-Any-Page** is required

* **Best choice:** **Page Number Pagination** or **Offset Pagination**
* **Why:** Simple for users, supports random access.
* **Trade-off:** Less efficient for large datasets because the database must skip many rows.

#### 2. If **Performance & Scalability** are top priorities

* **Best choice:** **Cursor-Based** or **Keyset Pagination**
* **Why:** Works efficiently with large datasets, avoids deep `OFFSET` skips.
* **Trade-off:** No easy random page access; more complex client handling.

#### 3. If the data is **time-series or continuously generated**

* **Best choice:** **Time-Based Pagination** or **Composite Seek Method**
* **Why:** Natural fit for chronological ordering, works well for real-time feeds.
* **Trade-off:** Must handle duplicate timestamps with tie-breakers.

#### 4. If **consistent ordering under concurrent updates** matters

* **Best choice:** **Cursor with stable sort key** or **Composite Seek Method**
* **Why:** Ensures we don’t miss or duplicate records when data changes between requests.

#### 5. If our API serves **different client needs**

* **Best choice:** **Hybrid Approach**
* **Why:** Lets us combine cursor efficiency with page-number convenience, or mix time filters with cursors.
* **Trade-off:** Increases implementation complexity.

### **Comparison Table**

<table data-full-width="true"><thead><tr><th>Criterion</th><th>Page Number</th><th>Offset</th><th>Cursor</th><th>Keyset/Seek</th><th>Time-Based</th><th>Composite Seek</th><th>Hybrid</th></tr></thead><tbody><tr><td>Jump-to-page</td><td>✅</td><td>✅</td><td>❌</td><td>❌</td><td>❌</td><td>❌</td><td>✅</td></tr><tr><td>Works with large datasets</td><td>⚠️ (slow)</td><td>⚠️</td><td>✅</td><td>✅</td><td>✅</td><td>✅</td><td>✅</td></tr><tr><td>Handles concurrent updates well</td><td>❌</td><td>❌</td><td>✅</td><td>✅</td><td>⚠️</td><td>✅</td><td>✅</td></tr><tr><td>Easy to implement</td><td>✅</td><td>✅</td><td>⚠️</td><td>⚠️</td><td>✅</td><td>⚠️</td><td>❌</td></tr><tr><td>Best for time-series</td><td>❌</td><td>❌</td><td>⚠️</td><td>⚠️</td><td>✅</td><td>✅</td><td>✅</td></tr></tbody></table>

## Best Practices for Pagination

Good pagination is not just about splitting data - it’s about **delivering results efficiently, consistently, and in a way users can trust**.

#### 1. Always Return Pagination Metadata

Include information like:

* Current page or cursor position
* Total records (if available)
* Links or tokens for next and previous pages

**Why:** Helps clients navigate without guessing parameters.

#### 2. Keep Results Consistent

When data changes frequently, new or removed items can cause:

* Duplicate results across pages
* Missing items if they shift between pages

**How to handle:**

* Use **stable sorting keys** (e.g., created timestamp + ID)
* Consider **snapshots** or **versioning** for a consistent view

#### 3. Set Reasonable Limits

Don’t let clients request thousands of records in one page.

* Common safe range: **20–100 items per page**
* Use a **maximum limit** to protect server performance

#### 4. Support Sorting and Filtering

Allow clients to refine data before pagination.

* Example: Filter by category, then paginate
* Improves relevance and reduces unnecessary data transfer

#### 5. Prefer Cursors for Large or Infinite Lists

For large datasets or real-time feeds:

* Cursors avoid performance hits from deep offsets
* Provide smooth “infinite scroll” experiences

#### 6. Design for Scalability from Day One

* Index columns used in sorting and filtering
* Test with large datasets to catch slow queries early

#### 7. Consider User Experience

* For web UIs, **infinite scroll** may be better than numbered pages
* For reports or exports, numbered pages are easier for navigation

#### 8. Document our Pagination Model Clearly

API consumers should know:

* Which parameters control pagination
* How cursors/tokens are generated and used
* Whether results are **stable** or **dynamic**
