FROM alpine:3.17.2
WORKDIR /root

ARG CRON_SCHEDULE="0 4 * * *" # at 4 AM every day

COPY backup.sh /backup.sh

RUN apk update && apk add postgresql-client #lftp

RUN crontab -l | { cat; echo "${CRON_SCHEDULE} /root/backup.sh"; } | crontab -

CMD ["tail", "-f", "/dev/null"]