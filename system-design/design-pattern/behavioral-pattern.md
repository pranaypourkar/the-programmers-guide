# Behavioral Pattern

## Description

Behavioral patterns in software engineering focus on the interactions and responsibilities among objects. They address how objects communicate with each other to accomplish tasks and responsibilities efficiently. These patterns primarily deal with the algorithms and responsibilities of objects in a system, emphasizing the interaction between objects and their behavior.



## Types of Behavioral Pattern

### **Chain of Responsibility Pattern**

#### Description

The Chain of Responsibility Pattern is a behavioral design pattern that allows you to chain multiple objects together to handle a request in a sequential manner. When a request is made, it is passed along the chain of objects until one of them handles it. Each object in the chain has the option to handle the request or pass it to the next object in the chain.

#### **Benefits of Chain of Responsibility Pattern**

* **Decoupling request sender and handler:** The sender only interacts with the first handler in the chain, promoting loose coupling.
* **Flexible handling:** Allows adding new handlers to the chain for handling different types of requests.
* **Efficient handling:** Stops processing the request as soon as a handler handles it successfully.

#### **Drawbacks of Chain of Responsibility Pattern**

* **Potential for infinite loops:** If the chain is not properly designed, it might create an infinite loop.
* **Increased complexity:** Setting up and managing the chain of handlers can add complexity.
* **Debugging challenges:** Debugging issues within the chain can be more difficult.

#### **When to Use Chain of Responsibility Pattern**

The Chain of Responsibility Pattern is suitable when:

* We have multiple handlers that can potentially handle a request.
* The order of handling requests is important.
* We want to avoid coupling the sender of a request to its specific handle

#### Example 1

Consider a loan approval process where different departments (e.g., credit check, income verification) need to approve a loan application. The Chain of Responsibility Pattern allows for handling the process efficiently.

```java
// Handler Interface (defines the processing method)
public interface LoanApprover {
  LoanApprovalStatus approveLoan(LoanApplication application);
}

// Concrete Handler Classes (handle specific checks)
public class CreditCheckHandler implements LoanApprover {

  private LoanApprover nextHandler;

  public CreditCheckHandler(LoanApprover nextHandler) {
    this.nextHandler = nextHandler;
  }

  @Override
  public LoanApprovalStatus approveLoan(LoanApplication application) {
    // Perform credit check
    if (application.getCreditScore() < 600) {
      return LoanApprovalStatus.REJECTED;
    }
    
    // Delegate to the next handler if credit check passes
    if (nextHandler != null) {
      return nextHandler.approveLoan(application);
    }
    
    return LoanApprovalStatus.APPROVED; // No more handlers, application approved
  }
}

public class IncomeVerificationHandler implements LoanApprover {

  private LoanApprover nextHandler;

  public IncomeVerificationHandler(LoanApprover nextHandler) {
    this.nextHandler = nextHandler;
  }

  @Override
  public LoanApprovalStatus approveLoan(LoanApplication application) {
    // Perform income verification
    if (application.getIncome() < application.getLoanAmount() * 0.1) {
      return LoanApprovalStatus.REJECTED;
    }
    
    // Delegate to the next handler if income verification passes
    if (nextHandler != null) {
      return nextHandler.approveLoan(application);
    }
    
    return LoanApprovalStatus.APPROVED; // No more handlers, application approved
  }
}

// Main Application class
public class Application{
  public static void main(String[] args) {
    LoanApprover creditCheckHandler = new CreditCheckHandler(new IncomeVerificationHandler(null));
    LoanApplication application = new LoanApplication("John Doe", 10000);
    LoanApprovalStatus status = creditCheckHandler.approveLoan(application);
    System.out.println("Loan Approval Status: " + status);
  }
}
```

#### Example 2

Let's consider a example of a purchase approval workflow in an organization. When an employee submits a purchase request, it needs to be approved by multiple managers based on their authority levels. The Chain of Responsibility Pattern can be used to create a chain of approval handlers, where each handler represents a manager with a specific authority level.

In this example, we have an `Approver` interface that defines a common method `approve()` for handling purchase requests. We have a concrete handler class `Manager` that implements the `Approver` interface and represents a manager who can approve purchase requests up to a certain limit. If the request exceeds the manager's approval limit, it is forwarded to the next approver in the chain. The `Application` class sets up the chain of responsibility by linking the managers together and submits purchase requests to the first manager in the chain. Each manager in the chain either approves the request or forwards it to the next manager in the chain.

