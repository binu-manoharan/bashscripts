#!/bin/bash

function addConfig {
    cfgfile=.$USER.config
    echo "cp ./configtemplate $HOME/$cfgfile"
    cp ./configtemplate $HOME/$cfgfile
    if [[ -w $HOME/.profile ]]; then
	echo "Added line to .profile: . $HOME/$cfgfile"
	echo ". $HOME/$cfgfile" >> $HOME/.profile
    fi
    
    if [[ -w $HOME/.bashrc ]]; then
	echo "Added line to .bashrc: . $HOME/$cfgfile"
	echo ". $HOME/$cfgfile" >> $HOME/.bashrc
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
