sleep 4
if [ ! -d /data ]; then
        echo "/data directory does not exist"
        exit 1
fi
if [ ! -d /data/00000 ]; then
   echo "nemgen boostrap needs to be run"
   exit 1
fi
ls -alh /data
cd /data
exec /catapult/bin/catapult.server /userconfig

