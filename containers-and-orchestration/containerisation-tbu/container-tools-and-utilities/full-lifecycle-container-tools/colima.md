# Colima

## About

Colima (short for Containers on Lima) is an open-source container runtime primarily used on macOS and Linux systems. It is designed as a lightweight and Docker-compatible alternative to Docker Desktop. Colima leverages Lima (Linux virtual machines for macOS) to run containerd or Docker inside a virtualized environment with excellent performance, low resource usage, and minimal configuration.

{% hint style="success" %}
**Supported Architectures**

Colima supports:

* x86\_64 (aka amd64)
* aarch64 (aka arm64)

Note: Architecture support depends on the host CPU and whether QEMU emulation is available.
{% endhint %}

## Why Colima?

Colima was created in response to growing concerns around Docker Desktop licensing and resource usage on macOS. It provides developers with:

* A free, open-source alternative to Docker Desktop.
* Compatibility with Docker and Kubernetes CLI tools.
* Faster performance on many setups.
* Better control over VM resources and configuration.

## How Colima Works ?

Colima is a CLI tool that manages a Linux virtual machine on our macOS or Linux host to run container workloads in a Docker-compatible way. It builds on top of Lima, an open-source project that provisions lightweight Linux VMs using QEMU and runs them with minimal configuration.

Let’s break it down step-by-step:

### 1. Core Components

Colima relies on the following key components:

* **Lima**: Provides the virtual machine environment on macOS or Linux. It uses QEMU under the hood to virtualize a Linux guest OS.
* **QEMU**: An open-source emulator that runs a Linux VM efficiently on macOS (including Apple Silicon/ARM) and Linux systems.
* **Container Runtime inside VM**:
  * containerd (default): A high-performance, industry-standard container runtime.
  * docker: Optionally, we can configure Colima to run the Docker Engine inside the VM.
* **nerdctl**: A Docker-compatible CLI for containerd (optional but supported).
* **k3s** (optional): A lightweight Kubernetes distribution that can be enabled for local cluster testing.

### 2. Workflow Overview

Here’s what happens when we run colima start:

a. **Colima launches a lightweight Linux virtual machine using Lima.**

* The VM uses a base Linux image (usually Alpine or Debian) configured to run headless.
* Resource limits like CPU, RAM, and disk size are allocated based on your input or defaults.

b. **Inside the VM, Colima sets up the container runtime:**

* By default, it initializes containerd.
* You can optionally choose to install and run the Docker daemon instead (--runtime docker).

c. **The Docker CLI on your host is configured to point to the socket inside the VM.**

* This lets you use docker commands on the host, even though the containers are running inside the VM.
* Example: docker ps, docker run, docker compose will work transparently.

d. **Port forwarding is automatically configured.**

* Services inside containers (e.g., port 80 in a web container) are made available on localhost via Lima’s port forwarding rules.

e. **Volume mounts are set up.**

* Colima uses 9p or VirtioFS (depending on platform support) to mount host directories into the VM.
* This allows you to bind-mount local files into containers (e.g., docker run -v .:/app).

f. **Optional: Kubernetes is installed if enabled (--kubernetes).**

* Colima installs k3s inside the VM.
* You can then use kubectl from the host to interact with the Kubernetes cluster.

### 3. Execution Environment

The container runtime (containerd or Docker) inside the VM manages containers. From the host perspective:

* docker commands map to the Docker Engine in the VM.
* Containers are executed inside the VM’s Linux kernel.
* File and network access are passed through the VM but feel native on the host.

We don’t need to manage the VM manually. Colima wraps everything in simple CLI commands: start, stop, restart, status, etc.

### 4. Container Lifecycle Inside Colima

* Container image pulled from registry → Stored in containerd or Docker cache inside the VM
* Container process launched using Linux namespaces and cgroups → Isolated and resource-controlled
* I/O and ports connected via forwarded mounts and TCP bridges → Accessible from the host machine

### 5. CLI and Integration

Colima provides a simple CLI for managing its lifecycle:

* colima start – Starts the VM and runtime
* colima status – Shows runtime status
* colima delete – Deletes the VM
* colima start --kubernetes – Enables Kubernetes inside the VM

