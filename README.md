# Site24x7 Agent Dockerfile

This repository is meant to build the base image for a Site24x7 Agent container. You will have to use the resulting image to configure and run the Agent.


## Quick Start

Run the below command in your server to monitor the host via site24x7-agent container

```
docker run -d --name site24x7-agent \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /proc/:/host/proc/:ro \
  -v /sys:/host/sys/:ro \
  -e KEY=<device_key> \
  site24x7/docker-agent:latest
```

## Configuration


### Hostname

By default the agent container will use the `Name` field found in the `docker info` command from the host as a hostname. To change this behavior you can update the `hostname` field in `/opt/site24x7/monagent/conf/monagent.cfg`. The easiest way for this is to use the `HOSTNAME` environment variable (see below).

```
docker run -d --name site24x7-agent \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /proc/:/host/proc/:ro \
  -v /sys:/host/sys/:ro \
  -e KEY=<device_key> \
  -e HOSTNAME=<host_name> \
  site24x7/docker-agent:latest
```

## Limitations

Only volumes that are mounted into the container can have the disk metrics being reported

## Contribute

If you notice a limitation or a bug with this container, feel free to open a [Github issue](https://github.com/site24x7/docker-agent/issues).