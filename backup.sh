#!/bin/sh

echo "Starting backup at $(date +"%Y-%m-%d %H:%M:%S")"
start=`date +%s`

nice -n ${NICE_ADJUST} ionice -c ${IONICE_CLASS} -n ${IONICE_PRIO} restic backup ${BACKUP_SOURCE}
BACKUP_RESULT=$?
if [[ $BACKUP_RESULT != 0 ]]; then
    echo "Backup failed with status ${BACKUP_RESULT}"
    restic unlock
    exit 1
fi

if [ -n "${RESTIC_FORGET_ARGS}" ]; then
    nice -n ${NICE_ADJUST} ionice -c ${IONICE_CLASS} -n ${IONICE_PRIO} restic forget ${RESTIC_FORGET_ARGS}
    FORGET_RESULT=$?
    if [[ $FORGET_RESULT != 0 ]]; then
        echo "Snapshot pruning failed with status ${FORGET_RESULT}"
        restic unlock
        exit 1
    fi
fi

end=`date +%s`
echo "Finished backup at $(date +"%Y-%m-%d %H:%M:%S") after $((end-start)) seconds"
