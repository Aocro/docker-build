FROM debian:stable-slim

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update && apt-get install -y --no-install-recommends ca-certificates cron curl jq wget nginx
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

COPY mirror.sh       /opt/mirror.sh
COPY entry.sh        /opt/entry.sh
COPY mirror.conf     /etc/nginx/sites-enabled/default

ENV MIRROR_DIR="/mirror"

# Create directory for custom crontab files
RUN mkdir -p /etc/cron.d/mirror-jobs

# Make scripts executable
RUN chmod +x /opt/mirror.sh
RUN chmod +x /opt/entry.sh

EXPOSE 80

VOLUME ["/mirror"]
VOLUME ["/etc/cron.d/mirror-jobs"]

ENTRYPOINT ["/opt/entry.sh"]