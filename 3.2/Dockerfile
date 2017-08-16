FROM redis:3.2

MAINTAINER Tommy Chen <tommy351@gmail.com>

RUN apt-get -y update && \
  apt-get install -y --no-install-recommends --no-install-suggests ruby supervisor rubygems wget && \
  rm -rf /var/lib/apt/lists/* && \
  gem install --no-ri --no-rdoc redis

RUN wget https://raw.githubusercontent.com/antirez/redis/3.2/src/redis-trib.rb -O /usr/local/bin/redis-trib && \
  chmod +x /usr/local/bin/redis-trib

COPY start.sh /
VOLUME /data
WORKDIR /

EXPOSE 7000 7001 7002 7003 7004 7005

CMD ["/start.sh"]
