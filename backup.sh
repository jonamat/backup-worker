#!/bin/sh

set -e

echo "Starting backup at $(date)"

if [ -z "$PG_HOST" ]; then
    echo "PG_HOST environment variable is not set"
    exit 1
fi
if [ -z "$PG_USER" ]; then
    echo "PG_USER environment variable is not set"
    exit 1
fi
if [ -z "$PG_PASSWD" ]; then
    echo "PG_PASSWD environment variable is not set"
    exit 1
fi
if [ -z "$PG_DB" ]; then
    echo "PG_DB environment variable is not set"
    exit 1
fi
if [ -z "$FTP_HOST" ]; then
    echo "FTP_HOST environment variable is not set"
    exit 1
fi
if [ -z "$FTP_USER" ]; then
    echo "FTP_HOST environment variable is not set"
    exit 1
fi
if [ -z "$FTP_PASSWD" ]; then
    echo "FTP_HOST environment variable is not set"
    exit 1
fi

if [ -z "$STORE_DAYS" ]; then
    echo "STORE_DAYS not set, using default of 7 days"
    STORE_DAYS=7
fi

TODAY=$(date --iso)
RMDATE=$(date --iso -d "$STORE_DAYS days ago")
TMPDIR=$(mktemp -d)
FILENAME=$(date +%Y%m%d_%H%M%S).gz

# Dump db
echo -n "Dumping database... "
pg_dump postgres://$PG_USER:$PG_PASSWD@$PG_HOST/$PG_DB | gzip > $TMPDIR/$FILENAME
echo "Done."

# Upload to FTP
echo -n "Uploading files via FTP... "
lftp << EOF
open ${FTP_USER}:${FTP_PASSWD}@${FTP_HOST}
mkdir ${TODAY}
cd ${TODAY}
put -E ${TMPDIR}/${FILENAME}
cd ..
rm -rf ${RMDATE}
bye
EOF
echo "Done."

# Cleanup
rm -rf ${TMPDIR}
