#!/usr/bin/env bash

WALLET_BIN="../result/bin/cardano-wallet"

WALLET_IDS=$("$WALLET_BIN" wallet list |jq -r 'map(.id) | .[]')
for wallet_id in $WALLET_IDS; do
    echo "Deleting wallet $wallet_id..."
    "$WALLET_BIN" wallet delete "$wallet_id"
done

