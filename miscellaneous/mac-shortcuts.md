# Mac Shortcuts

## About

A handy collection of essential macOS keyboard shortcuts and productivity tips to help us navigate faster, manage windows, take screenshots, and boost efficiency.

## 1. Stop a specific port

To stop a specific port (e.g., port 2121) on a Mac, we can use the `lsof` command to find the processes that are using that port and then terminate those processes. Here are the steps:

1. Open Terminal, which we can find in the Utilities folder within the Applications folder.
2.  Use the following command to find which process is using port 2121:

    ```shell
    lsof -i :2121
    ```

    This command will list the processes that are using port 2121.
3.  Once we've identified the process, we can use the `kill` command to stop it. For example, if the process ID (PID) is 12345, we can use the following command to stop it:

    ```shell
    kill 12345
    ```

    Replace "12345" with the actual PID of the process using port 2121.

After terminating the process using the port, port 2121 will no longer be in use.





