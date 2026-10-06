#!/usr/bin/env bash
set -u
LOG_FILE= "logs/health-check.log"
FAILURES=0
log_message() {
    local level="$1"
    local message="$2"
    printf '%s [%s] %s\n' "$(date '+%F %T')" "$level" "$message" |
        tee -a "$LOG_FILE"
}
log_message "INFO" "Health check started"
log_message "OK" "Cron is running"
log_message "INFO" "Hostname: $(hostname)"
