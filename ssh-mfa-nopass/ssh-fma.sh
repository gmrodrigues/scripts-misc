#!/bin/bash

# your server name
SERVER_NAME="$1"

# your username
USERNAME="$2"

# your certificate file path
IDENTITY_FILE="$3"

# your MFA secret
MFA_SECRET="$4"

# Current Directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Check if the entry already exists in the config file
$DIR/ssh-fma-update-config.sh "$SERVER_NAME" "$USERNAME" "$IDENTITY_FILE"

# Generate a TOTP code using oathtool
code=$(oathtool -b --totp "$MFA_SECRET")

# Run the ssh command with the TOTP code as input
echo ssh $SERVER_NAME \
    -o "PreferredAuthentications=publickey,keyboard-interactive" \
    -o "AuthenticationMethods=publickey,keyboard-interactive" \
    -o "ChallengeResponseAuthentication=yes" \
    -o "PasswordAuthentication=no" \
    -o "PubkeyAuthentication=yes" \
    -o "KbdInteractiveDevices=usertoken" \
    -o "KbdInteractiveAuthentication=yes" \
    -o "KbdInteractiveAuthenticators=usertoken" "echo $code" 
    # ssh $SERVER_NAME
    # | ssh -i $IDENTITY_FILE $USERNAME@$SERVER_NAME
