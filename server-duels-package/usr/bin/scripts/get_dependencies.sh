#!/usr/bin/env bash

# Update package lists
sudo apt update

# Install python3 and pip
sudo apt install -y python3 python3-pip

# Verify installation
python3 --version
pip3 --version

# pip install poetry
pip install poetry

# Verify installation
poetry --version

