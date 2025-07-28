ARG REDIS_VERSION

FROM redis:${REDIS_VERSION}

RUN apt-get -y update && \
  apt-get install -y --no-install-recommends --no-install-suggests ruby-redis supervisor wget && \
  rm -rf /var/lib/apt/lists/* && \
  REDIS_TRIB_PATH=/usr/local/bin/redis-trib && \
  wget https://raw.githubusercontent.com/antirez/redis/93238575f77630f24e0472bdbf7eecb73a4652a8/src/redis-trib.rb -O $REDIS_TRIB_PATH && \
  chmod +x $REDIS_TRIB_PATH && \
  apt-get purge -y --auto-remove wget

COPY start-4.x.sh /start.sh
VOLUME /data
WORKDIR /

ENV CLUSTER_ANNOUNCE_IP 127.0.0.1

EXPOSE 7000 7001 7002 7003 7004 7005

CMD ["/start.sh"]
