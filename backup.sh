#!/bin/sh

echo "Starting backup at $(date +"%Y-%m-%d %H:%M:%S")"
start=`date +%s`

restic backup ${BACKUP_SOURCE}
BACKUP_RESULT=$?
if [[ $BACKUP_RESULT != 0 ]]; then
    echo "Backup failed with status ${BACKUP_RESULT}"
    restic unlock
    exit 1
fi

if [ -n "${RESTIC_FORGET_ARGS}" ]; then
    restic forget ${RESTIC_FORGET_ARGS}
    FORGET_RESULT=$?
    if [[ $FORGET_RESULT != 0 ]]; then
        echo "Snapshot pruning failed with status ${FORGET_RESULT}"
        restic unlock
        exit 1
    fi
fi

end=`date +%s`
echo "Finished backup at $(date +"%Y-%m-%d %H:%M:%S") after $((end-start)) seconds"
