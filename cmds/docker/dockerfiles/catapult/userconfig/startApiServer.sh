#!/bin/bash

ulimit -c unlimited
cd /catapult
id -a
ls -alh /data

if [ -e "/state/api-node-0" ]; then
  rm -f /state/api-node-0
fi

sleep 4

if [ ! -d /data ]; then
  echo "/data directory does not exist"
  exit 1
fi

if [ ! -d /data/00000 ]; then
   echo "nemgen boostrap needs to be run"
   exit 1
fi

if [ ! -f "/data/index.dat" ]; then
  echo "No index.dat file, creating now...."
  echo -ne "\01\0\0\0\0\0\0\0" > /data/index.dat
fi

cd /data
mkdir -p startup
rm -f /data/startup/mongo-initialized
touch /data/startup/datadir-initialized

sleep 4

echo "!!!! Going to start api node now...."

touch /state/api-node-0

exec /catapult/bin/catapult.server /userconfig
