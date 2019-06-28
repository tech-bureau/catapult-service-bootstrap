#!/bin/bash

ulimit -c unlimited
cd /catapult
id -a
ls -alh /data

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

echo "!!!! Going to start server now...."

exec /catapult/bin/catapult.server /userconfig
