# Payment Validation

## Problem Statement

We are building a payment processing module. The system supports multiple payment types:

* CREDIT\_CARD
* UPI
* WALLET
* NET\_BANKING

Each payment type requires **a different set of validations**, and each validation must be executed in a **specific order**. For example:

**CREDIT\_CARD**:

* Step 1: Balance Check
* Step 2: Card Expiry Validation
* Step 3: Authorize Payment

**WALLET**:

* Step 1: Balance Check
* Step 2: Wallet Active Check
* Step 3: Fraud Detection

Instead of writing switch-cases or hardcoded flows, we want to define reusable **validation steps (handlers)** and let Spring dynamically execute them **in order** per payment type.

## Design Goals

* Maintainable, testable, and extensible structure
* Decouple payment type from validation logic
* Dynamically register validation logic using Spring
* Apply validation steps in the correct order
* Support different validation chains per payment type





