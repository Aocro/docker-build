#!/usr/bin/env bash

# Start nginx
nginx

# Combine all crontab files from mirror-jobs directory
if [ -d "/etc/cron.d/mirror-jobs" ]; then
    cat /etc/cron.d/mirror-jobs/* > /etc/cron.d/mirror-cron 2>/dev/null || true
fi

# Ensure proper permissions and format for crontab
if [ -f "/etc/cron.d/mirror-cron" ]; then
    chmod 0644 /etc/cron.d/mirror-cron
    # Ensure file ends with newline
    sed -i -e '$a\' /etc/cron.d/mirror-cron
fi

# Start cron and follow logs
crontab /etc/cron.d/mirror-cron
touch /var/log/cron.log
cron && tail -f /var/log/cron.log