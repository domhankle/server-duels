#!/usr/bin/env bash

version=$1
releaseCandidateNumber=$2
distDir=""
packageDir=""
packageBinDir=""
debDir=""
packageName=""

# Create a /dist directory
makeRCDir(){
    cd $SERVER_DUELS_DIR

    if [ -n "$releaseCandidateNumber" ]; then
        echo "Generating installer directories for v${version} RC${releaseCandidateNumber}..."
        distDir=${SERVER_DUELS_DIR}/dist/${version}/RC${releaseCandidateNumber}
    else
        echo "Generating installer directories for Server Duels v${version}..."
        distDir=${SERVER_DUELS_DIR}/dist/${version}
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

# Create a debian postinst file with the post install script template.
makePostinstScript(){
    echo "Generating post-install script..."
    cd $debDir
    touch postinst
    chmod +x postinst

    cat ${SERVER_DUELS_DIR}/scripts/post_install_template.sh > postinst
}

# Create a debian prerm file with pre remove script template.
makePrermScript(){
    echo "Generating uninstall script..."
    cd $debDir
    touch prerm
    chmod +x prerm

    cat ${SERVER_DUELS_DIR}/scripts/pre_remove_template.sh > prerm
}

# Populate the $packageDir/usr/local/bin directory
populateBinDir(){
    echo "Populating binary directory with source files..."

    cd $SERVER_DUELS_DIR

    cp -r server-duels ${packageBinDir}

    echo "Building executable..."
    cd $packageBinDir

    pyinstaller server-duels/server-duels.py
    rm -r server-duels*
    rm -r build
    mv dist/server-duels .
    rm -r dist
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
    echo "./generate_installer.sh <version> (release canidate number)"
    exit -1;
fi

# We will use pyinstaller module to create an executable.
echo "Ensuring pyinstaller module is installed..."
pip install pyinstaller

makeRCDir
makeDebStructure
makeControlFile
populateBinDir
makePreinstScript
makePostinstScript
makePrermScript
buildPackage
cleanUp

echo "${packageName} installer generated at ${distDir}"

