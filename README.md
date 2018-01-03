# tomcat-8.5.24-docker-image
Creates a Docker image of a clean Tomcat 8.5.24 server


## Prerequisite
1. Add users to tomcat-users.xml
3. Configure context.xml for host-manager and manager.

## Usage
Build the image
```
cd <path to this project>
docker build -t <name of your docker image> .
```

To run it detached and SSH into it,
```
docker run -P -d --rm --name <name of your container> <name of your docker image>
docker exec -it <name of your container> bash
```
This will start an interactive bash prompt as root user inside the container.

To run it in foreground,
```
docker run -P -it --rm --name <name of your container> <name of your docker image> bash
```

The server landing page can be accessed via port 8080.
