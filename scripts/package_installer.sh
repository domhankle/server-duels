#!/usr/bin/env bash

version=$1
releaseCandidateNumber=$2
distDir=$SERVER_DUELS_DIR

# Create an rc/dist directory
makeRCDir(){
    cd $SERVER_DUELS_DIR

    if [ -n "$releaseCandidateNumber" ]; then
        echo "Generating installer directories for RC${releaseCandidateNumber}..."
        distDir=${SERVER_DUELS_DIR}/rc/${version}/RC${releaseCandidateNumber}
    else
        echo "Generating installer directories for Server Duels v${version}..."
        distDir=${SERVER_DUELS_DIR}/${version}
    fi

    mkdir -p $distDir
}

# Create debian packaging structure
makeDebDirs(){
    cd $SERVER_DUELS_DIR
    echo $version
}

# If a version isn't provided, then stop execution.
if [ -z "$version" ]; then
    echo "You must provide a version for this installer!"
    exit -1;
fi

makeRCDir


