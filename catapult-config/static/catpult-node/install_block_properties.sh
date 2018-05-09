cd /tmp
mkdir settings
mkdir -p seed/mijin-test/00000
dd if=/dev/zero of=seed/mijin-test/00000/hashes.dat bs=1 count=64
cd settings
/catapult/bin/catapult.tools.nemgen --nemesisProperties /tmp/.block-properties-file/block-properties-file
cp -r /tmp/seed/mijin-test/* /data*
