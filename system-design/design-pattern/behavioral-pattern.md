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

The Mediator Pattern is a behavioral design pattern that promotes loose coupling between objects by encapsulating how they interact and communicate with each other. It defines an object (the mediator) that coordinates the communication between multiple objects (colleagues), allowing them to interact without being directly coupled to each other. This pattern centralizes communication logic, making it easier to manage and maintain complex interactions between objects.

The mediator acts as a central hub for interactions, facilitating communication and reducing dependencies between objects:

1. **Mediator Interface (Optional):** This interface defines methods that objects can use to interact with the mediator. It might include methods for registering objects, sending messages, or notifying about changes.
2. **Concrete Mediator Class:** This class implements the mediator's logic for coordinating communication between objects. It might maintain a list of registered objects, handle message routing, and manage interactions between them.
3. **Colleagues (Concrete Objects):** These objects represent the entities that need to collaborate. They don't directly reference each other, instead, they interact through the mediator.

#### **Benefits of Mediator Pattern**

* **Reduced coupling:** Objects don't depend on each other directly, promoting loose coupling and maintainability.
* **Centralized control:** The mediator can manage communication complexity and enforce rules or coordination between objects.
* **Improved flexibility:** Adding or removing objects becomes easier as they only need to interact with the mediator.

#### **Drawbacks of Mediator Pattern**

* **Increased complexity:** Introduces an additional layer of abstraction (the mediator) which can add complexity.
* **Potential bottleneck:** The mediator might become a bottleneck if it manages a large number of objects and complex interactions.
* **Reduced flexibility for object behavior:** Objects might lose some autonomy as they rely on the mediator for communication.

#### **When to Use Mediator Pattern**

The Mediator Pattern is suitable when:

* We have a complex network of objects that need to communicate frequently.
* We want to reduce coupling between objects and improve maintainability.
* We need centralized control over communication and interactions between objects.

#### Example

Let's consider a example of a chat room application, where users can send messages to each other. The Mediator Pattern can be used to create a chat room mediator that facilitates communication between users without them needing to know about each other.

In this example, we create a `TextChatRoom` mediator object representing a chat room. We create `User` objects representing users in the chat room. Users interact with the chat room by sending messages through the mediator, without needing to know about each other.

```java
// Mediator: ChatRoom
interface ChatRoom {
    void sendMessage(User sender, String message);
}

// Concrete Mediator: TextChatRoom
class TextChatRoom implements ChatRoom {
    @Override
    public void sendMessage(User sender, String message) {
        System.out.println(sender.getName() + " sends message: " + message);
    }
}

// Colleague: User
class User {
    private final String name;
    private final ChatRoom chatRoom;

    public User(String name, ChatRoom chatRoom) {
        this.name = name;
        this.chatRoom = chatRoom;
    }

    public String getName() {
        return name;
    }

    public void sendMessage(String message) {
        chatRoom.sendMessage(this, message);
    }
}

// Main Application class
public class Application {
    public static void main(String[] args) {
        // Create a chat room
        ChatRoom chatRoom = new TextChatRoom();

        // Create users
        User user1 = new User("Alice", chatRoom);
        User user2 = new User("Bob", chatRoom);

        // User1 sends a message
        user1.sendMessage("Hello, Bob!");

        // User2 sends a message
        user2.sendMessage("Hi, Alice!");
    }
}
```



### **Memento Pattern**

#### Description

The Memento Pattern is a behavioral design pattern that allows to capture and externalize an object's internal state without violating encapsulation, so that the object can be restored to this state later. It is often used when we need to provide undo functionality or to save and restore the state of an object.

**Key elements:**

1. **Originator:** The object whose state needs to be captured and restored.
2. **Memento:** An object that stores the saved state of the Originator. It should be lightweight and hold only the necessary data to restore the state.
3. **Caretaker (Optional):** An object responsible for managing the Memento objects. It might provide methods to create and store Mementos, and potentially retrieve them for restoring the Originator's state.

