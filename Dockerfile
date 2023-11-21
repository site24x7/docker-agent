FROM ubuntu:20.04

MAINTAINER site24x7<support@site24x7.com>

WORKDIR /opt

RUN apt-get update && \
  apt-get install -y python3 python3-dev python3-pip python3-virtualenv && \
  apt-get install -y wget && \
  apt-get install -y vim && \
  apt-get install -y libssl-dev && \
  apt-get install -y net-tools && \
  apt-get install -y curl && \
  apt-get install -y iputils-ping && \
  apt-get install -y supervisor && \
  rm -rf /var/lib/apt/lists/*

COPY ["s247_setup.sh", "entrypoint.sh", "heartbeat.sh", "requirements.txt", "singleinstance.py", "./"]

RUN chmod +x entrypoint.sh && chmod +x heartbeat.sh && chmod +x s247_setup.sh

RUN ./s247_setup.sh

HEALTHCHECK --interval=10s --timeout=3s --retries=1 \
  CMD ./heartbeat.sh

ENTRYPOINT ["/opt/entrypoint.sh"]

CMD ["supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
