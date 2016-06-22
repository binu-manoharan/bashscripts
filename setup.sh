#!/bin/bash

#INSTALLER - contains pacman/apt-get
#PROMPT_RESPONSE contains response to last promptYesNo

source ./functions.sh
source ./yesnooption.sh
source ./installsoftwares.sh
source ./addConfig.sh

installSoftwares
addTemplateConfigToStartUp

exit
