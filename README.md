# Simple restic image for kubernetes

- Meant to be added as sidecar container in kubernetes deployment, statefulset, or daemonset
- Used for backing up kubernetes PVC/PV data to some form of external storage
    - External storage can be:
        - kubernetes PVC backed by NFS or hostPath
        - Supported restic storage (S3, B2, etc) - see restic documentation, https://restic.readthedocs.io/en/stable/030_preparing_a_new_repo.html

- For restores, a simple initContainer based on https://hub.docker.com/r/restic/restic can be used
    - For this, it's sufficient to run a single `restic restore` command - see https://restic.readthedocs.io/en/stable/050_restore.html

## Usage

- Set environment variables for container as follows:
    - BACKUP_SOURCE: folder to be backed up (defaults to /data)
    - RESTIC_REPOSITORY: folder for restic repository (backup storage location, defaults to /repo)
    - RESTIC_PASSWORD: password for restic repository
    - BACKUP_CRON: cron expression for backup timing (defaults to 00 */24 * * *)
    - CHECK_CRON: cron expression for backup integrity checks (defaults to 00 04 * * 1)
    - RESTIC_FORGET_ARGS: arguments for restic forget command (defaults to --keep-last 7)
        - if set to "", no restic forget command is ever run
    - NICE_ADJUST: nice priority adjustment, defaults to 10 for ~50% CPU time of normal-priority process
    - IONICE_CLASS: ionice scheduling class, defaults to 2 for best-effort IO
    - IONICE_PRIO: ionice priority, defaults to 7 for lowest priority IO
        - ionice is used for `restic backup`, `restic forget` and `restic check` commands
- Occationally check container logs to see backup results

### TODO

- Prometheus metrics
- Alerts for failed backups
