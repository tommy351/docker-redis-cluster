ARG REDIS_VERSION

FROM redis:${REDIS_VERSION}

RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
  sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
  apt-get -y update && \
  apt-get install -y --no-install-recommends --no-install-suggests ruby-redis supervisor wget && \
  rm -rf /var/lib/apt/lists/* && \
  REDIS_TRIB_PATH=/usr/local/bin/redis-trib && \
  wget https://raw.githubusercontent.com/antirez/redis/93238575f77630f24e0472bdbf7eecb73a4652a8/src/redis-trib.rb -O $REDIS_TRIB_PATH && \
  chmod +x $REDIS_TRIB_PATH && \
  apt-get purge -y --auto-remove wget

COPY start-3.x.sh /start.sh
VOLUME /data
WORKDIR /

EXPOSE 7000 7001 7002 7003 7004 7005

CMD ["/start.sh"]
