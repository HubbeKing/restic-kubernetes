#!/bin/sh

echo "Starting..."

# check for existance/sanity of repo
restic snapshots &>/dev/null
repo_status=$?

# initialize repo if it doesn't exist or is malformed
if [ $repo_status != 0 ]; then
    echo "Initializing restic repository at '${RESTIC_REPOSITORY}'..."
    restic init
    init_status=$?

    if [ $init_status != 0 ]; then
        echo "Failed to initialize restic repository."
        exit 1
    fi
fi

echo "${BACKUP_CRON} /backup.sh >> /var/log/cron.log 2>&1" > /var/spool/cron/crontabs/root
echo "${CHECK_CRON} /check.sh >> /var/log/cron.log 2>&1" >> /var/spool/cron/crontabs/root

# ensure file exists, default CMD is to tail this file
touch /var/log/cron.log

# start cron daemon
crond

echo "Container setup complete."

# run CMD specified by user
exec "$@"

