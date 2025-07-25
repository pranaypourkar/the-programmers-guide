# Databases

## About

Containers for widely-used relational and NoSQL databases like PostgreSQL, MySQL, MongoDB, and Oracle. These images are essential for persistent data storage, transactional systems, and prototyping backend services during development and testing.

## **Oracle XE 18.4.0**

A lightweight, community-maintained container image for Oracle Database Express Edition (XE). Ideal for development and testing where full Oracle compatibility is required but the full Enterprise DB is too heavy. Official Oracle images are not published on Docker Hub, but this image (`gvenzl/oracle-xe`) is widely adopted, actively maintained, and supports multiple Oracle versions.

**Docker Pull Command:**

```bash
docker pull gvenzl/oracle-xe:18.4.0
```

**Basic Usage:**

```bash
docker run -d \
  -e ORACLE_PASSWORD=MyPassword123 \
  -p 1521:1521 \
  gvenzl/oracle-xe:18.4.0
```

**Notes:**

* Default user: `system`, password: value of `ORACLE_PASSWORD`
* Compatible with Testcontainers via `org.testcontainers:oracle-xe`
* Port `1521` is exposed for SQL\*Net connection
* For extended configuration, environment variables such as `APP_USER`, `APP_USER_PASSWORD` are supported

## **Oracle XE 18.4.0 (Slim Image)**

The slim variant of the `gvenzl/oracle-xe` image is a **reduced-size** Oracle XE container image that removes optional tools and reduces the overall disk footprint. This makes it ideal for CI pipelines, ephemeral development environments, and containerized workloads where space efficiency matters.

**Docker Pull Command:**

```bash
docker pull gvenzl/oracle-xe:18.4.0-slim
```

**Differences from Full Image:**

| Feature                     | Full Image      | Slim Variant |
| --------------------------- | --------------- | ------------ |
| Includes SQL\*Plus, APEX    | Yes             | (removed)    |
| File size                   | \~5 GB          | \~2.5 GB     |
| JDBC Connectivity           | Yes             | Yes          |
| Suitable for Testcontainers | Yes             | Yes          |
| Startup time                | Slightly slower | Faster       |

**Basic Usage:**

```bash
docker run -d \
  -e ORACLE_PASSWORD=MyPassword123 \
  -p 1521:1521 \
  gvenzl/oracle-xe:18.4.0-slim
```

**Notes:**

* Same environment variable support as the full image (`ORACLE_PASSWORD`, `APP_USER`, etc.)
* Useful when you only need basic Oracle functionality without full admin tools
* Ideal for running in low-resource CI environments

