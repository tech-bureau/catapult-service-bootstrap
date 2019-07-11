#!/bin/bash

# check presence of tools
CAT_BIN=`which cat`
GREP_BIN=`which grep`
TAIL_BIN=`which tail`
SED_BIN=`which sed`
AWK_BIN=`which awk`

# default config
CONFIG_PATH=/config-build
USERCONFIG=/userconfig
NODE_CONFIG_PATH=userconfig/resources

# Server Config
SERVER_IP=12.12.12.12
NODE_NAME=el-my
API_FRIENDLY_NAME=api-node-${NODE_NAME}
PEER_FRIENDLY_NAME=peer-node-${NODE_NAME}

# Auto KeyGeneration `false ` | `true`
GENERATE_KEY=true

# If using Custom KeyPair, Change `GENERATE_KEY` to `false`
# API Node
PRIVKEY_API_NODE=0000000000000000000000000000000000000000000000000000000000000000
PUBKEY_API_NODE=0000000000000000000000000000000000000000000000000000000000000000

# Peer Node
PRIVKEY_PEER_NODE=0000000000000000000000000000000000000000000000000000000000000000
PUBKEY_PEER_NODE=0000000000000000000000000000000000000000000000000000000000000000

# Rest gateway
PRIVKEY_REST=0000000000000000000000000000000000000000000000000000000000000000

# Harvestor
PRIVKEY_HARVEST=0000000000000000000000000000000000000000000000000000000000000000

# read private keys from /userconfig/nf-testnet.txt
read_private_key() {
    local key=`${CAT_BIN} ${USERCONFIG}/nf-testnet.txt | ${GREP_BIN} -m $1 'private key:' | ${AWK_BIN} '{print $3}' | ${TAIL_BIN} -1`
    echo "$key"
}

# read public keys from /userconfig/nf-testnet.txt
read_public_key() {
    local key=`${CAT_BIN} ${USERCONFIG}/nf-testnet.txt | ${GREP_BIN} -m $1 'public key:' | ${AWK_BIN} '{print $3}' | ${TAIL_BIN} -1`
    echo "$key"
}

# read address from /userconfig/nf-testnet.txt
read_address() {
    local address=`${CAT_BIN} ${USERCONFIG}/nf-testnet.txt | ${GREP_BIN} -m $1 'address (mijin-test):' | ${AWK_BIN} '{print $3}' | ${TAIL_BIN} -1`
    echo "$address"
}

# generate Keypair address file
write_config() {
cat <<EOT > /addresses/testnet-config.txt
    API-NODE
    --------------------
    Private Key: ${PRIVKEY_API_NODE}
    Public Key: ${PUBKEY_API_NODE}
    Address: ${ADDRESS_API_NODE}

    PEER-NODE
    --------------------
    Private Key: ${PRIVKEY_PEER_NODE}
    Public Key: ${PUBKEY_PEER_NODE}
    Address: ${ADDRESS_PEER_NODE}

    HARVEST Account
    --------------------
    Private Key: ${PRIVKEY_HARVEST}
    Public Key: ${PUBKEY_HARVEST}
    Address: ${ADDRESS_HARVEST}

    REST-Gateway
    --------------------
    Private Key: ${PRIVKEY_REST}
    Public Key: ${PUBKEY_REST}
    Address: ${ADDRESS_REST}
EOT
}

# verify current state
if [ -e /state/configs-edited ] ; then
    echo "[ERROR] Configuration files have already been edited."
    echo "[ERROR] you can delete build/state/configs-edited and run-it."
    exit 1
fi

if [ $GENERATE_KEY = 'true' ] ; then
    /catapult/bin/catapult.tools.address --generate=4 -n mijin-test > ${USERCONFIG}/nf-testnet.txt

    # read private keys
    PRIVKEY_API_NODE=$(read_private_key 1)
    PRIVKEY_PEER_NODE=$(read_private_key 2)
    PRIVKEY_HARVEST=$(read_private_key 3)
    PRIVKEY_REST=$(read_private_key 4)

    # read public keys
    PUBKEY_API_NODE=$(read_public_key 1)
    PUBKEY_PEER_NODE=$(read_public_key 2)
    PUBKEY_HARVEST=$(read_public_key 3)
    PUBKEY_REST=$(read_public_key 4)

    # read address
    ADDRESS_API_NODE=$(read_address 1)
    ADDRESS_PEER_NODE=$(read_address 2)
    ADDRESS_HARVEST=$(read_address 3)
    ADDRESS_REST=$(read_address 4)

    # write testnet-node account
    $(write_config)
fi

config_api_node(){
    ## 1) change SERVER_IP if not local
    ## 2) set bootKey
    ## 3) register neighboor peer node
    ## 4) register neighboor api node (self)
    ${SED_BIN} -i -e "s/host =.*/host = ${SERVER_IP}/" ${CONFIG_PATH}/api-node-0/${NODE_CONFIG_PATH}/config-node.properties
    ${SED_BIN} -i -e "s/friendlyName =.*/friendlyName = ${API_FRIENDLY_NAME}/" ${CONFIG_PATH}/api-node-0/${NODE_CONFIG_PATH}/config-node.properties
    ${SED_BIN} -i -e "s/bootKey =.*/bootKey = ${PRIVKEY_API_NODE}/" ${CONFIG_PATH}/api-node-0/${NODE_CONFIG_PATH}/config-user.properties

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
    ${SED_BIN} -i -e "s/bootKey =.*/bootKey = ${PRIVKEY_PEER_NODE}/" ${CONFIG_PATH}/peer-node-0/${NODE_CONFIG_PATH}/config-user.properties

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
touch /state/configs-edited

echo Done configuring your Catapult Testnet node!

if [ $GENERATE_KEY = 'true' ] ; then
    echo config key: build/generated-addresses/testnet-config.txt
fi
