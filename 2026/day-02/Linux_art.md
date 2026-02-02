## Linux Internals – Understanding How Linux Works

### Goal
Today’s goal is to understand how Linux works under the hood.  
This knowledge forms the foundation for troubleshooting and system management as a DevOps engineer.

---

## Core Components of Linux

### 1. Linux Kernel
- The kernel is the core of the Linux operating system.
- It manages system resources such as CPU, memory, disk, and networking.
- It acts as a bridge between hardware and user applications.
- Applications interact with the kernel using system calls.

### 2. User Space
- User space is where applications and system tools run.
- It includes shells (bash), utilities, services, and DevOps tools.
- Programs in user space cannot directly access hardware.
- All hardware access is performed through the kernel.

### 3. Init System (systemd)
- systemd is the init system used by most modern Linux distributions.
- It is the first process started by the kernel and runs as PID 1.
- It manages system services, startup order, and dependencies.
- It provides logging, service monitoring, and process supervision.

---

## How Processes Are Created and Managed

- A process is a running instance of a program.
- Linux creates new processes using the `fork()` system call.
- The `exec()` system call replaces a process with a new program.
- Every process has:
  - A unique Process ID (PID)
  - A parent process
  - Allocated memory and CPU time
- The kernel scheduler controls how processes share CPU resources.
- Processes can be viewed and managed using commands like `ps`, `top`, and `htop`.

---

## What systemd Does and Why It Matters

### What systemd Does
- Starts system services during boot
- Stops and restarts services as needed
- Manages service dependencies
- Collects logs using `journald`
- Controls system states such as reboot and shutdown

### Why systemd Matters for DevOps
- Most production Linux servers use systemd
- Helps diagnose service failures quickly
- Ensures high availability by restarting failed services
- Used to manage critical services like Nginx, Docker, and Kubernetes components

---

## DevOps Perspective

Understanding Linux internals helps you:
- Troubleshoot application and system issues
- Monitor and optimize system performance
- Manage cloud servers and container platforms effectively

This knowledge is essential for every DevOps engineer.
