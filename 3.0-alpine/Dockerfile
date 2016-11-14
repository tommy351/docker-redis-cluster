FROM redis:3.0-alpine

MAINTAINER Tommy Chen <tommy351@gmail.com>

RUN apk --update --no-cache add supervisor ruby ca-certificates openssl && \
  gem install --no-ri --no-rdoc redis

RUN wget https://raw.githubusercontent.com/antirez/redis/3.2/src/redis-trib.rb -O /redis-trib.rb && \
  chmod +x /redis-trib.rb

COPY start.sh /
COPY supervisord.conf /
COPY redis.conf /

VOLUME /data
WORKDIR /

EXPOSE 7000 7001 7002 7003 7004 7005

CMD ["./start.sh"]
