# JPA

## **Task Management API**

### **Problem Statement**

You are developing a simple **Task Management API** for a to-do list application. The API should allow users to **Create**, **Read**, **Update**, and **Delete** tasks stored in a relational database. Each task has a description and an optional priority level.

You are required to implement the backend API using **Spring Boot**, **Spring Data JPA**, and **Hibernate**, following RESTful principles. The application should return proper HTTP status codes and meaningful JSON error messages when something goes wrong. Incomplete code is given and task is to complete it.

### Given

* Java: JDK 8
* Spring Boot: `2.0.5.RELEASE`
* Hibernate: `5.2.17.Final`
* Dependencies:
  * `spring-boot-starter-data-jpa`
  * `spring-boot-starter-web`
* The database schema is pre-configured and running.
* Table schema:

```sql
CREATE TABLE task (
  id BIGINT NOT NULL,
  description VARCHAR(200) NOT NULL,
  priority BIGINT,
  PRIMARY KEY (id)
);
```

### Requirements

#### REST Endpoints

**Create Task**

* Method: `POST /tasks`
*   Request Body:

    ```json
    {
      "description": "Buy groceries",
      "priority": 2
    }
    ```
* Responses:
  * `201 Created`: Task is successfully created.
  *   `400 Bad Request`: If the description is missing or null.

      ```json
      {
        "message": "Task description is required",
        "status": 400
      }
      ```

**Get Task by ID**

* Method: `GET /tasks/{id}`
* Responses:
  * `200 OK`: Returns the task object.
  *   `404 Not Found`: If task does not exist.

      ```json
      {
        "message": "Cannot find task with given id",
        "status": 404
      }
      ```

**Get All Tasks**

* Method: `GET /tasks`
* Response:
  * `200 OK`: Returns a list of all tasks.

**Update Task**

* Method: `PUT /tasks/{id}`
*   Request Body:

    ```json
    {
      "description": "Updated description",
      "priority": 5
    }
    ```
* Behavior:
  * Updates the task's description and priority.
* Responses:
  * `200 OK`: Returns the updated task.
  *   `400 Bad Request`: If the description is missing or null.

      ```json
      {
        "message": "Task description is required",
        "status": 400
      }
      ```
  *   `404 Not Found`: If task does not exist.

      ```json
      {
        "message": "Cannot find task with given id",
        "status": 404
      }
      ```

**Delete Task**

* Method: `DELETE /tasks/{id}`
* Responses:
  * `204 No Content`: If task is successfully deleted.
  *   `404 Not Found`: If task does not exist.

      ```json
      {
        "message": "Cannot find task with given id",
        "status": 404
      }
      ```

### Incomplete Code

The following code snippet has been provided:

```java
package com.codility.tasks.hibernate.solution;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.logging.Logger;

class Task {
}

class TaskController {
  private static Logger log = Logger.getLogger("Solution");
  // log.info("You can use 'log' for debug messages");
}

interface TaskRepository extends JpaRepository<Task, Long> {
}
```

### Solution

#### `Task.java` – Hibernate Entity

```java
package com.codility.tasks.hibernate.solution;

import javax.persistence.*;

@Entity
@Table(name = "task")
class Task {

    @Id
    private Long id;

    @Column(nullable = false)
    private String description;

    private Long priority;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Long getPriority() { return priority; }
    public void setPriority(Long priority) { this.priority = priority; }
}
```

#### `TaskRepository.java`

```java
package com.codility.tasks.hibernate.solution;

import org.springframework.data.jpa.repository.JpaRepository;

interface TaskRepository extends JpaRepository<Task, Long> {
}
```

#### `TaskController.java`

```java
package com.codility.tasks.hibernate.solution;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.logging.Logger;

@RestController
@RequestMapping("/tasks")
@Transactional
class TaskController {

    private static Logger log = Logger.getLogger("Solution");

    @Autowired
    private TaskRepository taskRepository;

    @PostMapping
    public ResponseEntity<?> createTask(@RequestBody Map<String, Object> request) {
        if (!request.containsKey("description") || request.get("description") == null) {
            return ResponseEntity.badRequest().body(error("Task description is required", 400));
        }

        Task task = new Task();
        task.setId(new Random().nextLong());
        task.setDescription((String) request.get("description"));
        task.setPriority(request.get("priority") == null ? null : Long.valueOf(request.get("priority").toString()));
        taskRepository.save(task);
        return ResponseEntity.status(HttpStatus.CREATED).body(request);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getTask(@PathVariable Long id) {
        return taskRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(error("Cannot find task with given id", 404)));
    }

    @GetMapping
    public ResponseEntity<List<Task>> getAllTasks() {
        return ResponseEntity.ok(taskRepository.findAll());
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateTask(@PathVariable Long id, @RequestBody Map<String, Object> request) {
        if (!request.containsKey("description") || request.get("description") == null) {
            return ResponseEntity.badRequest().body(error("Task description is required", 400));
        }

        Optional<Task> optionalTask = taskRepository.findById(id);
        if (!optionalTask.isPresent()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error("Cannot find task with given id", 404));
        }

        Task task = optionalTask.get();
        task.setDescription((String) request.get("description"));
        task.setPriority(request.get("priority") == null ? null : Long.valueOf(request.get("priority").toString()));
        taskRepository.save(task);
        return ResponseEntity.ok(request);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteTask(@PathVariable Long id) {
        if (!taskRepository.existsById(id)) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error("Cannot find task with given id", 404));
        }
        taskRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    private Map<String, Object> error(String message, int status) {
        Map<String, Object> error = new HashMap<>();
        error.put("message", message);
        error.put("status", status);
        return error;
    }
}
```





