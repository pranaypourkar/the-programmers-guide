# Liquibase CLI

## About

Liquibase is an database schema management tool that helps managing and versioning of the database schema changes. It allows defining database schema changes in a declarative way using XML, YAML, JSON, or SQL formats, and then apply these changes to the database. It supports a wide range of relational databases, including Oracle, MySQL, SQL Server, DB2, and others.

## Liquibase and manual SQL queries.

Liquibase and manual SQL queries are two different approaches to managing database schema changes.

**Manual SQL queries** requires writing of the SQL statements necessary to create, modify, or delete database objects, such as tables, indexes, and constraints. These SQL statements need to be run manually, either through a database console or a script, to apply the changes to the database schema.

**Liquibase**, on the other hand, is a tool or library that provides a declarative way to manage database schema changes. With Liquibase, schema changes can be defined in a change log file, which can be versioned and tracked just like the application code. This makes it easy to manage database schema changes across different environments.

**For more details on Liquibase, visit the official website -** [**https://docs.liquibase.com/**](https://docs.liquibase.com/)

## Setup and Run Liquibase using CLI method

There are several ways to setup Liquibase, depending on the needs and preferences. In this, we will use CLI method.

**Download the zip file from the liquibase release page and extract it -** [**https://github.com/liquibase/liquibase/releases**](https://github.com/liquibase/liquibase/releases)

<figure><img src="https://static.wixstatic.com/media/5fb94b_b2a32b7667d04c858033e74c6b38c9a2~mv2.png/v1/fill/w_1480,h_240,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_b2a32b7667d04c858033e74c6b38c9a2~mv2.png" alt="ree"><figcaption></figcaption></figure>



Open the profile (in my case .zprofile) and add the path for liquibase so that it is accessible via terminal.

```
PATH="/Users/pranayp/Documents/Software/liquibase/liquibase-4.21.1:$PATH"
```

**Open the terminal and type below command to verify the installation.**

```
liquibase --version
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_778648d26b3441bea9319860fa2ff552~mv2.png/v1/fill/w_1480,h_496,al_c,q_90,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_778648d26b3441bea9319860fa2ff552~mv2.png" alt="ree"><figcaption></figcaption></figure>

### Setup Mysql Instance

_**We will use mysql instance in local, through which liquibase will interact. Let's use docker compose method for the same.**_

docker-compose.yaml

```yaml
version: "3.9"
# https://docs.docker.com/compose/compose-file/

services:
  db-mysql:
    container_name: db-mysql
    image: mysql:8.0.29
    ports:
      - "3306:3306"
    environment:
      MYSQL_ROOT_PASSWORD: root
    volumes:
      - mysql-data:/var/lib/mysql

volumes:
  mysql-data:
    driver: local

networks:
  default:
    name: company_default
```

Start the mysql instance with below command.

```
docker-compose up db-mysql
```

> Note: We can connect to mysql db through MySQLWorkbench with the help of _root_ as username and password

<figure><img src="../../../../.gitbook/assets/liquibase-integration-1 (1).png" alt=""><figcaption></figcaption></figure>

### **Mysql Driver**

_**Liquibase will need mysql driver to work with mysql. We can download the mysql driver from the official site**_**&#x20;-** [**https://dev.mysql.com/downloads/connector/j/**](https://dev.mysql.com/downloads/connector/j/)

<figure><img src="https://static.wixstatic.com/media/5fb94b_515ca61279da44c685646de6ff50630e~mv2.png/v1/fill/w_1480,h_416,al_c,q_90,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_515ca61279da44c685646de6ff50630e~mv2.png" alt="ree"><figcaption></figcaption></figure>

### Changelog Files Setup

In Liquibase, a changelog is an XML, YAML, or JSON file that describes the set of changes to be applied to a database. The "changeLog-master" file is the entry point that includes or references multiple individual changelog files. We will use YAML in this blog. The purpose of the "changeLog-master" file is to provide a central place to organize and manage all the changes to the database schema. It helps in maintaining a structured and sequential order of changes and facilitates collaboration among multiple developers working on the same database.

_**Let's create changeLog-master.yaml file which will have reference to 3 separate changelog file.**_

changeLog-master.yaml

```yaml
databaseChangeLog:
- includeAll:
    path: tables-setup-0_1
    relativeToChangelogFile: true
```

> Note: 3 changelog files are housed in **tables-setup-0\_1** folder

add-table-books-04052023.yaml (Creates a tables with name - books)

```yaml
databaseChangeLog:
  - changeSet:
      id: 2
      author: pranay.pourkar@test.com
      labels: books
      context: books
      comment: This is the table to hold books data
      changes:
        - createTable:
            tableName: books
            columns:
              - column:
                  name: id
                  type: int
                  autoIncrement: true
                  constraints:
                    primaryKey: true
                    nullable: false
              - column:
                  name: name
                  type: varchar(50)
                  constraints:
                    nullable: false

# Add a version attribute here
version: 1.0.0
```

add-table-users-03052023.yaml (Creates a table with name - users)

```yaml
databaseChangeLog:
  - changeSet:
      id:  1
      author: pranay.pourkar@test.com
      labels: users
      context: users
      comment: This is the table to hold users data
      changes:
        - createTable:
            tableName:  users
            columns:
              - column:
                  name:  id
                  type:  int
                  autoIncrement:  true
                  constraints:
                    primaryKey:  true
                    nullable:  false
              - column:
                  name:  name
                  type:  varchar(50)
                  constraints:
                    nullable:  false
              - column:
                  name:  age
                  type:  int
                  constraints:
                    nullable:  false
              - column:
                  name:  contact
                  type:  int
                  constraints:
                    nullable:  false
              - column:
                  name:  address
                  type:  varchar(100)
                  constraints:
                    nullable:  false

# Add a version attribute here
version: 1.0.0
```

update-table-users-05052023.yaml (Updates table - books to add new column - author)

```yaml
databaseChangeLog:
  - changeSet:
      id: 3
      author: pranay.pourkar@test.com
      labels: books
      context: books
      comment: Adding author column to the books table
      changes:
        - addColumn:
            tableName: books
            columns:
              - column:
                  name: author
                  type: varchar(50)
```

Folder structure will look like below

<figure><img src="https://static.wixstatic.com/media/5fb94b_7effe395347b42a0b13a0e3f0adc8146~mv2.png/v1/fill/w_1480,h_304,al_c,q_90,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_7effe395347b42a0b13a0e3f0adc8146~mv2.png" alt="ree"><figcaption></figcaption></figure>

### Liquibase Properties

_**Now, let's create liquibase.properties file to hold liquibase configuration data.**_

<pre><code><strong># Liquibase settings
</strong>driver: com.mysql.cj.jdbc.Driver
classpath: ./mysql-connector-j-8.0.33/mysql-connector-j-8.0.33.jar
url: jdbc:mysql://localhost:3306/liquibase-example-schema?createDatabaseIfNotExist=true
username: root
password: root

<strong># Change log file location
</strong>changeLogFile: ./db/changeLog-master.yaml

<strong># Liquibase logging
</strong>logLevel: info
logFile: ./liquibase.log
</code></pre>

### Overall Structure

Overall the folder structure is as below

<figure><img src="https://static.wixstatic.com/media/5fb94b_4150e360b6944804ac0ce62963403653~mv2.png/v1/fill/w_1480,h_906,al_c,q_90,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_4150e360b6944804ac0ce62963403653~mv2.png" alt="ree"><figcaption></figcaption></figure>

### Execute Changelog Files

_It's time to execute our changelog files._

<figure><img src="https://static.wixstatic.com/media/5fb94b_d55f9a4460424f7a81b2caeea14e6275~mv2.png/v1/fill/w_1480,h_310,al_c,q_90,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_d55f9a4460424f7a81b2caeea14e6275~mv2.png" alt="ree"><figcaption></figcaption></figure>

Run the below liquibase command on the terminal from the root folder of liquibase-example

```
liquibase update
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_f9851b10e71145ea988278846d99e774~mv2.png/v1/fill/w_1480,h_760,al_c,q_90,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_f9851b10e71145ea988278846d99e774~mv2.png" alt="ree"><figcaption></figcaption></figure>

We can from the logs that all the changelog files were applied. Let's us verify from the database as well.

<figure><img src="https://static.wixstatic.com/media/5fb94b_de9682d0c78d4622b68688367a1904ec~mv2.png/v1/fill/w_460,h_980,al_c,q_90,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_de9682d0c78d4622b68688367a1904ec~mv2.png" alt="ree" width="188"><figcaption></figcaption></figure>



Files are attached for the reference below.

{% file src="../../../../.gitbook/assets/liquibase-example (1).zip" %}
