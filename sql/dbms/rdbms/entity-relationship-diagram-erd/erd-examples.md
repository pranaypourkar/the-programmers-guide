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

<figure><img src="../../../../.gitbook/assets/image.png" alt="" width="476"><figcaption></figcaption></figure>

### Step 3: Cardinality Identification

* A student can be assigned multiple courses
* A course can be enrolled by multiple students
* A professor can deliver only one course

<figure><img src="../../../../.gitbook/assets/image (1).png" alt="" width="563"><figcaption></figcaption></figure>

### Step 4: Identify Attributes

* Student: StudentId, StudentName, StudentAge
* Course: CourseID, CourseName
* Professor: EmployeeId, ProfessorName, EmployeeAge

<figure><img src="../../../../.gitbook/assets/image (2).png" alt="" width="563"><figcaption></figcaption></figure>

### Step 5: Create ERD Diagram

<figure><img src="../../../../.gitbook/assets/image (94).png" alt="" width="563"><figcaption></figcaption></figure>





