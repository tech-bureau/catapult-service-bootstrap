#!/bin/bash

# check presence of tools
CAT_BIN=`which cat`
GREP_BIN=`which grep`
TAIL_BIN=`which tail`
SED_BIN=`which sed`
AWK_BIN=`which awk`

# deploy config / read arguments
ADDRESSES_PATH=${1:-/addresses}
CONFIG_PATH=${2:-/config-build}
STATE_PATH=${3:-/state}
GENERATE_KEY=${4:-true}

# Server Config
SERVER_IP=${5:-1.2.3.4}
NODE_NAME=${6:-my-testnet-node}
API_FRIENDLY_NAME=api-node-${NODE_NAME}
PEER_FRIENDLY_NAME=peer-node-${NODE_NAME}

# server paths 
USERCONFIG=/userconfig
NODE_CONFIG_PATH=userconfig/resources

# If using Custom KeyPair, Change `GENERATE_KEY` to `false`
PRIVKEY_API_NODE=0000000000000000000000000000000000000000000000000000000000000000
PUBKEY_API_NODE=0000000000000000000000000000000000000000000000000000000000000000
PRIVKEY_PEER_NODE=0000000000000000000000000000000000000000000000000000000000000000
PUBKEY_PEER_NODE=0000000000000000000000000000000000000000000000000000000000000000
PRIVKEY_REST=0000000000000000000000000000000000000000000000000000000000000000
PRIVKEY_HARVEST=0000000000000000000000000000000000000000000000000000000000000000

# read account details from /addresses/raw-testnet.txt
# @param    {integer}   index (offset)
# @param    {string}    key ('private key:', 'public key:', ..)
read_account_details() {
    local key=`${CAT_BIN} ${ADDRESSES_PATH}/raw-testnet.txt | ${GREP_BIN} -m $2 "$1" | ${AWK_BIN} '{print $3}' | ${TAIL_BIN} -1`
    echo "$key"
}

# save generated testnet addresses
write_config() {
cat <<EOT > ${ADDRESSES_PATH}/testnet.yaml
apiNode:
  privateKey : ${PRIVKEY_API_NODE}
  publicKey  : ${PUBKEY_API_NODE}
  address    : ${ADDRESS_API_NODE}
peerNode:
  privateKey : ${PRIVKEY_PEER_NODE}
  publicKey  : ${PUBKEY_PEER_NODE}
  address    : ${ADDRESS_PEER_NODE}
restGateway:
  privateKey : ${PRIVKEY_REST}
  publicKey  : ${PUBKEY_REST}
  address    : ${ADDRESS_REST}
harvester;
  privateKey : ${PRIVKEY_HARVEST}
  publicKey  : ${PUBKEY_HARVEST}
  address    : ${ADDRESS_HARVEST}
EOT
}

# verify current state
if [ -e ${STATE_PATH}/configs-edited ] ; then
    echo "[ERROR] Configuration files have already been edited."
    echo "[ERROR] you can delete build/state/configs-edited if you wish to force run."
    exit 1
fi

# do we need to generate keys ?
if [ $GENERATE_KEY = 'true' ] ; then
    # generate 4 new addresses for the node
    /catapult/bin/catapult.tools.address --generate=4 -n mijin-test > ${ADDRESSES_PATH}/raw-testnet.txt

    # read private keys
    PRIVKEY_API_NODE=$(read_account_details "private key:" 1)
    PRIVKEY_PEER_NODE=$(read_account_details "private key:" 2)
    PRIVKEY_HARVEST=$(read_account_details "private key:" 3)
    PRIVKEY_REST=$(read_account_details "private key:" 4)

    # read public keys
    PUBKEY_API_NODE=$(read_account_details "public key:" 1)
    PUBKEY_PEER_NODE=$(read_account_details "public key:" 2)
    PUBKEY_HARVEST=$(read_account_details "public key:" 3)
    PUBKEY_REST=$(read_account_details "public key:" 4)

    # read address
    ADDRESS_API_NODE=$(read_account_details "address (mijin-test):" 1)
    ADDRESS_PEER_NODE=$(read_account_details "address (mijin-test):" 2)
    ADDRESS_HARVEST=$(read_account_details "address (mijin-test):" 3)
    ADDRESS_REST=$(read_account_details "address (mijin-test):" 4)

    # write testnet-node account details to /addresses/testnet.yaml
    $(write_config)
fi

