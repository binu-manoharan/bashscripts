#!/bin/bash

function helloworld {
    echo "hello world!"
}

function hasAptGet {
    local typeAptGet=$(type apt-get 2>&1)
    if [[ $typeAptGet !=  *"not found"* ]]; then
	#echo "apt-get found"
	INSTALLER="apt-get"
    fi
}

function hasPacman {
    local typePacman=$(type pacman 2>&1)
    if [[ $typePacman != *"not found"* ]]; then
	#echo "pacman found"
	INSTALLER="pacman"
    fi
}
