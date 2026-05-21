#!/bin/bash

# ─────────────────────────────────────────
#  Linux System Health Monitor
#  Author: Ahmed Elsawy
# ─────────────────────────────────────────

LOG_FILE="/app/logs/health.log"
ALERT_LOG="/app/logs/alerts.log"

CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=85

RESET="\033[0m"
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"

timestamp() {
  date '+%Y-%m-%d %H:%M:%S'
}

log() {
  echo "[$(timestamp)] $1" | tee -a "$LOG_FILE"
}

alert() {
  echo "[$(timestamp)] ⚠️  ALERT: $1" | tee -a "$ALERT_LOG"
}

get_cpu() {
  top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'.' -f1
}

get_mem() {
  free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}'
}

get_disk() {
  df / | awk 'NR==2 {print $5}' | tr -d '%'
}

check_metrics() {
  CPU=$(get_cpu)
  MEM=$(get_mem)
  DISK=$(get_disk)

  echo ""
  echo -e "${CYAN}========================================${RESET}"
  echo -e "${CYAN}   System Health Report - $(timestamp)${RESET}"
  echo -e "${CYAN}========================================${RESET}"

  # CPU
  if [ "$CPU" -ge "$CPU_THRESHOLD" ]; then
    echo -e "  CPU Usage   : ${RED}${CPU}%  ⚠️  HIGH${RESET}"
    alert "CPU usage is ${CPU}% (threshold: ${CPU_THRESHOLD}%)"
  else
    echo -e "  CPU Usage   : ${GREEN}${CPU}%  ✅${RESET}"
  fi

  # Memory
  if [ "$MEM" -ge "$MEM_THRESHOLD" ]; then
    echo -e "  Memory Usage: ${RED}${MEM}%  ⚠️  HIGH${RESET}"
    alert "Memory usage is ${MEM}% (threshold: ${MEM_THRESHOLD}%)"
  else
    echo -e "  Memory Usage: ${GREEN}${MEM}%  ✅${RESET}"
  fi

  # Disk
  if [ "$DISK" -ge "$DISK_THRESHOLD" ]; then
    echo -e "  Disk Usage  : ${RED}${DISK}%  ⚠️  HIGH${RESET}"
    alert "Disk usage is ${DISK}% (threshold: ${DISK_THRESHOLD}%)"
  else
    echo -e "  Disk Usage  : ${GREEN}${DISK}%  ✅${RESET}"
  fi

  echo -e "${CYAN}========================================${RESET}"
  echo ""

  log "CPU=${CPU}% | MEM=${MEM}% | DISK=${DISK}%"
}

# ─── Main Loop ───────────────────────────
echo "🚀 Starting Linux Health Monitor..."
echo "   Thresholds → CPU: ${CPU_THRESHOLD}% | MEM: ${MEM_THRESHOLD}% | DISK: ${DISK_THRESHOLD}%"
echo "   Logs → $LOG_FILE"
echo ""

while true; do
  check_metrics
  sleep 10
done
