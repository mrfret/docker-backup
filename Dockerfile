FROM ghcr.io/linuxserver/baseimage-alpine:3.14-version-8e7f29f2
#THX TO Johan Swetzén <johan@swetzen.com> and MrDoob <fuckoff@all.com> for Build up the basic parts
MAINTAINER mrfret <fuckoff@all.com>

ENV BACKUPDIR="/home" \
    ARCHIVEROOT="/backup" \
    EXCLUDES="/backup_excludes" \
    SSH_PORT="22" \
    SSH_IDENTITY_FILE="/root/.ssh/id_rsa" \
    CRON_TIME="0 1 * * */7" \
    LOGS="/log" \
    SET_CONTAINER_TIMEZONE="true" \
    CONTAINER_TIMEZONE="America/New_York" \
    BACKUP_HOLD="15" \
    SERVER_ID="docker" \
    RSYNC_COMPRESS_LEVEL="2" \
    DISCORD_WEBHOOK_URL="" \
    DISCORD_ICON_OVERRIDE="https://i.imgur.com/KorF8zC.png" \
    DISCORD_NAME_OVERRIDE="BACKUP"

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories && \
    apk update && apk upgrade && \
    apk add --no-cache \
        ca-certificates rsync openssh-client tar wget logrotate \
        shadow bash bc findutils coreutils openssl \
        curl libxml2-utils tree pigz tzdata openntpd grep

RUN \
  curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip && \
  unzip -q rclone-current-linux-amd64.zip && \
  rm -rf rclone-current-linux-amd64.zip && \
  cd rclone-*-linux-amd64 && \
  cp rclone /usr/bin/ && \
  rm -rf rclone-*-linux-amd64

COPY docker-entrypoint.sh /usr/local/bin/
COPY backup.sh /backup.sh
ADD backup_excludes /root/backup_excludes
RUN chmod +x /root/backup_excludes
RUN chmod +x /backup.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD /backup.sh && crond -f