```java
// Handler: Approver
interface Approver {
    void approve(PurchaseRequest request);
}

// Concrete Handler: Manager
class Manager implements Approver {
    private final String name;
    private final double approvalLimit;
    private Approver nextApprover;

    public Manager(String name, double approvalLimit) {
        this.name = name;
        this.approvalLimit = approvalLimit;
    }

    public void setNextApprover(Approver nextApprover) {
        this.nextApprover = nextApprover;
    }

    @Override
    public void approve(PurchaseRequest request) {
        if (request.getAmount() <= approvalLimit) {
            System.out.println(name + " approved the purchase of $" + request.getAmount());
        } else if (nextApprover != null) {
            nextApprover.approve(request);
        } else {
            System.out.println("None of the managers can approve the purchase");
        }
    }
}

// Client
public class Application {
    public static void main(String[] args) {
        // Create approval handlers
        Approver juniorManager = new Manager("Junior Manager", 1000);
        Approver seniorManager = new Manager("Senior Manager", 5000);
        Approver director = new Manager("Director", Double.POSITIVE_INFINITY);

        // Set up the chain of responsibility
        juniorManager.setNextApprover(seniorManager);
        seniorManager.setNextApprover(director);

        // Submit purchase requests
        PurchaseRequest request1 = new PurchaseRequest(800);
        PurchaseRequest request2 = new PurchaseRequest(3000);
        PurchaseRequest request3 = new PurchaseRequest(10000);

        // Process purchase requests
        juniorManager.approve(request1);
        juniorManager.approve(request2);
        juniorManager.approve(request3);
    }
}

// Request: PurchaseRequest
class PurchaseRequest {
    private final double amount;

    public PurchaseRequest(double amount) {
        this.amount = amount;
    }

    public double getAmount() {
        return amount;
    }
}
```



### Command Pattern

#### Description

The Command Pattern is a behavioral design pattern that encapsulates a request as an object, thereby allowing you to parameterize clients with queues, requests, and operations. It allows you to decouple the sender of a request from its receiver by encapsulating the request as an object, which can be passed, stored, and executed later. This pattern enables you to parameterize objects with operations, queue requests, and support undoable operations.

#### **Benefits of Command Pattern**

* **Decoupling sender and receiver:** Improves code maintainability and flexibility.
* **Parametrized commands:** Allows for flexible execution with different parameters.
* **Command queuing and logging:** Enables storing commands for later execution or audit purposes.

#### **Drawbacks of Command Pattern**

* **Increased complexity:** Introduces additional classes (commands) which can add complexity.
* **Overkill for simple scenarios:** If you only have a few direct interactions, the pattern might be unnecessary.

#### **When to Use Command Pattern**

The Command Pattern is suitable when:

* We want to decouple the sender of a request from the receiver.
* We need to parameterize requests with additional data.
* We want to queue or log commands for later execution or auditing.

#### Example

Let's consider a example of a remote control for electronic devices, such as TVs, DVD players, and lights. The Command Pattern can be used to represent each remote control button as a command object, which encapsulates the action to be performed when the button is pressed.

In this example, we have a `Command` interface that defines a common method `execute()` for executing commands. We have concrete command classes `TurnOnCommand` and `TurnOffCommand` that implement the `Command` interface and encapsulate the actions to turn on and turn off a device. We have a `Device` interface that defines methods for turning on and turning off electronic devices. We have a concrete receiver class `TV` that implements the `Device` interface and represents a TV. We have an invoker class `RemoteControl` that contains commands and invokes their `execute()` method when a button is pressed.

