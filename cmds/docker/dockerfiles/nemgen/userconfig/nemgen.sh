config_form() {
  split=$(echo $1 | sed  's/\(.\)/\1 /g')
  concat=$(printf "%c%c%c%c'" $(echo $split))
  echo "0x${concat::-1}"
}

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
  ######## need to run twice and patch the mosaic ids
  # first time to get nem.xem nad nem.xem
  /catapult/bin/catapult.tools.nemgen  --resources /userconfig/ --nemesisProperties /nemesis/block-properties-file.properties 2> /tmp/nemgen.log
  harvesting_mosaic_id=$(grep "nem.xem" /tmp/nemgen.log | grep nonce  | awk -F=  '{split($0, a, / /); print a[9]}' | sort -u)
  currency_mosaic_id=$(grep "nem.xem" /tmp/nemgen.log | grep nonce  | awk -F=  '{split($0, a, / /); print a[9]}' | sort -u)

  # second time after replacing values for currencyMosaicId and harvestingMosaicId
  sed -i "s/^harvestingMosaicId = .*/harvestingMosaicId = $(config_form ${harvesting_mosaic_id})/" /userconfig/resources/config-network.properties
  sed -i "s/^currencyMosaicId = .*/currencyMosaicId = $(config_form ${currency_mosaic_id})/" /userconfig/resources/config-network.properties
  /catapult/bin/catapult.tools.nemgen  --resources /userconfig/ --nemesisProperties /nemesis/block-properties-file.properties

  cp -r /tmp/seed/mijin-test/* /data*
else
  echo "no need to run nemgen"
fi
