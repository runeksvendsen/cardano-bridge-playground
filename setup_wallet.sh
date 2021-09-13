#!/usr/bin/env bash

set -e
set -x

WALLET_BIN="../result/bin/cardano-wallet"

POLYGON_ADDRESS="0xc0788a3ad43d79aa53b09c2eacc313a787d1d607"

# Generate a wallet.
# Usage: generate_wallet <wallet_name> <passphrase> <recovery_phrase>
# Returns: wallet ID
function generate_wallet() {
    local WALLET_NAME="$1"
    local PASSPHRASE="$2"
    local RECOVERY_PHRASE="$3"

    local WALLET_ID
    WALLET_ID=$("$WALLET_BIN" wallet create from-recovery-phrase "$WALLET_NAME" < <(printf "%s\n" "$RECOVERY_PHRASE" "" "$PASSPHRASE" "$PASSPHRASE") |jq -r .id)
    echo "Created new wallet with ID $WALLET_ID" 1>&2
    echo "$WALLET_ID"
}

############
## 1. SETUP
############

# Generate bridge wallet
BRIDGE_WALLET_PASSPHRASE="secret bridge passphrase"
BRIDGE_WALLET_ID=$(generate_wallet "bridge_test_wallet" "$BRIDGE_WALLET_PASSPHRASE" "album wood over woman quiz gloom scene peanut brain dad length sweet assume network property")

# Generate user wallet
USER_WALLET_PASSPHRASE="secret user passphrase"
USER_WALLET_ID=$(generate_wallet "user_test_wallet" "$USER_WALLET_PASSPHRASE" "puzzle achieve runway clog zero card glow answer cheese express consider ranch guitar diary lemon")

# Get a user address
USER_ADDRESS=$("$WALLET_BIN" address list "$USER_WALLET_ID" |jq -r '.[0].id')
# Prompt funding of user address
echo "Please go to https://testnets.cardano.org/en/testnets/cardano/tools/faucet"
echo "  and send funds to $USER_ADDRESS"
echo ""
echo -n "Press enter when done... "
read -r
