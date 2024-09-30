# Local Docker Setup for SFTP Server

## Prerequisites

Docker installation is completed in the system. In the below example, [colima](https://github.com/abiosoft/colima) is used on Mac System.

## Step 1: Start the colima with `colima start`

<figure><img src="../../../../.gitbook/assets/image (509).png" alt="" width="563"><figcaption></figcaption></figure>

## Step 2: Configure docker in Intellij

Install the Docker plugin in Intellij - [https://plugins.jetbrains.com/plugin/7724-docker](https://plugins.jetbrains.com/plugin/7724-docker)

Configure the Docker plugin

<figure><img src="../../../../.gitbook/assets/image (511).png" alt="" width="563"><figcaption></figcaption></figure>

To find the TCP socket - Engine API URL for colima, run `docker context ls` command. Sample value is given below.

```
unix:///Users/pranayp/.colima/aarch64/docker.sock
```

<figure><img src="../../../../.gitbook/assets/image (513).png" alt=""><figcaption></figcaption></figure>

Configure the Docker executable and Compose executable

<figure><img src="../../../../.gitbook/assets/image (515).png" alt="" width="563"><figcaption></figcaption></figure>

To find Docker executable and Docker Compose executable, run the below command

<figure><img src="../../../../.gitbook/assets/image (516).png" alt="" width="563"><figcaption></figcaption></figure>

## Step 3: Prepare the docker-compose file

Save the below content in docker-compose file

_docker-compose.yml_

```yaml
version: "3.9"
# https://docs.docker.com/compose/compose-file/

services:
  sftp-server:
    container_name: sftp-server
    image: antrea/sftp #https://hub.docker.com/r/antrea/sftp
    platform: linux/amd64 #Change the platform as needed
    ports:
      - "9922:22"
    volumes:
      - ./sftp_test_data:/home/sftpuser/upload/sftp_test_data  # Mount a local directory to the container
    environment:
      SFTP_USERS: "sftpuser:pass:1001:100"  # Set the username, password, UID (user id), and GID (group user id)
      SFTP_CHROOT: "/home/sftpuser"  # Restrict user to the home directory

networks:
  default:
    name: default_network
```

Since, we are attaching a volume of local `sftp_test_data` folder, create a folder and add some test files there.

<figure><img src="../../../../.gitbook/assets/image (517).png" alt="" width="537"><figcaption></figcaption></figure>

## Step 4: Run the docker-compose file

<figure><img src="../../../../.gitbook/assets/image (518).png" alt="" width="563"><figcaption></figcaption></figure>

## Step 5: Connect the sftp server via any tools

Here, we will use FileZilla Client. Download and Install the FileZilla client from below url

[https://filezilla-project.org/download.php?type=client#close](https://filezilla-project.org/download.php?type=client#close)

Open the FileZilla Client

<figure><img src="../../../../.gitbook/assets/image (519).png" alt="" width="563"><figcaption></figcaption></figure>

Add below details as we configure in docker-compose file

```
Host: sftp://127.0.0.1
Username: sftpuser
Password: pass
Port: 9922
```

<figure><img src="../../../../.gitbook/assets/image (520).png" alt="" width="563"><figcaption></figcaption></figure>

Click on Quickconnect and click on OK

<figure><img src="../../../../.gitbook/assets/image (521).png" alt=""><figcaption></figcaption></figure>

Remote site details should be visible now

<figure><img src="../../../../.gitbook/assets/image (522).png" alt=""><figcaption></figcaption></figure>
