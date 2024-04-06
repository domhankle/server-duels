#!/usr/bin/env bash

pythonModules=discord>=2.0

echo "Fetching Python module dependencies..."

pip install $pythonModules

echo "Creating symbolic link to Server Duels executable..."

sudo ln -s /usr/local/bin/server-duels/server-duels /usr/bin/run-server-duels

echo "Launching Server Duels instance..."

run-server-duels
