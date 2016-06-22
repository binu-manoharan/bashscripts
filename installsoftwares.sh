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

function installSoftwares {
    echo
    promptYesNo "attempt of installation of softwares - Rsync & Xclip"
    if [[ $PROMPT_RESPONSE =~ ^[Yy]$ ]]; then
	echo
	checkAndInstallRsync
	echo
	checkAndInstallXclip
    else
	echo "Rsync and Xclip are not going to be checked for installation!"
    fi
    echo
}

function checkAndInstallRsync {
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
	sudo pacman -S rsync
    elif [[ $INSTALLER == "apt-get" ]]; then
	echo "sudo apt-get install rsync"
	sudo apt-get install rsync
    else
	echo "No suitable installer found"
	exit
    fi
}

function checkAndInstallXclip {
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

