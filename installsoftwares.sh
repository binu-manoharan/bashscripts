#!/bin/bash

function findInstaller {
    hasAptGet
    hasPacman
    if [[ -z $INSTALLER ]]; then
	echo "ERROR: Installer not found!"
    else
	echo "Installer found:" $INSTALLER
    fi
}


function hasRsync {
    echo
    local typeRsync=$(type rsync 2>&1)
    if [[ $typeRsync == *"not found"* ]]; then
	installRsync
    else
	echo "Rsync already installed!"
    fi
}

function installRsync {
    findInstaller
    echo "*** Attempting to install rsync ***"
    if [[ $INSTALLER == "pacman" ]]; then
	echo "sudo pacman -S rsync"
    elif [[ $INSTALLER == "apt-get" ]]; then
	echo "sudo apt-get install rsync"
    else
	echo "No suitable installer found"
	exit
    fi
}

function hasXclip {
    echo
    local typeXclip=$(type xclip 2>&1)
    if [[ $typeXclip == *"not found"* ]]; then
	installXclip
    else
	echo "Xclip already installed!"
    fi
}

function installXclip {
    findInstaller
    echo "*** Attempting to install xclip ***"
    if [[ $INSTALLER == "pacman" ]]; then
	echo "sudo pacman -S xclip"
	sudo pacman -S xclip
    elif [[ $INSTALLER == "apt-get" ]]; then
	echo "sudo apt-get install xclip"
	sudo apt-get install xclip
    else
	echo "No suitable installer found"
	exit
    fi
}

