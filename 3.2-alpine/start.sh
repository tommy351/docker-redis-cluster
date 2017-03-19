#!/bin/sh

set -e

log_dir=/var/log/redis-cluster
lock_file=/data/cluster.lock

mkdir -p $log_dir

redis_host="0.0.0.0"
if [ -n "$REDIS_HOSTNAME" ]; then
  echo "0.0.0.0   $REDIS_HOSTNAME" >> /etc/hosts
fi

# Initialize configs
for p in 7000 7001 7002 7003 7004 7005
do
  conf_path=/redis-$p.conf
  data_dir=/data/redis-$p

  mkdir -p $data_dir
  cp /redis.conf $conf_path
  echo "
port $p
dir $data_dir" >> $conf_path

  echo "
[program:redis-$p]
command=redis-server $conf_path
autorestart=unexpected
stdout_logfile=$log_dir/$p.log" >> /supervisord.conf
done

# Start Redis servers
supervisord
sleep 3

# Create Redis cluster
if [ ! -f $lock_file ]; then
  touch $lock_file
  echo "yes" | /redis-trib.rb create --replicas 1 "$redis_host":7000 "$redis_host":7001 "$redis_host":7002 "$redis_host":7003 "$redis_host":7004 "$redis_host":7005
fi

tail -f $log_dir/*.log
