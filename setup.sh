#!/bin/bash

#INSTALLER - contains pacman/apt-get
#PROMPT_RESPONSE contains response to last promptYesNo
#RAMDISKDIR directory for ramdisk stuffs

source ./functions.sh
source ./yesnooption.sh
source ./installsoftwares.sh
source ./addconfig.sh
source ./rdsrcfiles/checkInitServiceCommand.sh
source ./setupramdisk.sh

installSoftwares
addTemplateConfigToStartUp
setUpRamDisk

