FROM redis:5.0

RUN apt-get -y update && \
  apt-get install -y --no-install-recommends --no-install-suggests supervisor && \
  rm -rf /var/lib/apt/lists/*

COPY start.sh /
VOLUME /data
WORKDIR /

ENV CLUSTER_ANNOUNCE_IP 127.0.0.1

EXPOSE 7000 7001 7002 7003 7004 7005

CMD ["/start.sh"]
