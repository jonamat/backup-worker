FROM alpine:3.17.2
WORKDIR /root

COPY backup.sh init.sh ./

RUN apk update && apk add postgresql-client #lftp

RUN chmod +x backup.sh init.sh && ./init.sh

CMD ["tail", "-f", "/dev/null"]
