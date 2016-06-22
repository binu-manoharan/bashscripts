#!/bin/bash

function addConfig {
    cfgfile=.$USER.config
    echo "sudo cp ./configtemplate $HOME/$cfgfile"
    sudo cp ./configtemplate $HOME/$cfgfile
    if [[ -w $HOME/.profile ]]; then
	echo "Added line to .profile: . ./$cfgfile"
	echo ". ./$cfgfile" >> $HOME/.profile
    fi
    
    if [[ -w $HOME/.bashrc ]]; then
	echo "Added line to .bashrc: . ./$cfgfile"
	echo ". ./$cfgfile" >> $HOME/.bashrc
    fi
}

function addTemplateConfigToStartUp {
    echo
    promptYesNo "Add config for hex/dec conversions"
    if [[ $PROMPT_RESPONSE =~ ^[Yy]$ ]]; then
	echo
	addConfig
    else
	echo "Not adding to profile files!"
    fi
    echo
    
}
