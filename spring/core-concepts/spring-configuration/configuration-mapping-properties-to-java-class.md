# Mapping Properties to Java Class

## About

It is possible to map the data given in the spring application yaml/json/properties file with the java class directly. This process, known as mapping, allows to directly link the data in the configuration files to corresponding fields in Java classes. With this. it is easy the update the data directly in the properties file without need to build the application again.

## <mark style="background-color:purple;">**Example 1**</mark>**: Mapping payment purposes which are available in different languages.**

Define the properties in **application.yaml** file.

```yaml
payment:
  purpose:
    purposeEn:
      - 'Others'
      - 'Holidays'
    purposeAr:
                                                                      'آحرون' - 
                                                                     'العطل' -      
    purposeFr:
      - 'Autres'
      - 'Vacances'
```

Create **PaymentPurposes.java** class

```java
package org.example.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@ConfigurationProperties(prefix = "payment.purpose")
@Data
public class PaymentPurposes {
    private List<String> purposeEn;
    private List<String> purposeAr;
    private List<String> purposeFr;
}
```

## <mark style="background-color:purple;">**Example 2**</mark>**: Map the parent-child hierarchy property of transaction category.**

Define the properties in **application.yaml** file.

```yaml
transaction:
  category-details:
    categories:
      - name: 'General'
        code: 'G1'
        subcategories:
          - name: 'Miscellaneous'
            code: 'M1'
          - name: 'Shopping'
            code: 'S1'
      - name: 'Travel'
        code: 'T1'
        subcategories:
          - name: 'Flight'
            code: 'F1'
          - name: 'Hotel'
            code: 'H1'
```

Create **TransactionCategories.java** class

```java
package org.example.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@ConfigurationProperties(prefix = "transaction.category-details")
@Data
public class TransactionCategories {
    private List<Category> categories;

    @Data
    public static class Category {
        private String name;
        private String code;
        private List<Subcategory> subcategories;
    }

    @Data
    public static class Subcategory {
        private String name;
        private String code;
    }
}
```

## <mark style="background-color:purple;">**Example 3**</mark>**: Map the key value pairs of message templates**

Define the properties in **application.yaml** file.

```yaml
messaging:
  templates:
    welcome: "Welcome to our messaging app! We're glad to have you on board."
    invitation: "You've been invited to join a group chat. Click the link to join."
    notification: "You have a new message. Click here to view it."
```

Create **MessagingTemplates.java** class

```java
package org.example.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.util.Map;

@Component
@ConfigurationProperties(prefix = "messaging")
@Data
public class MessagingTemplates {
    private Map<String, String> templates;
}
```

**Add Integration Tests to test above 3 examples.**

```java
package org.example;

import lombok.extern.slf4j.Slf4j;
import org.example.config.MessagingTemplates;
import org.example.config.PaymentPurposes;
import org.example.config.TransactionCategories;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@Slf4j
@SpringBootTest
 class SampleIT {

    @Autowired
    private PaymentPurposes paymentPurposes;

    @Autowired
    private TransactionCategories transactionCategories;

    @Autowired
    private MessagingTemplates messagingTemplates;

    @Test
    void testPaymentProperties() {
        log.info("Properties: {}", paymentPurposes);
        Assertions.assertEquals("Others", paymentPurposes.getPurposeEn().get(0));
        Assertions.assertEquals("آحرون", paymentPurposes.getPurposeAr().get(0));
        Assertions.assertEquals("Autres", paymentPurposes.getPurposeFr().get(0));
    }

    @Test
    void testTransactionCategories() {
        log.info("TransactionCategories: {}", transactionCategories);
        Assertions.assertEquals(2, transactionCategories.getCategories().size());
    }


    @Test
    void testMessagingTemplates() {
        log.info("MessagingTemplates: {}", messagingTemplates);
        Assertions.assertEquals(3, messagingTemplates.getTemplates().size());
    }
}
```

<figure><img src="../../../.gitbook/assets/image (250).png" alt=""><figcaption><p>Output</p></figcaption></figure>

{% hint style="info" %}
Make sure to include below dependencies and failsafe plugin to test

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
</dependency>

<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter-engine</artifactId>
    <scope>test</scope>
</dependency>

<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-failsafe-plugin</artifactId>
        <version>2.22.2</version>
        <executions>
            <execution>
                <goals>
                    <goal>integration-test</goal>
                    <goal>verify</goal>
                </goals>
            </execution>
        </executions>
</plugin>
```
{% endhint %}

## <mark style="background-color:purple;">**Example 4**</mark>**: Mapping card types and fees in a Map.**

Define the properties in **application.yaml** file.

```yaml
bank:
  credit:
    cards:
      fees:
        platinum:
          fee: "5.0"
          vat: "5.0"
        lifestyle:
          fee: "5.0"
          vat: "5.0"
```

Create **CardProperties.java** class

```java
package org.example.config;

import java.util.Map;
import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConfigurationProperties(prefix = "bank.credit.cards")
@Getter
@Setter
public class CardProperties {

    private Map<String, Map<String, String>> fees;

}
```
