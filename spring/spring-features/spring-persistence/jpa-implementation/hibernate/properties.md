# Properties

Hibernate 6.4 supports a range of configuration properties that can be utilized within Spring Boot applications. Below is a categorized list of some commonly used properties:​

## **General Settings**

* **`hibernate.dialect`**: Specifies the SQL dialect.
  * Example: `org.hibernate.dialect.MySQL8Dialect`​
* **`hibernate.show_sql`**: Enables logging of SQL statements.
  * Example: `true`​
* **`hibernate.format_sql`**: Formats the SQL statements in the log.
  * Example: `true`
* **`hibernate.hbm2ddl.auto`**: Controls the automatic schema generation.
  * Options: `validate`, `update`, `create`, `create-drop`, `none`​

## **JDBC and Connection Settings**

* **`hibernate.connection.driver_class`**: JDBC driver class.
  * Example: `com.mysql.cj.jdbc.Driver`​
* **`hibernate.connection.url`**: JDBC connection URL.
  * Example: `jdbc:mysql://localhost:3306/yourdb`​
* **`hibernate.connection.username`**: Database username.
  * Example: `root`​
* **`hibernate.connection.password`**: Database password.
  * Example: `password`​
* **`hibernate.connection.pool_size`**: Specifies the size of the connection pool.
  * Example: `10`​

## **Caching**

* **`hibernate.cache.use_second_level_cache`**: Enables second-level caching.
  * Example: `true`​
* **`hibernate.cache.region.factory_class`**: Specifies the cache region factory.
  * Example: `org.hibernate.cache.jcache.JCacheRegionFactory`​
* **`hibernate.cache.provider_class`**: Specifies the cache provider class.
  * Example: `org.ehcache.jsr107.EhcacheCachingProvider`​

## **Batch Processing**

* **`hibernate.jdbc.batch_size`**: Defines the batch size for JDBC batch updates.
  * Example: `30`​
* **`hibernate.order_inserts`**: Orders insert statements for batch processing.
  * Example: `true`​
* **`hibernate.order_updates`**: Orders update statements for batch processing.
  * Example: `true`​

## **Logging and Statistics**

* **`hibernate.generate_statistics`**: Enables generation of statistics.
  * Example: `true`​
* **`hibernate.use_sql_comments`**: Adds comments to SQL statements.
  * Example: `true`​

## **Multi-Tenancy**

* **`hibernate.multiTenancy`**: Specifies the multi-tenancy strategy.
  * Options: `NONE`, `DATABASE`, `SCHEMA`, `DISCRIMINATOR`​
* **`hibernate.tenant_identifier_resolver`**: Specifies the tenant identifier resolver class.
  * Example: `com.example.TenantIdentifierResolver`​

## **Envers (Auditing)**

* **`org.hibernate.envers.audit_table_suffix`**: Suffix for audit tables.
  * Example: `_AUD`​
* **`org.hibernate.envers.revision_field_name`**: Name of the revision field.
  * Example: `REV`​
* **`org.hibernate.envers.revision_type_field_name`**: Name of the revision type field.
  * Example: `REVTYPE`​
