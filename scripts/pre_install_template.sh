#!/usr/bin/env bash

configDir=/etc/opt/server-duels

echo "Checking for previous Server Duels configuration..."
if [ -d $configDir ]; then
    echo "Cleaning old config directory..."
    sudo rm -r $configDir
fi

echo "Please enter your associated Discord Bot token to run your Server Duels instance on: "
read token

if [ -z "$token" ]; then
    echo "It is required to enter a Discord Bot token, terminating installation."
    exit -1
fi

echo "Generating server-duels config directory..."
sudo mkdir $configDir

if [ ! -d $configDir ]; then
    echo "Failed to make config directory, terminating installation."
    exit -1
fi

echo "Generating config file..."
sudo touch ${configDir}/conf.json


if [ ! -e "${configDir}/conf.json" ]; then
    echo "Failed to make config file, terminating installation."
    exit -1
fi

echo "Populating config file..."
printf "{\n \t\"token\": \"${token}\"\n}\n" | sudo tee -a "${configDir}/conf.json"

echo "Successfully generated Server Duels configuration for ${token}"

