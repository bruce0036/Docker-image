#!/bin/bash

$CATALINA_HOME/bin/startup.sh
/etc/init.d/filebeat start
/usr/bin/mongod --config /etc/mongodb.conf --fork
/usr/bin/redis-server /etc/redis/redis.conf

