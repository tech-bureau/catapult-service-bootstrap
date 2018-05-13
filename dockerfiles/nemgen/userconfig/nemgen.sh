if [ ! -d /data ]; then
  echo "/data directory does not exist"
  exit 1
fi
if [ ! -d /data/00000 ]; then
  echo "running nemgen"
  cd /tmp
  mkdir settings
  mkdir -p seed/mijin-test/00000
  dd if=/dev/zero of=seed/mijin-test/00000/hashes.dat bs=1 count=64
  cd settings
  /catapult/bin/catapult.tools.nemgen --nemesisProperties /nemesis/block-properties-file.properties
  cp -r /tmp/seed/mijin-test/* /data*
else
  echo "no need to run nemgen"
fi
