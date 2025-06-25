# Commands & Use Cases

## About

This page provides commonly used Docker commands organized by real-world scenarios. It serves as a quick reference for tasks such as managing images, containers, volumes, and performing system cleanups. Each command is explained with its purpose to help streamline day-to-day Docker usage.

## Docker Image

### List all the images

To list all the docker images available:

```bash
docker images
```

### Remove Dangling Images

To remove Docker images with the tag `<none>`, we can use the following command in our terminal or command prompt:

```bash
docker rmi $(docker images -f "dangling=true" -q)
```

This command first lists all dangling images (images without a tag) using `docker images -f "dangling=true" -q`, then removes them using `docker rmi`

### Back up Specific Docker images

If we want to back up our Docker images to our local system, we can use the `docker save` command to export the images to a tar archive file.

1. List all the images we want to back up:

```bash
docker images
```

2. Identify the image IDs or names we want to back up.
3. Use the `docker save` command to export the images to a tar archive. We can specify multiple images by separating them with spaces:

```bash
docker save -o backup.tar IMAGE_ID_1 IMAGE_ID_2 ...
```

Replace `IMAGE_ID_1`, `IMAGE_ID_2`, etc., with the IDs or names of the images we want to back up.

For example, if we want to back up two images with IDs `123abc` and `456def`, we would run:

```bash
docker save -o backup.tar 123abc 456def
```

This command will create a file named `backup.tar` containing the specified Docker images.

After creating the backup, we can transfer the `backup.tar` file to our desired location for safekeeping.

{% hint style="warning" %}
Note: The `docker save` command exports Docker images without preserving their tags.
{% endhint %}

If we want to retain the tags along with the images, we can use a combination of `docker save` and `docker inspect` commands.

1. List all the images we want to back up:

```bash
docker images
```

2. Identify the image IDs or names we want to back up.
3. Use the `docker inspect` command to get the tags associated with the images:

```bash
docker inspect --format='{{.Id}} {{.RepoTags}}' IMAGE_ID_1 IMAGE_ID_2 ...
```

Replace `IMAGE_ID_1`, `IMAGE_ID_2`, etc., with the IDs or names of the images we want to back up.

4. Combine the `docker save` and `docker inspect` commands to export the images with their tags:

```bash
docker inspect --format='{{.Id}} {{.RepoTags}}' IMAGE_ID_1 IMAGE_ID_2 ... | \
    awk '{print $1,$2}' | \
    xargs -n2 sh -c 'docker save -o backup_${1//\//_}_${2//:/_}.tar $0:$1' 
```

This command will create tar files with names like `backup_REPOSITORY_TAG.tar` for each image, preserving both repository and tag information.

Replace `IMAGE_ID_1`, `IMAGE_ID_2`, etc., with the IDs or names of the images we want to back up.







