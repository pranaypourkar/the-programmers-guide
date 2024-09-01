# Local Docker Setup for SFTP  Server

## Prerequisites

Docker installation is completed in the system. In the below example, [colima](https://github.com/abiosoft/colima) is used on Mac System.

## Step 1: Start the colima with `colima start`

<figure><img src="../../../../.gitbook/assets/image (266).png" alt="" width="563"><figcaption></figcaption></figure>

## Step 2: Configure docker in Intellij

Install the Docker plugin in Intellij - [https://plugins.jetbrains.com/plugin/7724-docker](https://plugins.jetbrains.com/plugin/7724-docker)

Configure the Docker plugin

<figure><img src="../../../../.gitbook/assets/image (268).png" alt="" width="563"><figcaption></figcaption></figure>

To find the TCP socket - Engine API URL for colima, run `docker context ls` command. Sample value is given below.

```
unix:///Users/pranayp/.colima/aarch64/docker.sock
```

<figure><img src="../../../../.gitbook/assets/image (270).png" alt=""><figcaption></figcaption></figure>

Configure the Docker executable and Compose executable

<figure><img src="../../../../.gitbook/assets/image (272).png" alt="" width="563"><figcaption></figcaption></figure>

To find Docker executable and Docker Compose executable, run the below command

<figure><img src="../../../../.gitbook/assets/image (273).png" alt="" width="563"><figcaption></figcaption></figure>

