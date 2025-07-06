# Running Oracle DB

## About

Running Oracle DB on a Mac (especially with Apple Silicon like M1/M2) can be tricky because Oracle doesn't officially support macOS. However, we **can run it using Docker** with the right setup. Below are our options:

## Option 1: Using Manual Image Build

#### **Use Oracle DB in Docker**

Oracle provides official Docker images through GitHub.

#### **Step 1: Clone Oracle Docker GitHub Repo**

```bash
git clone https://github.com/oracle/docker-images.git
cd docker-images/OracleDatabase/SingleInstance/dockerfiles
```

#### **Step 2: Download Oracle Database Installation Zip**

Go to the Oracle website and download the Oracle Database zip (for example: `LINUX.X64_193000_db_home.zip` for 19c).

* Website: [https://www.oracle.com/database/technologies/oracle-database-software-downloads.html](https://www.oracle.com/database/technologies/oracle-database-software-downloads.html)
* Place the zip in the same folder where `buildContainerImage.sh` exists.

#### **Step 3: Build Docker Image**

```bash
./buildContainerImage.sh -v 19.3.0 -e
```

* `-v 19.3.0`: Version
* `-e`: Express Edition

This will build a Docker image like `oracle/database:19.3.0-ee`.

#### Step 4: Run the Oracle Container

```bash
docker run -d --name oracle-db \
  -p 1521:1521 -p 5500:5500 \
  -e ORACLE_PWD=MySecretPassword \
  oracle/database:19.3.0-ee
```

We can replace `ee` with `xe` if we built the Express Edition image.

#### Step 5: Connect to Oracle

* **Using SQL Developer or DBeaver:**
  * Host: `localhost`
  * Port: `1521`
  * SID: `ORCLCDB` or Service Name: `ORCLPDB1`
  * Username: `sys` or `system`
  * Password: `MySecretPassword`

## Option 2: Use Prebuilt Docker Image (Unofficial)

If we don’t want to build it ourself, we can use an **unofficial Oracle XE Docker image**:

```bash
docker pull gvenzl/oracle-xe:21-slim
docker run -d --name oracle-xe \
  -p 1521:1521 -p 8080:8080 \
  -e ORACLE_PASSWORD=MySecretPassword \
  gvenzl/oracle-xe:21-slim
```

* This image works on M1/M2 chips as well (`arm64`).

## Execute Image in a Container

Here is how to run the container and connect using SQL Developer.

{% hint style="success" %}
Running the container without a volume means all data is lost when the container is removed.
{% endhint %}

#### Step 1: Run Oracle XE Docker Container

```bash
docker run -d \
  --name oracle-xe \
  -p 1521:1521 -p 8080:8080 \
  -e ORACLE_PASSWORD=MySecretPassword \
  gvenzl/oracle-xe:18.4.0
```

* `-p 1521:1521`: For SQL connections (JDBC, SQL Developer, etc.)
* `-p 8080:8080`: Optional, for APEX/HTTP access
* `ORACLE_PASSWORD`: Sets the password for all users (e.g., `system`, `sys`)

#### Step 2: Connect to Oracle using SQL Developer

Open **SQL Developer** and create a **new connection**:

<table><thead><tr><th width="267.43316650390625">Field</th><th>Value</th></tr></thead><tbody><tr><td><strong>Name</strong></td><td>oracle-xe</td></tr><tr><td><strong>Username</strong></td><td><code>system</code> (or <code>sys</code> with role SYSDBA)</td></tr><tr><td><strong>Password</strong></td><td><code>MySecretPassword</code></td></tr><tr><td><strong>Hostname</strong></td><td><code>localhost</code></td></tr><tr><td><strong>Port</strong></td><td><code>1521</code></td></tr><tr><td><strong>Service Name</strong></td><td><code>XEPDB1</code> (default)</td></tr></tbody></table>

> If `XEPDB1` doesn't work, try `XE` (SID) — depends on the image version.

Click **Test** and it should say "Success".

#### To Check Running Status

```bash
docker logs -f oracle-xe
```

Look for lines like:

```
DATABASE IS READY TO USE!
```

#### SQL\*Plus inside the container

```bash
docker exec -it oracle-xe sqlplus system/MySecretPassword@//localhost:1521/XEPDB1
```

## Execute Image via Docker-Compose

Running the container without a volume means all data is lost when the container is removed. Here’s a **`docker-compose.yml`** file to run `gvenzl/oracle-xe:18.4.0` with **persistent storage** using Docker volumes so that the data is persisted in volume.

#### `docker-compose.yml`

```yaml
version: '3.8'

services:
  oracle-xe:
    image: gvenzl/oracle-xe:18.4.0
    container_name: oracle-xe
    ports:
      - "1521:1521"
      - "8080:8080"
    environment:
      ORACLE_PASSWORD: MySecretPassword
    volumes:
      - oracle_data:/opt/oracle/oradata
    restart: unless-stopped

volumes:
  oracle_data:
```

* `volumes: oracle_data:/opt/oracle/oradata`
  * This maps a **named Docker volume** to Oracle's data directory (`/opt/oracle/oradata`) to persist the database files.
* `restart: unless-stopped`
  * Ensures the container restarts automatically after reboot/crash unless manually stopped.

#### How to Use

1. Save the file as `docker-compose.yml`.
2.  Run the container:

    ```bash
    docker-compose up -d
    ```
3.  Check logs:

    ```bash
    docker-compose logs -f
    ```
