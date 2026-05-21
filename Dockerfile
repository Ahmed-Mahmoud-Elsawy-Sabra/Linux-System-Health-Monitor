FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    procps \
    cron \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY scripts/monitor.sh /app/monitor.sh
RUN chmod +x /app/monitor.sh

RUN mkdir -p /app/logs

# Cron job: runs every 5 minutes and logs output
RUN echo "*/5 * * * * root /app/monitor.sh >> /app/logs/cron.log 2>&1" > /etc/cron.d/health-monitor \
    && chmod 0644 /etc/cron.d/health-monitor

CMD ["/app/monitor.sh"]
