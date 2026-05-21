# 🖥️ Linux System Health Monitor

A lightweight Bash-based system monitoring tool that tracks CPU, Memory, and Disk usage — containerized with Docker and automated via Cron.

---

## Features

- ✅ Real-time CPU, Memory, and Disk usage tracking
- ⚠️ Automatic alerts when usage exceeds defined thresholds
- 📄 Timestamped logging to persistent log files
- 🐳 Docker containerized for portability
- ⏰ Cron-based scheduling (runs every 5 minutes)

---

## Thresholds (configurable in `monitor.sh`)

| Metric | Default Threshold |
|--------|-------------------|
| CPU    | 80%               |
| Memory | 80%               |
| Disk   | 85%               |

---

## Run with Docker

```bash
# Build the image
docker build -t health-monitor .

# Run the container
docker run -d \
  --name health-monitor \
  -v $(pwd)/logs:/app/logs \
  health-monitor
```

---

## View Logs

```bash
# Health metrics log
tail -f logs/health.log

# Alerts log
tail -f logs/alerts.log
```

---

## Sample Output

```
========================================
   System Health Report - 2024-08-01 14:32:01
========================================
  CPU Usage   : 23%  ✅
  Memory Usage: 61%  ✅
  Disk Usage  : 45%  ✅
========================================
```

---

## Tech Stack

- Bash Scripting
- Linux (Ubuntu 22.04)
- Docker
- Cron

---

## Author

Ahmed Elsawy — DevOps Engineer
