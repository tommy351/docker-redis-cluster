# docker-redis-cluster

A Redis cluster Docker image. This image is for testing environment. **DO NOT use it for production.**

## Usage

Start a cluster. It will start 6 Redis servers listening on `7000~7005` port and a supervisor to make sure all servers started. After all servers are started, redis-trib will create a Redis cluster.

``` sh
docker run -p 7000:7000 -p 7001:7001 -p 7002:7002 -p 7003:7003 -p 7004:7004 -p 7005:7005 tommy351/redis-cluster:3.2
```

You can mount a data volume on `/data`.

``` sh
docker run -v /some/path/:/data tommy351/redis-cluster:3.2
```

If you are using Redis 4.0 and above, you can set `CLUSTER_ANNOUNCE_IP`. (See [redis#2527](https://github.com/antirez/redis/issues/2527) for more details)

``` sh
docker run -e CLUSTER_ANNOUNCE_IP=127.0.0.1 tommy351/redis-cluster:4.0
```

## License

MIT
