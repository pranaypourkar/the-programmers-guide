# Thymeleaf Integration

## About

Thymeleaf is a **server-side Java template engine** that is commonly used in web development, particularly in Java-based applications. It allows developers to create dynamic web pages by combining HTML templates with server-side data and logic.

Thymeleaf uses a syntax that is similar to HTML, making it relatively easy for developers to learn and use. Thymeleaf allows us to use the full power of Java within our templates, including conditional statements, loops, variables, and method invocations. This makes it flexible and powerful for handling complex rendering scenarios. Compared to client-side rendering frameworks, server-side rendering with Thymeleaf may have a performance overhead due to the need for server processing. If we have complex client-side logic, we may need to integrate Thymeleaf with a separate JavaScript framework.

In Thymeleaf, **"th:"** is a prefix used to indicate Thymeleaf-specific attributes within HTML templates. It is used to define and manipulate data in the template, control rendering behavior, and perform various other operations. The **"th:"** prefix stands for "Thymeleaf".

For example, some commonly used Thymeleaf attributes include:

* **"th:text"**: Sets the text value of an HTML element based on the provided expression.
* **"th:if"** and **"th:unless"**: Conditionally renders or omits an HTML element based on a specified condition.
* **"th:each"**: Iterates over a collection and renders HTML elements for each item in the collection.

## Features of Thymeleaf

* **Server-side rendering**: Thymeleaf enables server-side rendering of web pages, which means that the HTML templates are processed on the server before being sent to the client's browser. This allows for the dynamic generation of web content based on data from the server.
* **Data binding**: Thymeleaf provides a way to bind data from the server to the HTML templates. It allows us to insert data dynamically into the templates, making it easy to display and manipulate server-side data on the client side.
* **Template layout**: Thymeleaf supports the creation of reusable templates and layout components, which can be shared across multiple pages. This makes it easier to maintain consistent designs and improve code reusability.
* **Integration with Spring Framework**: Thymeleaf integrates well with the Spring Framework, especially with the Spring Boot ecosystem. It is the default template engine for Spring Boot applications, providing seamless integration with other Spring features and libraries.

Overall, Thymeleaf is a powerful and popular choice for server-side Java web development, particularly in the Spring Boot ecosystem. Its simplicity, integration with Spring, and the ability to leverage the full power of Java within templates make it a compelling option for building dynamic web applications.