```java
// Command: Command
interface Command {
    void execute();
}

// Concrete Command: TurnOnCommand
class TurnOnCommand implements Command {
    private final Device device;

    public TurnOnCommand(Device device) {
        this.device = device;
    }

    @Override
    public void execute() {
        device.turnOn();
    }
}

// Concrete Command: TurnOffCommand
class TurnOffCommand implements Command {
    private final Device device;

    public TurnOffCommand(Device device) {
        this.device = device;
    }

    @Override
    public void execute() {
        device.turnOff();
    }
}

// Receiver: Device
interface Device {
    void turnOn();
    void turnOff();
}

// Concrete Receiver: TV
class TV implements Device {
    @Override
    public void turnOn() {
        System.out.println("TV is turned on");
    }

    @Override
    public void turnOff() {
        System.out.println("TV is turned off");
    }
}

// Invoker: RemoteControl
class RemoteControl {
    private final Command turnOnCommand;
    private final Command turnOffCommand;

    public RemoteControl(Command turnOnCommand, Command turnOffCommand) {
        this.turnOnCommand = turnOnCommand;
        this.turnOffCommand = turnOffCommand;
    }

    public void pressTurnOnButton() {
        turnOnCommand.execute();
    }

    public void pressTurnOffButton() {
        turnOffCommand.execute();
    }
}

// Main Application 
public class Application {
    public static void main(String[] args) {
        // Create a TV
        Device tv = new TV();

        // Create command objects for turning on and off the TV
        Command turnOnCommand = new TurnOnCommand(tv);
        Command turnOffCommand = new TurnOffCommand(tv);

        // Create a remote control with turn on and turn off buttons
        RemoteControl remoteControl = new RemoteControl(turnOnCommand, turnOffCommand);

        // Press turn on and turn off buttons on the remote control
        remoteControl.pressTurnOnButton();
        remoteControl.pressTurnOffButton();
    }
}
```



### **Interpreter Pattern**

#### Description

The Interpreter Pattern is a behavioral design pattern that defines a grammar for a language and provides a way to evaluate sentences in that language. It allows to represent grammatical rules as objects and provides a mechanism for interpreting sentences written in a language. This pattern is useful when we need to interpret or evaluate expressions, queries, or scripts.

Imagine we have a system that needs to interpret instructions or expressions written in a specific language (domain-specific language). The Interpreter Pattern achieves this by:

1. **Defining an Expression Interface:** This interface declares methods for interpreting expressions in the language.
2. **Creating Concrete Expression Classes:** These classes implement the `Expression` interface and represent specific elements of the language (e.g., variables, operators). Each class defines its interpretation logic.
3. **Creating an Interpreter Class:** This class (optional) manages the context and coordinates the interpretation process. It might call methods on concrete expression objects to evaluate the overall expression.

#### **Benefits of Interpreter Pattern**

* **Easy to extend for new grammar elements:** By adding new concrete expression classes, you can support new operations or elements in the language.
* **Clear separation of concerns:** Separates the definition of the language (expressions) from the interpretation logic.
* **Reusable interpretation logic:** Interpreter code can be reused for different contexts or expressions.

#### **Drawbacks of Interpreter Pattern**

* **Increased complexity:** Introduces additional classes (expressions, interpreter) which can add complexity.
* **Performance overhead:** Interpreting complex expressions might involve method calls and context management, potentially impacting performance.

#### **When to Use Interpreter Pattern**

The Interpreter Pattern is suitable when:

* We need to define a simple language for the system.
* We want to interpret expressions written in that language.
* We anticipate the need to extend the language with new elements in the future.

#### Example

Consider a simple calculator that evaluates mathematical expressions. The Interpreter Pattern allows it to handle different operations.

In this example, the `Expression` interface defines a method to interpret an expression. Concrete expressions like `NumberExpression` and `AdditionExpression` represent elements and implement their interpretation logic. The `Context` class (optional) holds variable values used in the expressions. The `ExpressionEvaluator` class (optional) coordinates the interpretation by calling methods on concrete expression objects.

```java
// Expression Interface (defines interpretation)
public interface Expression {
  int interpret(Context context);
}

// Concrete Expression Classes (represent elements)
public class NumberExpression implements Expression {

  private int number;

  public NumberExpression(int number) {
    this.number = number;
  }

  @Override
  public int interpret(Context context) {
    return number;
  }
}

public class AdditionExpression implements Expression {

  private Expression leftExpression;
  private Expression rightExpression;

  public AdditionExpression(Expression leftExpression, Expression rightExpression) {
    this.leftExpression = leftExpression;
    this.rightExpression = rightExpression;
  }

  @Override
  public int interpret(Context context) {
    return leftExpression.interpret(context) + rightExpression.interpret(context);
  }
}

// Context Class (optional - holds variables)
public class Context {

  private Map<String, Integer> variables;

  public Context() {
    variables = new HashMap<>();
  }

  public void setVariable(String name, int value) {
    variables.put(name, value);
  }

  public int getVariable(String name) {
    return variables.get(name);
  }
}

// Interpreter Class (optional - coordinates interpretation)
public class ExpressionEvaluator {

  private Expression expression;

  public ExpressionEvaluator(Expression expression) {
    this.expression = expression;
  }

  public int evaluate(Context context) {
    return expression.interpret(context);
  }
}

public class Main {
  public static void main(String[] args) {
    Expression expression = new AdditionExpression(
        new NumberExpression(10),
        new AdditionExpression(
            new VariableExpression("x"),
            new NumberExpression(5)
        )
    );
    Context context = new Context();
    context.setVariable("x", 7);
    ExpressionEvaluator evaluator = new ExpressionEvaluator(expression);
    int result = evaluator.evaluate(context);
    System.out.println("Expression result: " + result); // Output: 22
  }
}
```



