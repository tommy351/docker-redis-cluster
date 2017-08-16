FROM redis:4.0-alpine

MAINTAINER Tommy Chen <tommy351@gmail.com>

RUN apk --update --no-cache add supervisor ruby ca-certificates openssl && \
  gem install --no-ri --no-rdoc redis

RUN wget https://raw.githubusercontent.com/antirez/redis/4.0/src/redis-trib.rb -O /usr/local/bin/redis-trib && \
  chmod +x /usr/local/bin/redis-trib

COPY start.sh /
VOLUME /data
WORKDIR /

ENV CLUSTER_ANNOUNCE_IP 127.0.0.1

EXPOSE 7000 7001 7002 7003 7004 7005

CMD ["/start.sh"]
