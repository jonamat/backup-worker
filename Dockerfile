FROM alpine:3.17.2
WORKDIR /root

COPY backup.sh init.sh ./

RUN apk update && apk add postgresql-client lftp coreutils

RUN chmod +x backup.sh init.sh && ./init.sh

RUN touch backup.log

CMD ["tail", "-f", "/root/backup.log"]