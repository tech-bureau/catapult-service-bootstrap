#!/bin/bash

ulimit -c unlimited

if [ -e "/state/api-node-0-broker" ]; then
  rm -f /state/api-node-0-broker
fi

cd /catapult
id -a
ls -alh /data
cd /data
rm /data/startup/datadir-initialized

touch /state/api-node-0-broker

exec /catapult/bin/catapult.broker /userconfig
