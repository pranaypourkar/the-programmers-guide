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





### **Interpreter Pattern**

#### Description



### **Iterator Pattern**

#### Description



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

