#!/usr/bin/env bash

set -e

WALLET_BIN="../result/bin/cardano-wallet"

# source setup_wallet.sh
source mock_setup_wallet.sh

##########################
## 2. USER: SEND TO BRIDGE
##########################

# Get a bridge address
BRIDGE_ADDRESS=$("$WALLET_BIN" address list "$BRIDGE_WALLET_ID" |jq -r '.[1].id')

# Send funds from user to bridge.
# The sending transaction includes a Polygon address as metadata,
# at which the user wishes to receive the mADA.
METADATA="{\"0\" : { \"string\" : \"$POLYGON_ADDRESS\" } }" # TODO: we should use "bytes" instead of "string"
USER_BALANCE_LOVELACE=$("$WALLET_BIN" wallet get "$USER_WALLET_ID" |jq .balance.available.quantity)
SEND_QUANTITY=$((USER_BALANCE_LOVELACE / 50))
"$WALLET_BIN" transaction create --payment "$SEND_QUANTITY@$BRIDGE_ADDRESS" --metadata "$METADATA" "$USER_WALLET_ID" <<< "$USER_WALLET_PASSPHRASE"


##################################
## 2. BRIDGE: QUERY RECEIVED FUNDS
##################################

./bridge_list_received.sh
