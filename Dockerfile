FROM restic/restic:latest

ADD entry.sh /
ADD backup.sh /
ADD check.sh /

ENV RESTIC_REPOSITORY "/repo"
ENV RESTIC_PASSWORD ""
ENV BACKUP_CRON "00 */24 * * *"
ENV CHECK_CRON "00 04 * * 1"
ENV BACKUP_SOURCE "/data"
ENV RESTIC_FORGET_ARGS "--keep-last 7"
ENV NICE_ADJUST "10"
ENV IONICE_CLASS "2"
ENV IONICE_PRIO "7"

ENTRYPOINT ["/entry.sh"]

# CMD is run after entrypoint script finishes setup
CMD ["tail", "-fn0", "/var/log/cron.log"]
