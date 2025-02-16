# Serialization & Deserialization

## About

**Serialization** and **Deserialization** are processes in Java (and in other programming languages) that involve converting an object into a stream of bytes to store its state persistently or to transmit it over a network, and then reconstructing the object from that stream.

{% hint style="info" %}
Whenever an object is Serialized, the object is stamped with a version ID number for the object class. This ID is called the SerialVersionUID. This is used during deserialization to verify that the sender and receiver that are compatible with the Serialization.
{% endhint %}

## Serialization

* **Definition**: Serialization is the process of converting an object into a byte stream so that it can be stored in a file, sent over a network, or persisted in a database.
* **Purpose**:
  * **Persistence**: Save the state of an object for later retrieval.
  * **Communication**: Transmit objects between applications or across a network.
* **Mechanism**:
  * In Java, the `Serializable` interface marks a class as serializable. It is a marker interface without any methods.
  * Objects of a serializable class can be converted into a stream of bytes using `ObjectOutputStream`.
  * Variables that are marked as transient will not be a part of the serialization. So we can skip the serialization for the variables in the file by using a transient keyword.
*   **Example**:

    ```java
    import java.io.*;

    public class SerializationExample {
        public static void main(String[] args) {
            // Creating an object of class Student
            Student student = new Student("John Doe", 25, "Computer Science");

            // Serialization
            try {
                FileOutputStream fileOut = new FileOutputStream("student.ser");
                ObjectOutputStream out = new ObjectOutputStream(fileOut);
                out.writeObject(student);
                out.close();
                fileOut.close();
                System.out.println("Object serialized successfully.");
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
    ```

## Deserialization

* **Definition**: Deserialization is the process of reconstructing an object from a serialized byte stream.
* **Purpose**:
  * Restore the state of an object previously serialized.
  * Receive and reconstruct objects transmitted over a network or read from storage.
* **Mechanism**:
  * In Java, use `ObjectInputStream` to read the serialized byte stream and reconstruct the object.
  * The class of the deserialized object must have the same serialVersionUID as when it was serialized to ensure compatibility.
*   **Example**:

    ```java
    import java.io.*;

    public class DeserializationExample {
        public static void main(String[] args) {
            // Deserialization
            try {
                FileInputStream fileIn = new FileInputStream("student.ser");
                ObjectInputStream in = new ObjectInputStream(fileIn);
                Student student = (Student) in.readObject();
                in.close();
                fileIn.close();
                System.out.println("Object deserialized successfully.");
                System.out.println("Name: " + student.getName());
                System.out.println("Age: " + student.getAge());
                System.out.println("Major: " + student.getMajor());
            } catch (IOException | ClassNotFoundException e) {
                e.printStackTrace();
            }
        }
    }
    ```