#### **Benefits of Memento Pattern**

* **Reduced memory usage:** Memento objects can be lightweight if they only store essential data for restoration.
* **Improved undo/redo functionality:** Allows implementing undo/redo features by managing a history of Memento objects.
* **Encapsulation:** Hides the internal state of the Originator object.

#### **Drawbacks of Memento Pattern**

* **Increased complexity:** Introduces additional classes (Memento, Caretaker) which can add complexity.
* **Potential memory overhead**

#### Example

Consider a example of a text editor with an undo feature. The Memento Pattern can be used to implement the undo functionality, allowing users to revert changes made to the text.

In this example, we have a `TextMemento` class representing the state of the text editor at a particular point in time. We have a `TextEditor` class representing the text editor, which allows setting and getting the text content, as well as saving and restoring its state using mementos. We have a `TextEditorApp` class acting as a caretaker, which manages the text editor's history of states using a stack.

```java
// Memento: TextMemento
class TextMemento {
    private final String state;

    public TextMemento(String state) {
        this.state = state;
    }

    public String getState() {
        return state;
    }
}

// Originator: TextEditor
class TextEditor {
    private String text;

    public void setText(String text) {
        this.text = text;
    }

    public String getText() {
        return text;
    }

    public TextMemento save() {
        return new TextMemento(text);
    }

    public void restore(TextMemento memento) {
        text = memento.getState();
    }
}

// Caretaker: TextEditorApp
class TextEditorApp {
    private final TextEditor textEditor;
    private final Stack<TextMemento> history;

    public TextEditorApp(TextEditor textEditor) {
        this.textEditor = textEditor;
        this.history = new Stack<>();
    }

    public void typeText(String text) {
        history.push(textEditor.save());
        textEditor.setText(textEditor.getText() + text);
    }

    public void undo() {
        if (!history.isEmpty()) {
            TextMemento memento = history.pop();
            textEditor.restore(memento);
        }
    }
}

// Main Application class
public class Application {
    public static void main(String[] args) {
        // Create a text editor
        TextEditor textEditor = new TextEditor();
        TextEditorApp textEditorApp = new TextEditorApp(textEditor);

        // Type some text
        textEditorApp.typeText("Hello, ");

        // Save the state
        textEditorApp.typeText("world!");

        // Undo the last action
        textEditorApp.undo();

        // Get the current text
        System.out.println(textEditor.getText()); // Output: Hello,
    }
}
```



### **Observer Pattern**

#### Description

The Observer Pattern is a behavioral design pattern that defines a one-to-many dependency between objects so that when one object changes its state, all its dependents are notified and updated automatically. It is commonly used in scenarios where one object's state change should trigger actions in other objects without them being tightly coupled.

**Key Elements**

1. **Subject:** The object that maintains a list of its dependents (observers) and notifies them when its state changes.
2. **Observer:** The interface or abstract class defining the update method that observers implement to be notified of changes.
3. **Concrete Observers:** Classes that implement the Observer interface and define specific logic for handling notifications from the subject.

#### **Benefits of Observer Pattern**

* **Loose coupling:** Observers don't need to know the internal state of the subject, promoting loose coupling.
* **Decoupled updates:** Changes in the subject are automatically propagated to observers, improving flexibility.
* **Efficient handling of multiple observers:** The subject can notify all observers efficiently.

#### **Drawbacks of Observer Pattern**

* **Potential for infinite loops:** If the notification chain is not designed carefully, it could create an infinite loop.
* **Increased complexity:** Introduces additional classes (subject, observer interface) which can add complexity.

#### **When to Use Observer Pattern**

The Observer Pattern is suitable when:

* We need to notify multiple objects about changes in a single object.
* We want to decouple the sender (subject) from the receivers (observers).
* We need to support dynamic attachment and detachment of observers.

#### Example

Consider a example of a weather monitoring system. In this system, various displays need to be updated whenever the weather conditions change. The Observer Pattern can be used to implement this behavior.