The Docker CLI can be used normally without requiring Docker Desktop.

## Key Features

<table data-full-width="true"><thead><tr><th width="238.5625">Feature</th><th>Description</th></tr></thead><tbody><tr><td>Docker-Compatible CLI</td><td>Works seamlessly with Docker CLI and Docker Compose on the host.</td></tr><tr><td>Runs in Linux VM</td><td>Uses Lima to run a lightweight Linux VM on macOS or Linux.</td></tr><tr><td>Container Runtime Support</td><td>Supports both containerd (default) and Docker Engine as runtimes.</td></tr><tr><td>Kubernetes Support</td><td>Optionally runs k3s for local Kubernetes development and testing.</td></tr><tr><td>Fast Startup</td><td>Colima VMs start and stop quickly, with minimal overhead.</td></tr><tr><td>Resource Isolation</td><td>Allocates CPU, memory, and disk to VM; fully configurable.</td></tr><tr><td>Volume Mounting</td><td>Shares host directories with VM via 9p or VirtioFS (based on platform).</td></tr><tr><td>Port Forwarding</td><td>Exposes container ports to localhost via Lima’s port forwarding.</td></tr><tr><td>Native Networking</td><td>Containers appear to run on localhost, improving developer experience.</td></tr><tr><td>Low Resource Usage</td><td>More lightweight and efficient than Docker Desktop.</td></tr><tr><td>CLI Simplicity</td><td>Commands like colima start, stop, delete, status are easy to use.</td></tr><tr><td>Architecture Support</td><td>Works on Intel and Apple Silicon (ARM) Macs.</td></tr><tr><td>No Root Required</td><td>Can run entirely in user space; does not require admin privileges.</td></tr><tr><td>Docker Context Switching</td><td>Automatically sets Docker context to the Colima VM.</td></tr><tr><td>Multi-VM Profiles</td><td>Supports multiple named profiles with different configs (CPU, disk, etc.).</td></tr><tr><td>Open Source</td><td>Fully open-source; no licensing restrictions or telemetry.</td></tr></tbody></table>

## Installation

### macOS (using Homebrew)

```bash
brew install colima
```

To install Docker CLI if not already available:

```bash
brew install docker
```

Then start Colima:

```bash
colima start
```

### Linux (via package or binary)

1. Download the Colima binary from GitHub Releases.
2. Move it to a directory in your PATH.
3. Ensure Lima is installed and properly configured.

## Configuration

We can modify VM and container runtime settings using the colima config file:

```bash
colima start --edit
```

Common configuration options include:

* CPUs
* Memory
* Disk size
* GPU access
* Runtime (containerd or Docker)
* Kubernetes enabled/disabled
* Mount paths

## Usage

### 1. Basic Commands

<table><thead><tr><th width="180.12109375">Command</th><th>Description</th></tr></thead><tbody><tr><td><code>colima start</code></td><td>Starts the default Colima VM with container runtime.</td></tr><tr><td><code>colima stop</code></td><td>Stops the running Colima VM.</td></tr><tr><td><code>colima restart</code></td><td>Restarts the Colima VM and runtime.</td></tr><tr><td><code>colima delete</code></td><td>Deletes the Colima VM and its data.</td></tr><tr><td><code>colima status</code></td><td>Shows the status of the Colima VM.</td></tr><tr><td><code>colima update</code></td><td>Updates Colima’s internal VM configuration and runtime.</td></tr></tbody></table>

### 2. Runtime Selection

By default, Colima uses containerd, but you can use Docker instead:

* Start with Docker engine:\
  `colima start --runtime docker`
* Start with containerd (default):\
  `colima start --runtime containerd`

You can switch runtime by stopping and restarting Colima with the new runtime.

### 3. Kubernetes Support

Enable Kubernetes using the --kubernetes flag:

* Start with Kubernetes enabled:\
  `colima start --kubernetes`

This launches a k3s-based local Kubernetes cluster inside the Colima VM. After startup:

* Use kubectl as usual.
* kubectl config use-context colima to set the context manually if needed.

