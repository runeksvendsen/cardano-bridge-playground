#!/usr/bin/env bash

set -e

WALLET_BIN="../result/bin/cardano-wallet"

##################################
## 2. BRIDGE: QUERY RECEIVED FUNDS
##################################


# Get a list of JSON objects which describe payments to the bridge
# Object format: { "txid": <td_id>, "quantity": <quantity_lovelace>, "polygon_address": <address> }
#
# TODO: does this properly handle multiple outputs (paying to the bridge) in the same TX?
#       e.g. do we get two entries for single Tx with two outputs paying to the bridge?
#       or do we get a single entry where `amount.quantity = sum(map amount outputs)``

PAYMENT_INFO_LIST=$("$WALLET_BIN" transaction list "$BRIDGE_WALLET_ID" |jq 'map(. | select(.direction == "incoming"))' |jq 'map({"txid": .id, "quantity": .amount.quantity, "polygon_address": .metadata."0".string})')

echo "Payments to bridge:"
echo "$PAYMENT_INFO_LIST"