config_api_node(){
    ## 1) change SERVER_IP if not local
    ## 2) set bootKey
    ## 3) register neighboor peer node
    ## 4) register neighboor api node (self)
    ${SED_BIN} -i -e "s/host =.*/host = ${SERVER_IP}/" ${CONFIG_PATH}/api-node-0/${NODE_CONFIG_PATH}/config-node.properties
    ${SED_BIN} -i -e "s/friendlyName =.*/friendlyName = ${API_FRIENDLY_NAME}/" ${CONFIG_PATH}/api-node-0/${NODE_CONFIG_PATH}/config-node.properties
    ${SED_BIN} -i -e "s/bootPrivateKey =.*/bootPrivateKey = ${PRIVKEY_API_NODE}/" ${CONFIG_PATH}/api-node-0/${NODE_CONFIG_PATH}/config-user.properties

    ${SED_BIN} -i -e "s/\"publicKey\": \"\"/\"publicKey\": \"${PUBKEY_PEER_NODE}\"/" ${CONFIG_PATH}/api-node-0/${NODE_CONFIG_PATH}/peers-p2p.json
    ${SED_BIN} -i -e "s/peer-node-0-friendlyName/${PEER_FRIENDLY_NAME}/" ${CONFIG_PATH}/api-node-0/${NODE_CONFIG_PATH}/peers-p2p.json
    ${SED_BIN} -i -e "s/peer-node-0/${SERVER_IP}/" ${CONFIG_PATH}/api-node-0/${NODE_CONFIG_PATH}/peers-p2p.json

    ${SED_BIN} -i -e "s/\"publicKey\": \"\"/\"publicKey\": \"${PUBKEY_API_NODE}\"/" ${CONFIG_PATH}/api-node-0/${NODE_CONFIG_PATH}/peers-api.json
    ${SED_BIN} -i -e "s/api-node-0-friendlyName/${API_FRIENDLY_NAME}/" ${CONFIG_PATH}/api-node-0/${NODE_CONFIG_PATH}/peers-api.json
    ${SED_BIN} -i -e "s/api-node-0/${SERVER_IP}/" ${CONFIG_PATH}/api-node-0/${NODE_CONFIG_PATH}/peers-api.json
}

config_peer_node() {
    ## 1) set harvestKey
    ## 2) set bootKey
    ## 3) register neighboor peer node (self)
    ## 4) register neighboor api node
    ${SED_BIN} -i -e "s/host =.*/host = ${SERVER_IP}/" ${CONFIG_PATH}/peer-node-0/${NODE_CONFIG_PATH}/config-node.properties
    ${SED_BIN} -i -e "s/friendlyName =.*/friendlyName = ${PEER_FRIENDLY_NAME}/" ${CONFIG_PATH}/peer-node-0/${NODE_CONFIG_PATH}/config-node.properties
    ${SED_BIN} -i -e "s/harvestKey =.*/harvestKey = ${PRIVKEY_HARVEST}/" ${CONFIG_PATH}/peer-node-0/${NODE_CONFIG_PATH}/config-harvesting.properties
    ${SED_BIN} -i -e "s/bootPrivateKey =.*/bootPrivateKey = ${PRIVKEY_PEER_NODE}/" ${CONFIG_PATH}/peer-node-0/${NODE_CONFIG_PATH}/config-user.properties

    ${SED_BIN} -i -e "s/\"publicKey\": \"\"/\"publicKey\": \"${PUBKEY_PEER_NODE}\"/" ${CONFIG_PATH}/peer-node-0/${NODE_CONFIG_PATH}/peers-p2p.json
    ${SED_BIN} -i -e "s/peer-node-0-friendlyName/${PEER_FRIENDLY_NAME}/" ${CONFIG_PATH}/peer-node-0/${NODE_CONFIG_PATH}/peers-p2p.json
    ${SED_BIN} -i -e "s/peer-node-0/${SERVER_IP}/" ${CONFIG_PATH}/peer-node-0/${NODE_CONFIG_PATH}/peers-p2p.json

    ${SED_BIN} -i -e "s/\"publicKey\": \"\"/\"publicKey\": \"${PUBKEY_API_NODE}\"/" ${CONFIG_PATH}/peer-node-0/${NODE_CONFIG_PATH}/peers-api.json
    ${SED_BIN} -i -e "s/api-node-0-friendlyName/${API_FRIENDLY_NAME}/" ${CONFIG_PATH}/peer-node-0/${NODE_CONFIG_PATH}/peers-api.json
    ${SED_BIN} -i -e "s/api-node-0/${SERVER_IP}/" ${CONFIG_PATH}/peer-node-0/${NODE_CONFIG_PATH}/peers-api.json
}

config_rest_gateway() {
    ## 1) set harvestKey (clientPrivateKey)
    ## 2) set NODE_IP if not local
    ## 3) register neighboor api node
    ${SED_BIN} -i -e "s/\"clientPrivateKey\": \"\"/\"clientPrivateKey\": \"${PRIVKEY_REST}\"/" ${CONFIG_PATH}/rest-gateway-0/userconfig/rest.json
    ${SED_BIN} -i -e "s/api-node-0/${SERVER_IP}/" ${CONFIG_PATH}/rest-gateway-0/userconfig/rest.json
    ${SED_BIN} -i -e "s/\"publicKey\": \"\"/\"publicKey\": \"${PUBKEY_API_NODE}\"/" ${CONFIG_PATH}/rest-gateway-0/userconfig/rest.json
}


echo Now configuring api-node-0...
echo Using Private Key: ${PRIVKEY_API_NODE}
echo

# configure api-node-0
config_api_node

echo Now configuring peer-node-0...
echo Using Private Key: ${PRIVKEY_PEER_NODE}
echo

# configure peer-node-0
config_peer_node

echo Now configuring rest-gateway-0...
echo Using Private Key: ${PRIVKEY_REST}
echo

# configure rest-gateway-0
config_rest_gateway

# save config state
touch ${STATE_PATH}/configs-edited

echo Done configuring your Catapult Testnet node!

if [ $GENERATE_KEY = 'true' ] ; then
    echo config key: build/generated-addresses/testnet.yaml
fi

exit 0