In this example, we have a `WeatherStation` interface that defines methods to add, remove, and notify observers. We have a concrete subject class `WeatherData` that implements the `WeatherStation` interface and manages weather data. We have an `Observer` interface that defines the `update()` method to be called when the subject's state changes. We have a concrete observer class `Display` that implements the `Observer` interface and displays weather information.

```java
// Subject: WeatherStation
interface WeatherStation {
    void addObserver(Observer observer);
    void removeObserver(Observer observer);
    void notifyObservers();
}

// Concrete Subject: WeatherData
class WeatherData implements WeatherStation {
    private float temperature;
    private float humidity;
    private float pressure;
    private final List<Observer> observers;

    public WeatherData() {
        observers = new ArrayList<>();
    }

    public void setMeasurements(float temperature, float humidity, float pressure) {
        this.temperature = temperature;
        this.humidity = humidity;
        this.pressure = pressure;
        notifyObservers();
    }

    @Override
    public void addObserver(Observer observer) {
        observers.add(observer);
    }

    @Override
    public void removeObserver(Observer observer) {
        observers.remove(observer);
    }

    @Override
    public void notifyObservers() {
        for (Observer observer : observers) {
            observer.update(temperature, humidity, pressure);
        }
    }
}

// Observer: Observer
interface Observer {
    void update(float temperature, float humidity, float pressure);
}

// Concrete Observer: Display
class Display implements Observer {
    private final String name;

    public Display(String name) {
        this.name = name;
    }

    @Override
    public void update(float temperature, float humidity, float pressure) {
        System.out.println(name + ": Temperature=" + temperature + ", Humidity=" + humidity + ", Pressure=" + pressure);
    }
}

/ Using Observer Pattern in Main Application class
public class Application {
    public static void main(String[] args) {
        // Create weather station and displays
        WeatherStation weatherStation = new WeatherData();
        Observer display1 = new Display("Display 1");
        Observer display2 = new Display("Display 2");

        // Register displays as observers
        weatherStation.addObserver(display1);
        weatherStation.addObserver(display2);

        // Update weather data
        ((WeatherData) weatherStation).setMeasurements(25.5f, 65.2f, 1013.2f);
    }
}
```



### **State Pattern**

#### Description

The State Pattern is a behavioral design pattern that allows an object to alter its behavior when its internal state changes. This pattern is useful when an object needs to change its behavior dynamically depending on its state, without a proliferation of conditional statements. It encapsulates the states of an object into separate classes and delegates the state-specific behavior to these classes.

**Key Elements**

1. **Context:** The object whose behavior changes based on its state. It holds a reference to the current state object.
2. **State Interface:** Defines an interface for all state objects. This interface typically declares a method to perform an action relevant to the state.
3. **Concrete State Classes:** Implement the State interface and define the behavior specific to a particular state.

#### **Benefits of State Pattern**

* **Improved code maintainability:** State logic is encapsulated in separate classes, making code easier to understand and modify.
* **Loose coupling:** The context object doesn't depend on the implementation details of concrete state classes.
* **Flexible behavior changes:** Adding new states is easier as it only involves creating a new concrete state class.

#### **Drawbacks of State Pattern**

* **Increased complexity:** Introduces additional classes (states, interface) which can add complexity for simple scenarios.
* **State explosion:** As the number of states grows, managing them can become cumbersome.

#### **When to Use State Pattern**

The State Pattern is suitable when:

* An object's behavior changes significantly based on its internal state.
* You want to encapsulate state-specific logic and avoid complex conditional statements in the main object.
* You anticipate the need to add new states in the future.

#### Example

Consider a example of a traffic light system, where the behavior of a traffic light changes based on its current state. The State Pattern can be used to implement this behavior.

