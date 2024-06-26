# ERD Examples

## University

We have a university where a Student enrolls in courses. A Student must be assigned to at least one or more Courses. Each Course is taught by a single Professor. A Professor can deliver only one course.

### Step 1: Entity Identification

* Student
* Course
* Professor

### Step 2: Relationship Identification

* Student is assigned a course
* Professor teaches a course

<figure><img src="../../../../.gitbook/assets/image (5) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="476"><figcaption></figcaption></figure>

### Step 3: Cardinality Identification

* A student can be assigned multiple courses
* A course can be enrolled by multiple students
* A professor can deliver only one course

<figure><img src="../../../../.gitbook/assets/image (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="563"><figcaption></figcaption></figure>

### Step 4: Identify Attributes

* Student: StudentId, StudentName, StudentAge
* Course: CourseID, CourseName
* Professor: EmployeeId, ProfessorName, EmployeeAge

<figure><img src="../../../../.gitbook/assets/image (2) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="563"><figcaption></figcaption></figure>

{% hint style="success" %}
Note the underlined primary key attribute
{% endhint %}

### Step 5: Create ERD Diagram

<figure><img src="../../../../.gitbook/assets/image (94).png" alt="" width="563"><figcaption></figcaption></figure>



## MySQL Sample ERD Diagrams

### Employee - Department

[https://www3.ntu.edu.sg/home/ehchua/programming/sql/SampleDatabases.html](https://www3.ntu.edu.sg/home/ehchua/programming/sql/SampleDatabases.html)

<figure><img src="../../../../.gitbook/assets/SampleEmployees.png" alt="" width="485"><figcaption></figcaption></figure>

