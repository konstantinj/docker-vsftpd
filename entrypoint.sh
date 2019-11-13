#!/bin/sh

if [ "$@" = "sh" ]; then
	exec "$@"
fi

if [ -z "$USERS" ]; then
  USERS="vsftpd|alp1neFtp&"
fi

for i in $USERS ; do
    NAME=$(echo $i | cut -d'|' -f1)
    PASS=$(echo $i | cut -d'|' -f2)
  FOLDER=$(echo $i | cut -d'|' -f3)
     UID=$(echo $i | cut -d'|' -f4)

  if [ -z "$FOLDER" ]; then
    FOLDER="/ftp/$NAME"
  fi

  if [ ! -z "$UID" ]; then
    UID_OPT="-u $UID"
  fi

  mkdir -p $FOLDER
  echo -e "$PASS\n$PASS" | adduser -h $FOLDER -s /sbin/nologin $UID_OPT $NAME
  chown $NAME:$NAME $FOLDER
  unset NAME PASS FOLDER UID
done

if [ ! -z "$ADDRESS" ]; then
  ADDR_OPT="-opasv_address=$ADDRESS"
fi

VSFTPD_LOG_FILE=/var/log/stdout.log
touch $VSFTPD_LOG_FILE
tail -f -n 0 $VSFTPD_LOG_FILE &

exec "$@" $ADDR_OPT /etc/vsftpd/vsftpd.conf


sleep 60
