FROM ubuntu:24.04

MAINTAINER site24x7<support@site24x7.com>

RUN apt-get update && \
  apt-get install -y python3 python3-dev python3-pip python3-venv && \
  apt-get install -y wget && \
  apt-get install -y vim && \
  apt-get install -y libssl-dev && \
  apt-get install -y tini && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /opt

COPY ["s247_setup.sh", "entrypoint.sh", "requirements.txt", "heartbeat.sh", "./"]

RUN chmod +x entrypoint.sh && chmod +x s247_setup.sh

RUN ./s247_setup.sh

HEALTHCHECK --interval=10s --timeout=3s --retries=1 \
  CMD ./heartbeat.sh

ENTRYPOINT ["tini", "--", "/opt/entrypoint.sh"]

CMD ["bash", "-c", "while true; do sleep 300; done"]
