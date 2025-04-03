# Build Lifecycle Management

## About

**Build Lifecycle Management Plugins** control the different **phases** of the Maven **build lifecycle**—such as **compilation, testing, packaging, deployment, and installation**. These plugins ensure that Maven can consistently build, test, and distribute projects by handling specific tasks at different lifecycle stages.

Maven defines three **default lifecycles**:

1. **Clean** – Removes previous build artifacts.
2. **Default** – Handles compilation, testing, packaging, and deployment.
3. **Site** – Generates project documentation.

Each lifecycle consists of **phases**, and various **plugins** execute specific goals within these phases.

## How Plugins Fit into the Maven Build Lifecycle?

Each plugin executes specific **goals**, and these goals are bound to **phases** in the Maven build lifecycle.

For example:

* `compile` → **maven-compiler-plugin** (`compile`)
* `test` → **maven-surefire-plugin** (`test`)
* `package` → **maven-jar-plugin** (`jar`)
* `verify` → **maven-failsafe-plugin** (`integration-test`)
* `install` → **maven-install-plugin** (`install`)
* `deploy` → **maven-deploy-plugin** (`deploy`)

## 1. Plugin for Compilation & Code Processing





## 2. Testing Plugins



## 3. Packaging Plugins



## 4. Deployment & Installation Plugins



## 5. Clean & Site Plugins

