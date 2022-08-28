#####################################
# All rights reserved.              #
# started from Zero                 #
# Docker owned dockserver           #
# Docker Maintainer dockserver      #
#####################################
FROM alpine
LABEL maintainer=mrfret
LABEL org.opencontainers.image.source https://github.com/mrfret/docker-backup/

RUN \
echo "**** install build packages ****" && \
apk --quiet --no-cache --no-progress update && \
apk --quiet --no-cache --no-progress upgrade

RUN \
echo "**** install build packages ****" && \
apk --quiet --no-cache --no-progress add bash shadow musl findutils coreutils && \
apk del --quiet --clean-protected --no-progress && \
rm -f /var/cache/apk/*

COPY root/ /
ENTRYPOINT [ "/bin/bash", "/start.sh" ]
