# Site24x7 Container Agent

This repository is meant to build the Site24x7 Linux agent container image. You can customise the image with available options and run the container to monitor your host server.


## Create image

Download and unzip the repository in the server host. Then navigate to the extracted folder and execute the below command to build the `site24x7-agent:latest` image.

```
docker build -t site24x7-agent .
```

## Run the agent container
Execute the below command to monitor the server host via `site24x7-agent` container

```
docker run -d --name site24x7-agent --restart always -v /var/run/docker.sock:/var/run/docker.sock:ro -v /:/host:ro -v /var/lib/docker/containers/:/var/lib/docker/containers/:ro -e KEY=<DEVICE_KEY> site24x7-agent:latest
```

## Customizations

### Agent version
If you want to install the Site24x7 Linux agent of specific version, edit the `AGENT_VERSION` variable in `entrypoint.sh` with the valid linux [version](https://www.site24x7.com/help/server-agent-release-notes.html#linux) and build the image. Then build and run the image as container.

### Hostname

By default the agent container will use the `Name` field found in the `docker info` command from the host as a hostname. To change this behavior you can update the `hostname` field in `/opt/site24x7/monagent/conf/monagent.cfg`. The easiest way for this is to use the `HOSTNAME` environment variable in docker run command.

```
docker run -d --name site24x7-agent --restart always -v /var/run/docker.sock:/var/run/docker.sock:ro -v /:/host:ro -v /var/lib/docker/containers/:/var/lib/docker/containers/:ro -e KEY=<DEVICE_KEY> -e HOSTNAME=<host_name> site24x7-agent:latest
```

## Limitations

Only volumes that are mounted into the container can have the disk metrics being reported

## Support
If you need help, email us at support@site24x7.com

## Contribute

If you notice a limitation or a bug with this container, feel free to open a [Github issue](https://github.com/site24x7/docker-agent/issues).
