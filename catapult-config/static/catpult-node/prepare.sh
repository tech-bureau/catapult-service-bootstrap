if [ ! -d /data ]; then
        echo "/data directory does not exist"
        exit 1
fi
if [ ! -d /data/00000 ]; then
  if [ -f  /nemesis/block-properties-file.properties ]; then
      echo "data directory is empty, initializing from block-properties-file"
      /bin/bash /userconfig/install_block_properties.sh /nemesis/block-properties-file.properties
  else
      echo "nemgen boostrap from image not supported"
      exit 1
  fi
fi
ls -alh /data
sleep 10
cd /data
exec /catapult/bin/catapult.server /userconfig