In this example, we have a `TrafficLight` class representing the context, which maintains a reference to the current state of the traffic light. We have a `State` interface defining a common method `change()` for changing the state of the traffic light. We have concrete state classes (`RedState`, `GreenState`, and `YellowState`) representing different states of the traffic light and implementing the `State` interface. Each state class defines its behavior when the traffic light changes to that state.

```java
// Context: TrafficLight
class TrafficLight {
    private State state;

    public TrafficLight() {
        // Set initial state
        state = new RedState();
    }

    public void setState(State state) {
        this.state = state;
    }

    public void change() {
        state.change(this);
    }
}

// State: State
interface State {
    void change(TrafficLight trafficLight);
}

// Concrete States: RedState, GreenState, YellowState
class RedState implements State {
    @Override
    public void change(TrafficLight trafficLight) {
        System.out.println("Traffic light turns red");
        trafficLight.setState(new GreenState());
    }
}

class GreenState implements State {
    @Override
    public void change(TrafficLight trafficLight) {
        System.out.println("Traffic light turns green");
        trafficLight.setState(new YellowState());
    }
}

class YellowState implements State {
    @Override
    public void change(TrafficLight trafficLight) {
        System.out.println("Traffic light turns yellow");
        trafficLight.setState(new RedState());
    }
}

// Using State Pattern
public class Application {
    public static void main(String[] args) {
        TrafficLight trafficLight = new TrafficLight();

        // Change traffic light states
        trafficLight.change(); // Red -> Green
        trafficLight.change(); // Green -> Yellow
        trafficLight.change(); // Yellow -> Red
    }
}
```



### **Strategy Pattern**

#### Description

The Strategy Pattern is a behavioral design pattern that defines a family of algorithms, encapsulates each one, and makes them interchangeable. It allows a client to choose the appropriate algorithm from the family at runtime without modifying the client code. This pattern enables algorithms to vary independently from the clients that use them.

**Key Elements**

1. **Strategy Interface:** This interface defines the method(s) that all concrete strategy classes must implement. This ensures a consistent way to execute the algorithm.
2. **Concrete Strategy Classes:** These classes implement the `Strategy` interface and provide the specific logic for each algorithm variation.
3. **Context:** The object that uses the strategy. It holds a reference to a concrete strategy object and delegates the work to it.

#### **Benefits of Strategy Pattern**

* **Improved code reusability:** Algorithms are encapsulated in separate classes, promoting reuse across different parts of the application.
* **Flexible algorithm selection:** The context can easily switch between different sorting strategies at runtime.
* **Open/Closed Principle compliance:** New sorting algorithms can be added without modifying existing code.

#### **Drawbacks of Strategy Pattern**

* **Increased complexity:** Introduces additional classes (strategies, interface) which can add complexity for simple algorithms.
* **Performance overhead:** Method calls and object creation for strategies might introduce slight overhead compared to directly implementing the logic.

#### **When to Use Strategy Pattern**

The Strategy Pattern is suitable when:

* We need to use different algorithms for a specific task in an application.
* We anticipate the need to add new algorithms in the future.
* We want to decouple the selection of the algorithm from the code that uses it.

#### Example

Consider a example of sorting algorithms, where different sorting algorithms can be applied interchangeably depending on the requirements. The Strategy Pattern can be used to implement this behavior.

In this example, we have a `SortingStrategy` interface defining a common method `sort()` for sorting algorithms. We have concrete strategy classes (`BubbleSortStrategy` and `QuickSortStrategy`) representing different sorting algorithms and implementing the `SortingStrategy` interface. Each strategy class encapsulates a specific sorting algorithm. We have a `Sorter` class acting as a context, which maintains a reference to the current sorting strategy. The `Sorter` class has a method `performSort()` that delegates the sorting task to the selected strategy.

