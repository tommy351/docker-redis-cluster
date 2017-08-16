#!/bin/sh

set -e

log_dir=/var/log/redis-cluster
lock_file=/data/cluster.lock
supervisor_conf=/supervisord.conf

mkdir -p $log_dir

echo "
[supervisord]
logfile=$log_dir/supervisord.log
childlogdir=$log_dir" > $supervisor_conf

# Initialize configs
for p in 7000 7001 7002 7003 7004 7005
do
  conf_path=/redis-$p.conf
  data_dir=/data/redis-$p

  mkdir -p $data_dir
  echo "
cluster-enabled yes
cluster-node-timeout 5000
cluster-config-file nodes.conf
appendonly yes
port $p
dir $data_dir" > $conf_path

  echo "
[program:redis-$p]
command=redis-server $conf_path
autorestart=unexpected
redirect_stderr=true" >> $supervisor_conf
done

# Start Redis servers
supervisord -c $supervisor_conf
sleep 3

# Create Redis cluster
if [ ! -f $lock_file ]; then
  touch $lock_file
  echo "yes" | /redis-trib.rb create --replicas 1 127.0.0.1:7000 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005
fi

tail -f $log_dir/*.log