### 4. Port Forwarding

Colima forwards ports from containers to the host (localhost) automatically. We can access exposed ports (e.g. web apps on port 8080) via:

[http://localhost:8080](http://localhost:8080)

### 5. Volume Mounting

Colima automatically mounts the current working directory into the VM.

* docker run -v $(pwd):/app myimage runs with host files shared inside the container.
* Mounting performance may vary depending on 9p or VirtioFS availability.

### 6. Profiles – Multiple Isolated Environments

Profiles let us maintain multiple independent Colima environments with different configurations.

* Create a profile:\
  `colima start --profile dev --cpu 2 --memory 4 --disk 20`
* Switch profiles:\
  `colima list` shows all profiles.\
  `colima start --profile dev`
* View status of a specific profile:\
  `colima status --profile dev`
* Delete a profile:\
  `colima delete --profile dev`&#x20;
* Test ARM builds on Intel Mac:\
  `colima start --profile armtest --arch aarch64`
* Run x86 builds on Apple Silicon\
  `colima start --profile amdtest --arch x86_64`

### 7. Configuration Options

We can customize resources on start:

* colima start --cpu 4 --memory 8 --disk 60
* colima start --dns 1.1.1.1 --dns 8.8.8.8
* colima start --mount \~/my-project:/project

These flags control VM size, network DNS, and mount points.

### 8. Integration with Docker CLI

Once started, Colima automatically configures Docker CLI on your host to point to the VM:

* docker ps
* docker run hello-world
* docker compose up

We don’t need Docker Desktop.

### 9. Managing the VM Internals

To SSH into the VM:

* `colima ssh`

### 10. Environment Variables

Set a custom default runtime:

* export COLIMA\_DEFAULT\_RUNTIME=docker
* export COLIMA\_DEFAULT\_PROFILE=dev

Add these to our shell config (e.g. \~/.zshrc or \~/.bashrc) for persistence.

### 11. Check context

The command `docker context ls` lists all available Docker contexts on our machine. A Docker context defines the endpoint and environment that the Docker CLI interacts with — e.g. local Docker engine, a remote VM like Colima, or a cloud provider.

Example output:

$ docker context ls

<table data-full-width="true"><thead><tr><th width="135.65625">NAME</th><th width="360.6875">DESCRIPTION</th><th>DOCKER ENDPOINT</th></tr></thead><tbody><tr><td>default</td><td>Current DOCKER_HOST based configuration</td><td>unix:///var/run/docker.sock</td></tr><tr><td>colima</td><td>Colima</td><td>unix:///Users/someuser/.colima/...</td></tr><tr><td>desktop-linux</td><td>Docker Desktop</td><td>unix:///Users/someuser/...</td></tr><tr><td>armtest</td><td>Colima profile 'armtest'</td><td>unix:///Users/someuser/...</td></tr><tr><td>amdtest</td><td>Colima profile 'amdtest'</td><td>unix:///Users/someuser/...</td></tr></tbody></table>

Key Notes:

* The context with a star (\*) is the current one being used by Docker CLI.
* We can switch contexts with docker context use \<context-name>
* When using Colima, the context is typically automatically switched to colima or our named profile (e.g., armtest).
* docker context inspect \<context-name> gives detailed info about a specific context.

## Colima vs Docker Desktop

| Feature              | Colima         | Docker Desktop                   |
| -------------------- | -------------- | -------------------------------- |
| License              | Open-source    | Proprietary (free for small use) |
| Resource Usage       | Lower          | Higher                           |
| Kubernetes Support   | Yes (via k3s)  | Yes (via internal VM)            |
| GUI                  | No             | Yes                              |
| Platform Support     | macOS, Linux   | macOS, Windows                   |
| Customization        | More control   | Less configurable                |
| Rootless Containers  | Yes (optional) | Yes (but complex)                |
| Integrated Dashboard | No             | Yes                              |

## Limitations

* No GUI dashboard (CLI-only)
* No native Windows support (Linux/macOS only)
* Limited support for advanced Docker Desktop features (e.g., Dev Environments, Extensions)
* Volume performance can vary depending on workload and config
