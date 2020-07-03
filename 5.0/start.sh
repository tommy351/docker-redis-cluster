#!/bin/sh

set -e

supervisor_conf=/supervisord.conf
tmpcommand="sh -c 'sleep 3 && echo yes | redis-cli --cluster create --cluster-replicas 1 127.0.0.1:7000 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005'"
if [ "x$CLUSTER_PASS" != "x"  ]; then
        tmpcommand="sh -c 'sleep 3 && echo yes | redis-cli -a $CLUSTER_PASS --cluster create --cluster-replicas 1 127.0.0.1:7000 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005'"
fi

echo "
[supervisord]
nodaemon=true
[program:redis-cluster-create]
command=$tmpcommand
autorestart=false
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
stderr_logfile=/dev/stderr
stderr_logfile_maxbytes=0" > $supervisor_conf

# Initialize configs
for p in 7000 7001 7002 7003 7004 7005
do
  conf_path=/redis-$p.conf
  data_dir=/data/redis-$p

  mkdir -p $data_dir
  chown redis:redis $data_dir
  echo "
cluster-enabled yes
cluster-node-timeout 5000
cluster-config-file nodes.conf
appendonly yes
port $p
dir $data_dir
cluster-announce-ip $CLUSTER_ANNOUNCE_IP" > $conf_path

if [ "x$CLUSTER_PASS" != "x"  ]; then
  echo "
	requirepass $CLUSTER_PASS
	masterauth $CLUSTER_PASS
       " >> $conf_path
fi

  echo "
[program:redis-$p]
command=redis-server $conf_path
autorestart=unexpected
user=redis
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
stderr_logfile=/dev/stderr
stderr_logfile_maxbytes=0" >> $supervisor_conf
done

# Start Redis servers
supervisord -c $supervisor_conf