```java
// Strategy: SortingStrategy
interface SortingStrategy {
    void sort(int[] array);
}

// Concrete Strategies: BubbleSortStrategy, QuickSortStrategy
class BubbleSortStrategy implements SortingStrategy {
    @Override
    public void sort(int[] array) {
        // Implement bubble sort algorithm
        System.out.println("Sorting array using Bubble Sort");
        // Sorting logic...
    }
}

class QuickSortStrategy implements SortingStrategy {
    @Override
    public void sort(int[] array) {
        // Implement quick sort algorithm
        System.out.println("Sorting array using Quick Sort");
        // Sorting logic...
    }
}

// Context: Sorter
class Sorter {
    private SortingStrategy strategy;

    public void setStrategy(SortingStrategy strategy) {
        this.strategy = strategy;
    }

    public void performSort(int[] array) {
        strategy.sort(array);
    }
}

// Using Strategy Pattern
public class Application {
    public static void main(String[] args) {
        Sorter sorter = new Sorter();

        // Use Bubble Sort strategy
        sorter.setStrategy(new BubbleSortStrategy());
        int[] array1 = {5, 3, 8, 1, 2};
        sorter.performSort(array1);

        // Use Quick Sort strategy
        sorter.setStrategy(new QuickSortStrategy());
        int[] array2 = {7, 4, 6, 9, 0};
        sorter.performSort(array2);
    }
}
```



### **Template Method Pattern**

#### Description

The Template Method Pattern is a behavioral design pattern that defines the skeleton of an algorithm in a method, deferring some steps to subclasses. It allows subclasses to redefine certain steps of an algorithm without changing its structure, promoting code reuse and providing a common structure for related algorithms.

**Key Elements**

1. **Abstract Class (Template):** Defines the overall structure of the algorithm with a combination of:
   * **Fixed steps:** Implemented directly in the superclass.
   * **Abstract methods:** To be implemented by subclasses, defining the variation points in the algorithm.
2. **Concrete Subclasses:** Inherit the template and implement the abstract methods with their specific logic, customizing the algorithm's behavior.

#### **Benefits of Template Method Pattern**

* **Code reuse:** Promotes code reuse by defining the common structure of the algorithm in the superclass.
* **Consistent structure:** Ensures a consistent overall structure for the algorithm across subclasses.
* **Customization:** Allows subclasses to customize the algorithm's behavior by implementing abstract methods.
* **Open/Closed Principle compliance:** Different behaviors can be added without modifying the existing code.

#### **Drawbacks of Template Method Pattern**

* **Reduced flexibility:** Subclasses might be restricted by the fixed steps defined in the superclass.
* **Increased complexity:** Introduces an extra layer of abstraction (the template class) which can add complexity for simple algorithms.

#### **When to Use Template Method Pattern**

The Template Method Pattern is suitable when:

* We have a common algorithm with variations in specific steps.
* We want to promote code reuse and ensure a consistent algorithmic structure.
* We anticipate the need to add new subclasses with different variations of the algorithm.

#### Example

Consider a game with different characters (subclasses) that share a common attack behavior but have unique attack styles. The Template Method Pattern allows defining a general attack logic.

```java
// Abstract Class (Template) - defines the attack skeleton
public abstract class Character {

  public void performAttack() {
    prepareForAttack(); // Fixed step (common to all)
    executeAttack(); // Abstract step (to be implemented by subclasses)
    finishAttack(); // Fixed step (common to all)
  }

  protected abstract void executeAttack(); // Variation point

  private void prepareForAttack() {
    System.out.println("Character raises weapon...");
  }

  private void finishAttack() {
    System.out.println("Character recovers...");
  }
}

// Concrete Subclass (implements specific attack logic)
public class Knight extends Character {

  @Override
  protected void executeAttack() {
    System.out.println("Knight swings sword!");
  }
}

// Concrete Subclass (implements specific attack logic)
public class Mage extends Character {

  @Override
  protected void executeAttack() {
    System.out.println("Mage casts fireball!");
  }
}

// Using Template Method Pattern
public class Main {
  public static void main(String[] args) {
    Character knight = new Knight();
    knight.performAttack(); // Output: Character raises weapon... Knight swings sword! Character recovers...

    Character mage = new Mage();
    mage.performAttack(); // Output: Character raises weapon... Mage casts fireball! Character recovers...
  }
}
```



