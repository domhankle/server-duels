#!/usr/bin/env bash

configDir=/etc/opt/server-duels
symbolicLink=/usr/bin/run-server-duels

echo "Removing config directory..."
if [ -d $configDir ]; then
    sudo rm -r /etc/opt/server-duels
fi

echo "Removing symbolic link to Server Duels executable..."
if [ -e $symbolicLink ]; then
    sudo rm /usr/bin/run-server-duels
fi

echo "Beginning uninstallation of Server Duels..."


