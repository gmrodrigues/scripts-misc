#!/bin/bash

# your server name
SERVER_NAME="$1"

# your username
USERNAME="$2"

# your certificate file path
IDENTITY_FILE="$3"

echo "Updating the SSH config file..."
echo "  Server Name: $SERVER_NAME"
echo "  Username: $USERNAME"
echo "  Identity File: $IDENTITY_FILE"


grep -q "$SERVER_NAME" ~/.ssh/config

# Check if the entry already exists in the config file
if grep -q "$SERVER_NAME\$" ~/.ssh/config; then
  echo "The $SERVER_NAME entry already exists, updating it..."
  # The entry already exists, update it
  sed -i "/^Host $SERVER_NAME/,/^$/ { s/^[[:blank:]]*User[[:blank:]]\+.*$/  User $USERNAME/; s/^[[:blank:]]*IdentityFile[[:blank:]]\+.*$/  IdentityFile $IDENTITY_FILE/; }" ~/.ssh/config
else
  echo "The $SERVER_NAME entry does not exist, adding it..."
  # The entry does not exist, add it to the end of the file
  echo "" >> ~/.ssh/config
  echo "Host $SERVER_NAME" >> ~/.ssh/config
  echo "  HostName $SERVER_NAME" >> ~/.ssh/config
  echo "  User $USERNAME" >> ~/.ssh/config
  echo "  IdentityFile $IDENTITY_FILE" >> ~/.ssh/config
fi



# Install oathtool if it is not installed
if ! command -v oathtool &> /dev/null; then
    echo "oathtool is not installed, installing it..."
    sudo apt-get update
    sudo apt-get install -y oathtool
fi