### **Iterator Pattern**

#### Description

The Iterator Pattern is a behavioral design pattern that provides a way to access the elements of an aggregate object (such as a collection) sequentially without exposing its underlying representation. It allows to traverse a collection of elements without knowing its internal structure, and it provides a uniform interface for iterating over different types of collections.

We can achieve Iterator patter by&#x20;

1. **Defining an Iterator Interface:** This interface declares methods for iterating over an aggregate object, such as `hasNext` to check if there are more elements and `next` to retrieve the next element.
2. **Creating Concrete Iterator Classes:** These classes implement the `Iterator` interface and provide specific logic for iterating over the elements of a particular aggregate type (e.g., ArrayListIterator, HashMapIterator).

#### **Benefits of Iterator Pattern**

* **Decoupling clients from concrete collections:** Clients only use the `Iterator` interface, hiding the implementation details of the underlying collection.
* **Flexible iteration:** Allows for different iteration strategies (e.g., forward, backward) by creating specialized iterators.
* **Safe access:** Ensures clients cannot modify the collection directly through the iterator, promoting safer code.

#### **Drawbacks of Iterator Pattern**

* **Increased complexity:** Introduces an extra layer of abstraction (the iterator) which can add complexity for simple collections.
* **Not always necessary:** For built-in collection classes with good iteration support (e.g., Java's `for-each` loop), the pattern might be redundant.

#### **When to Use Iterator Pattern**

The Iterator Pattern is suitable when:

* We want to hide the internal structure of your collections from client code.
* We want to provide a uniform way to iterate over different collection types.
* We need to support different iteration behaviors (e.g., forward, backward)

Example

Consider a library system with a collection of books. The Iterator Pattern allows iterating through the books without knowing the internal structure of the book collection.

In this example, the `BookIterator` interface defines methods to iterate through books. The `LibraryBookIterator` implements the logic for iterating over a specific `List` of books. The `Library` class provides a method to get an iterator for its book collection. The main program uses the iterator to access books one by one without knowing the internal structure of the `List` in the `Library` class.

```java
// Iterator Interface (defines traversal methods)
public interface BookIterator {
  boolean hasNext();
  Book next();
}

// Concrete Iterator Class (iterates over a Book collection)
public class LibraryBookIterator implements BookIterator {

  private List<Book> books;
  private int currentIdx;

  public LibraryBookIterator(List<Book> books) {
    this.books = books;
    currentIdx = 0;
  }

  @Override
  public boolean hasNext() {
    return currentIdx < books.size();
  }

  @Override
  public Book next() {
    if (hasNext()) {
      Book book = books.get(currentIdx);
      currentIdx++;
      return book;
    }
    throw new NoSuchElementException("No more books in the collection");
  }
}

// Book Class (represents a book in the library)
public class Book {
  // ... book properties (title, author, etc.)
}

// Library Class (holds the book collection)
public class Library {

  private List<Book> books;

  public Library() {
    books = new ArrayList<>();
    // ... add books to the collection
  }

  public BookIterator getIterator() {
    return new LibraryBookIterator(books);
  }
}

public class Main {
  public static void main(String[] args) {
    Library library = new Library();
    BookIterator iterator = library.getIterator();
    while (iterator.hasNext()) {
      Book book = iterator.next();
      System.out.println("Book Title: " + book.getTitle());
    }
  }
}
```



### **Mediator Pattern**

#### Description



### **Memento Pattern**

#### Description





### **Observer Pattern**

#### Description





### **State Pattern**

#### Description





### **Strategy Pattern**

#### Description





### **Template Method Pattern**

#### Description





### **Visitor Pattern**

#### Description

