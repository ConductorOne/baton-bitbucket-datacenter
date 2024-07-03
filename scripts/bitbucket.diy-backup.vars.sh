#!/bin/bash

CURL_OPTIONS="-L -s -f"
INSTANCE_NAME=bitbucket

BITBUCKET_URL=http://localhost:7990
BITBUCKET_HOME=/bitbucket-home/
BITBUCKET_UID=atlbitbucket
BITBUCKET_GID=atlbitbucket

BACKUP_HOME_TYPE=rsync
BACKUP_DATABASE_TYPE=postgresql
BACKUP_ARCHIVE_TYPE=tar

BITBUCKET_BACKUP_USER=bitbucket
BITBUCKET_BACKUP_PASS=bitbucket
BITBUCKET_BACKUP_EXCLUDE_REPOS=()

BITBUCKET_DB=bitbucket
POSTGRES_HOST=localhost
POSTGRES_USERNAME=bitbucket
export PGPASSWORD=bitbucket
POSTGRES_PORT=5432

# Make use of PostgreSQL 9.3+ options if available
psql_version="$(psql --version | awk '{print $3}')"
psql_majorminor="$(printf "%d%03d" $(echo "${psql_version}" | tr "." "\n" | head -n 2))"
if [[ ${psql_majorminor} -ge 9003 ]]; then
 PG_PARALLEL="-j 5"
 PG_SNAPSHOT_OPT="--no-synchronized-snapshots"
fi

BITBUCKET_BACKUP_ROOT=/bitbucket-backup
BITBUCKET_BACKUP_DB=${BITBUCKET_BACKUP_ROOT}/bitbucket-db/
BITBUCKET_BACKUP_HOME=${BITBUCKET_BACKUP_ROOT}/bitbucket-home/

BITBUCKET_BACKUP_ARCHIVE_ROOT=/bitbucket-backup-archives

# Used by the scripts for verbose logging. If not true only errors will be shown.
BITBUCKET_VERBOSE_BACKUP=TRUE

HIPCHAT_URL=https://api.hipchat.com
HIPCHAT_ROOM=
HIPCHAT_TOKEN=

KEEP_BACKUPS=0