For more details, visit the official site - [https://www.thymeleaf.org/index.html](https://www.thymeleaf.org/index.html)

## Use Case

#### To build a login and dashboard using Thymeleaf and Spring Boot, combining the flexibility of server-side rendering with the security of database validation.

Setting up of MySQL using docker-compose method. Later on, we will connect this instance with MySQL Workbench and create user\_credentials table along with test data.

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

Start the mysql instance

```
docker-compose up db-mysql
```

<figure><img src="../../.gitbook/assets/thymeleaf-integration-1 (1).png" alt=""><figcaption></figcaption></figure>

Open the MySQL Workbench and execute below SQL commands.

<figure><img src="https://static.wixstatic.com/media/5fb94b_5be3abc5550743d8852ac9bf31f0d90a~mv2.png/v1/fill/w_1480,h_420,al_c,q_90,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_5be3abc5550743d8852ac9bf31f0d90a~mv2.png" alt="ree"><figcaption></figcaption></figure>



<figure><img src="https://static.wixstatic.com/media/5fb94b_253eeac5e876462d97b7989a86ce3e9a~mv2.png/v1/fill/w_1480,h_818,al_c,q_90,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_253eeac5e876462d97b7989a86ce3e9a~mv2.png" alt="ree"><figcaption></figcaption></figure>

_**Let's proceed with creating our Springboot project**_

Add the below dependencies in pom.xml file.

pom.xml

```xml
       <!-- Spring Boot Starter Web -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <!-- Spring Boot Thymeleaf -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-thymeleaf</artifactId>
        </dependency>
        <!-- Spring Boot Starter Data JPA -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
        <!-- MySQL Connector/J -->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
        </dependency>
         <!-- Lombok -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
         <!-- Spring Dev Tools -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
            <scope>runtime</scope>
            <optional>true</optional>
        </dependency>
```

application.yaml

```yaml
server:
  port: 4141

spring:
  thymeleaf:
    enabled: true
    prefix: classpath:/templates/
    suffix: .html
    mode: HTML
  resources:
    static-locations: classpath:/static/
  datasource:
    url: jdbc:mysql://localhost:3306/users
    username: root
    password: root
    driver-class-name: com.mysql.cj.jdbc.Driver
```

_**We will be using HTML templates available for use freely in the project. Download the login and dashboard template from the below sites**_

Login Template - [https://colorlib.com/wp/template/login-form-v8/](https://colorlib.com/wp/template/login-form-v8/)

Dashboard Template - [https://html.design/?s=digit](https://html.design/?s=digit)

Create a folder structure like below add the files in the respective folder

<figure><img src="https://static.wixstatic.com/media/5fb94b_ee1f3ed400e24d5fb64bb029c8045383~mv2.png/v1/fill/w_624,h_1232,al_c,q_90,enc_avif,quality_auto/5fb94b_ee1f3ed400e24d5fb64bb029c8045383~mv2.png" alt="ree" width="375"><figcaption></figcaption></figure>

Later, we have the update the path in the html files like below as well as update the attribute to Thymeleaf attributes. For example below.

<figure><img src="https://static.wixstatic.com/media/5fb94b_fadd7d6c915d4865b703f28b50f060a6~mv2.png/v1/fill/w_1480,h_720,al_c,q_90,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_fadd7d6c915d4865b703f28b50f060a6~mv2.png" alt="ree"><figcaption></figcaption></figure>

<figure><img src="https://static.wixstatic.com/media/5fb94b_d2c7b7a923d14316afe87acf2a45ac04~mv2.png/v1/fill/w_1480,h_622,al_c,q_90,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_d2c7b7a923d14316afe87acf2a45ac04~mv2.png" alt="ree"><figcaption></figcaption></figure>

Also, I have added logic to the existing html and css file to highlight when user credential is incorrect.

<figure><img src="https://static.wixstatic.com/media/5fb94b_f62ac53ca2a749fb92a8f79e329a242f~mv2.png/v1/fill/w_1480,h_380,al_c,q_90,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_f62ac53ca2a749fb92a8f79e329a242f~mv2.png" alt="ree"><figcaption></figcaption></figure>

<figure><img src="https://static.wixstatic.com/media/5fb94b_58347f0cd6fc4f70b5a5a1b2acd53cde~mv2.png/v1/fill/w_1480,h_382,al_c,q_90,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_58347f0cd6fc4f70b5a5a1b2acd53cde~mv2.png" alt="ree"><figcaption></figcaption></figure>

_**Next, we can proceed with creating the required Java classes.**_

Main Application class

Application.java

```java
package com.company.project;

import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.SpringApplication;

@SpringBootApplication
public class Application {

    public static void main(final String[] args) {
        SpringApplication.run(Application.class, args);
    }
} 
```

Controller class with 2 methods. One method to show login page and other method which gets into action after submitting the login form by entering the credentials.

LoginController.java

```java
package com.company.project.api;

import com.company.project.repository.UserRepository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@RestController
@RequestMapping("/page")
public class LoginController {

    private final UserRepository userRepository;

    @GetMapping("/login")
    public ModelAndView showLoginPage() {
        return new ModelAndView("login/index");
    }

    @PostMapping("/login")
    public ModelAndView processLoginForm(@RequestParam("username") String username,
                                         @RequestParam("password") String password) {
        ModelAndView modelAndView;
        boolean userExists = userRepository.existsByUsernameAndPassword(username, password);
        if (userExists) {
            modelAndView = new ModelAndView("dashboard/index");
        } else {
            modelAndView = new ModelAndView("login/index");
            modelAndView.addObject("errorMessage", "Invalid username or password.");
        }
        return modelAndView;
    }
}
```

**Of course, we have make model class for the user\_credentials as well as repository class.**

UserCredentials.java

```java
package com.company.project.model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "user_credentials")
public class UserCredentials {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String username;
    private String password;
    private String email;
}
```

UserRepository.java

```java
package com.company.project.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.company.project.model.UserCredentials;

public interface UserRepository extends JpaRepository<UserCredentials, Long> {
    boolean existsByUsernameAndPassword(String username, String password);
}
```

Overall, project structure is as below

<figure><img src="https://static.wixstatic.com/media/5fb94b_1fb5d7806bc943bf937f680cbf9eac3e~mv2.png/v1/fill/w_510,h_940,al_c,q_90,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_1fb5d7806bc943bf937f680cbf9eac3e~mv2.png" alt="ree" width="375"><figcaption></figcaption></figure>

It's time to run the application and see it in action.

<figure><img src="https://static.wixstatic.com/media/5fb94b_26302b9f72374459a3471228f9384ed3~mv2.png/v1/fill/w_1480,h_558,al_c,q_90,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_26302b9f72374459a3471228f9384ed3~mv2.png" alt="ree"><figcaption></figcaption></figure>

Navigate to this url - [http://localhost:4141/page/login](http://localhost:4141/page/login)

<figure><img src="https://static.wixstatic.com/media/5fb94b_5a3b47dc01334e71835744400e7b9053~mv2.png/v1/fill/w_1480,h_778,al_c,q_90,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_5a3b47dc01334e71835744400e7b9053~mv2.png" alt="ree"><figcaption></figcaption></figure>

\


Case 1: Enter incorrect credential

| <p><br></p><div><figure><img src="https://static.wixstatic.com/media/5fb94b_cee587cf06bd4d299a113ecabd1f462d~mv2.png/v1/fill/w_706,h_938,al_c,q_90,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_cee587cf06bd4d299a113ecabd1f462d~mv2.png" alt="ree"><figcaption></figcaption></figure></div><p><br></p> | <p><br></p><div><figure><img src="https://static.wixstatic.com/media/5fb94b_9a74f5c16d1746fa935d88bfe0d61eeb~mv2.png/v1/fill/w_688,h_914,al_c,q_90,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_9a74f5c16d1746fa935d88bfe0d61eeb~mv2.png" alt="ree"><figcaption></figcaption></figure></div><p><br></p> |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

Case 2: Enter correct credential

| <p><br></p><div><figure><img src="https://static.wixstatic.com/media/5fb94b_e5fccff2ec21453b92adc877a1c6a8f8~mv2.png/v1/fill/w_440,h_584,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_e5fccff2ec21453b92adc877a1c6a8f8~mv2.png" alt="ree"><figcaption></figcaption></figure></div><p><br></p> | <p>​</p><div><figure><img src="https://static.wixstatic.com/media/5fb94b_8793f375c2074c13be6f670c2e2945d5~mv2.png/v1/fill/w_954,h_472,al_c,q_90,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_8793f375c2074c13be6f670c2e2945d5~mv2.png" alt="ree"><figcaption></figcaption></figure></div><p><br></p> |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

Attached below are the files for reference.

{% file src="../../.gitbook/assets/sample-thymeleaf-service.zip" %}
