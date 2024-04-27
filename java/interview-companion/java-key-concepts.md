# Java Key Concepts

1. Why main method is always declared with **public static void**

In Java, `public static void main(String[] args)` is the entry point of any Java program. L

* `public`: It means that the `main` method can be accessed from anywhere. It's necessary because the Java Virtual Machine (JVM) needs to access this method to start the execution of the program.
* `static`: It means that the `main` method belongs to the class itself, rather than to any instance of the class. This is because Java starts the program before any objects are created.
* `void`: It indicates that the `main` method doesn't return any value.
* `main`: This is the name of the method. `main` is a special method name recognized by the JVM.
* `(String[] args)`: This is the parameter that `main` accepts. `args` is an array of strings that can be passed to the program from the command line. These are typically arguments that you want to pass to your program when you run it.

So, when we run a Java program from the command line, we can pass arguments to it like this. `args` will contain `["arg1", "arg2", "arg3"]`, and we can access these values inside the `main` method.

```
java SomeClassName arg1 arg2 arg3
```

2. Rules for variable names in Java:
   * Variable names must begin with a letter (a-z or A-Z), an underscore (\_), or a currency character ($ or €).
   * First character of a variable name cannot be a digit. It can start with currency or underscore also.
   * Variable names are case-sensitive, meaning `myVariable` and `MyVariable` are considered different variables.
   * Variable names cannot be a Java keyword or reserved word, such as `int`, `class`, `public`, etc





