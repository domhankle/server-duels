#!/usr/bin/env bash

version=$1
releaseCandidateNumber=$2
distDir=""
packageDir=""
debDir=""
packageName=""

# Create an rc/dist directory
makeRCDir(){
    cd $SERVER_DUELS_DIR

    if [ -n "$releaseCandidateNumber" ]; then
        echo "Generating installer directories for v${version} RC${releaseCandidateNumber}..."
        distDir=${SERVER_DUELS_DIR}/${version}/RC${releaseCandidateNumber}
    else
        echo "Generating installer directories for Server Duels v${version}..."
        distDir=${SERVER_DUELS_DIR}/${version}
    fi

    mkdir -p $distDir
}

# Create debian packaging structure
makeDebStructure(){
    echo "Generating packaging structure..."

    if [ -n "$releaseCandidateNumber" ]; then
        packageName="server-duels_${version}-RC${releaseCandidateNumber}_x86-64"
    else
        packageName="server-duels_${version}_x86-64"
    fi

    packageDir=${distDir}/${packageName}
    debDir=${distDir}/${packageName}/DEBIAN

    mkdir -p $packageDir && mkdir -p $debDir && mkdir -p ${packageDir}/usr/local/bin
}

# Create a debian control file with package information
makeControlFile(){
    echo "Generating packaging control file..."

    cd $debDir
    touch control

    package="server-duels"
    maintainer="TYPO Studios"
    architecture="amd64"
    description="A Discord bot that allows users to participate in turn based combat with their friends."

    printf "Package: ${package}\n" >> control
    printf "Version: ${version}\n" >> control
    printf "Maintainer: ${maintainer}\n" >> control
    printf "Architecture: ${architecture}\n" >> control
    printf "Description: ${description}\n" >> control
}

# Build the deb file
buildPackage(){
    echo "Building deb package..."

    cd $distDir
    dpkg-deb --build $packageName
}

# Clean up debian directories
cleanUp(){
    echo "Tearing down debian package structure directories..."

    cd $distDir
    rm -r $packageDir
}

# If a version isn't provided, then stop execution.
if [ -z "$version" ]; then
    echo -e "You must provide a version for this installer!\n"
    echo -e "Usage:\n\n<required>\n(optional)\n"
    echo "./package_installer.sh <version> (release canidate number)"
    exit -1;
fi

makeRCDir
makeDebStructure
makeControlFile
buildPackage
cleanUp

echo "${packageName} installer generated at ${distDir}"
