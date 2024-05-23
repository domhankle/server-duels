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

#Get user bot token and store in json file
getBotToken(){
	# Prompt user for their bot token
	read -p "Enter your bot token: " token

	# Handle errors
	if [ -z "$token" ]; then
		echo "You must enter a Discord Bot token to initialize a Server Duels developer environment"
		exit 1
	fi

	# Create json object
	json_data=$(jq -n --arg token "$token" \
		'{token: $token}')

	# Define output file
	output_file="config.json"

	# Save the json obj to file
	echo "$json_data" > "$output_file"

	# Move output file
	mv "./$output_file" "$serverDuelsDirPath/$outputfile"

	echo "Data has been saved to $output_file"
	
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

#Get system level dependencies
getDependencies

#Get user bot token and store in json
getBotToken

#Initialize variables.
initializeEnvVars


