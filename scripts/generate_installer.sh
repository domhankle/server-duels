#!/usr/bin/env bash

version=$1
releaseCandidateNumber=$2
distDir=""
packageDir=""
packageBinDir=""
debDir=""
packageName=""

# Create an rc/dist directory
makeRCDir(){
    cd $SERVER_DUELS_DIR

    if [ -n "$releaseCandidateNumber" ]; then
        echo "Generating installer directories for v${version} RC${releaseCandidateNumber}..."
        distDir=${SERVER_DUELS_DIR}/bin/${version}/RC${releaseCandidateNumber}
    else
        echo "Generating installer directories for Server Duels v${version}..."
        distDir=${SERVER_DUELS_DIR}/bin/${version}
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
    packageBinDir=${packageDir}/usr/local/bin
    debDir=${distDir}/${packageName}/DEBIAN

    mkdir -p $packageDir && mkdir -p $debDir && mkdir -p ${packageBinDir}
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

# Create a debian preinst file with the pre install script template.
makePreinstScript(){
    echo "Generating pre-install script..."
    cd $debDir
    touch preinst
    chmod +x preinst

    cat ${SERVER_DUELS_DIR}/scripts/pre_install_template.sh > preinst
}

# Populate the $packageDir/usr/local/bin directory
populateBinDir(){
    echo "Populating binary directory with source files..."

    cd $SERVER_DUELS_DIR

    cp poetry.lock ${packageBinDir}
    cp pyproject.toml ${packageBinDir}
    cp -r server-duels ${packageBinDir}
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
populateBinDir
makePreinstScript
buildPackage
cleanUp

echo "${packageName} installer generated at ${distDir}"

