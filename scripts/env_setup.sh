#!/usr/bin/env bash

#Variables
bashrcPath=/home/$USER/.bashrc
devDirPath=/home/$USER/dev
serverDuelsDirPath=${devDirPath}/server-duels

#Get the required system dependencies for Server Duels
getDependencies(){
    chmod +x get_dependencies.sh
    ./get_dependencies.sh
}

#Append Environmental Variables used for development to .bashrc file.
initializeEnvVars(){

    echo -e "Beginning to initialize variables in ${bashrcPath}\n"

    if [[ -z "${DEV_DIR}" ]]; then
        echo -e "Initializing DEV_DIR to ${devDirPath}."
        echo -e "export DEV_DIR=${devDirPath}" >> ${bashrcPath}
    else
        echo -e "DEV_DIR already exists as: $DEV_DIR.\nThis will not be overwritten.\n"
    fi

    if [[ -z "${SERVER_DUELS_DIR}" ]]; then
       echo -e "Initializing SERVER_DUELS_DIR to ${serverDuelsDirPath}.\n"
       echo -e "export SERVER_DUELS_DIR=${serverDuelsDirPath}" >> ${bashrcPath}
    else
        echo -e "SERVER_DUELS_DIR already exists as: $SERVER_DUELS_DIR.\nThis will not be overwritten.\n"
    fi

}

#Get system level dependencies (python3, pip, etc.)
getDependencies

#Initialize variables.
initializeEnvVars


