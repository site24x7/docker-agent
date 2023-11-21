FROM ubuntu

MAINTAINER site24x7<support@site24x7.com>

WORKDIR /opt

RUN apt-get update && \
  apt-get install -y python python-dev python-pip python-virtualenv && \
  apt-get install -y wget && \
  apt-get install -y vim && \
  apt-get install -y libssl-dev && \
  apt-get install -y supervisor && \
  rm -rf /var/lib/apt/lists/*

COPY ["s247_setup.sh", "entrypoint.sh", "heartbeat.sh", "requirements.txt", "singleinstance.py", "./"]

RUN chmod +x entrypoint.sh && chmod +x heartbeat.sh && chmod +x s247_setup.sh

RUN ./s247_setup.sh

RUN wget https://staticdownloads.site24x7.com/server/Site24x7MonitoringAgent.install

HEALTHCHECK --interval=10s --timeout=3s --retries=1 \
  CMD ./heartbeat.sh

ENTRYPOINT ["/opt/entrypoint.sh"]

CMD ["supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