### **Visitor Pattern**

#### Description

The Visitor Pattern is a behavioral design pattern that allows to add new operations to a set of classes without modifying those classes. It achieves this by separating the algorithm from the object structure it operates on. The pattern defines a visitor interface with a visit method for each class in the object structure. Concrete visitors implement these methods to perform specific operations on each element of the object structure.

**Key Elements**

1. **Visitor Interface:** Defines methods that represent operations to be performed on elements. These methods typically take an element as an argument.
2. **Concrete Visitor Classes:** Implement the methods defined in the visitor interface, providing specific logic for each operation on different element types.
3. **Element Interface (Optional):** An optional interface that elements can implement to declare the `accept` method. This method allows an element to accept a visitor and call the appropriate visitor method.
4. **Concrete Element Classes:** Represent the objects in the structure that can be visited. They implement the `accept` method, which takes a visitor object and invokes the appropriate visitor method based on the element's type (using polymorphism).

#### **Benefits of Visitor Pattern**

* **Decoupling algorithms from objects:** Separates the operational logic (visitor) from the data structure (elements), promoting loose coupling.
* **Adding new operations:** New operations can be added by creating new visitor classes without modifying existing element classes (Open/Closed Principle).
* **Double dispatch simulation:** Achieves a form of double dispatch (dispatching based on both visitor and element type) using polymorphism.

#### **Drawbacks of Visitor Pattern**

* **Increased complexity:** Introduces additional classes (visitor, potentially element interface) which can add complexity for simple operations.
* **Performance overhead:** Method calls and object creation for visitors might introduce slight overhead compared to directly implementing the logic in element classes.

#### Example

Consider a shape hierarchy (circle, square) with an operation to calculate the area for each shape type. The Visitor Pattern allows separating the area calculation logic from the shape classes.

In this example, the `ShapeVisitor` interface defines methods for visiting `Circle` and `Square` elements. The `AreaVisitor` class implements the visitor, providing area calculation logic for each shape. The `Shape` interface (optional) declares the `accept` method. `Circle` and `Square` classes (concrete elements) implement `accept` and call the appropriate visitor method based on their type.

```java
// Visitor Interface (defines operations on elements)
public interface ShapeVisitor {
  void visitCircle(Circle circle);
  void visitSquare(Square square);
}

// Concrete Visitor Class (implements area calculation)
public class AreaVisitor implements ShapeVisitor {

  @Override
  public void visitCircle(Circle circle) {
    double area = Math.PI * Math.pow(circle.getRadius(), 2);
    System.out.println("Circle area: " + area);
  }

  @Override
  public void visitSquare(Square square) {
    double area = square.getSide() * square.getSide();
    System.out.println("Square area: " + area);
  }
}

// Element Interface (Optional - declares accept method)
public interface Shape {
  void accept(ShapeVisitor visitor);
}

// Concrete Element Class (Circle)
public class Circle implements Shape {

  private double radius;

  public Circle(double radius) {
    this.radius = radius;
  }

  public double getRadius() {
    return radius;
  }

  @Override
  public void accept(ShapeVisitor visitor) {
    visitor.visitCircle(this);
  }
}

// Concrete Element Class (Square)
public class Square implements Shape {

  private double side;

  public Square(double side) {
    this.side = side;
  }

  public double getSide() {
    return side;
  }

  @Override
  public void accept(ShapeVisitor visitor) {
    visitor.visitSquare(this);
  }
}

public class Main {
  public static void main(String[] args) {
    Shape circle = new Circle(5);
    Shape square = new Square(4);

    ShapeVisitor visitor = new AreaVisitor();
    circle.accept(visitor); // Output: Circle area: 78.53981633974483
    square.accept(visitor); // Output: Square area: 16.0
  }
}
```
