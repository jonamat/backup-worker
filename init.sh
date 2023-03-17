#!/bin/sh

set -e

if [ -z "$CRON_SCHEDULE" ]; then
    echo "CRON_SCHEDULE not set, using default at 04:00 every day"
    CRON_SCHEDULE="0 4 * * *"
fi

crontab -l | { cat; echo "${CRON_SCHEDULE} /root/backup.sh >> /root/backup.log"; } | crontab -