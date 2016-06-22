#!/bin/bash

function hasSystemCtl {
    local typeSystemCtl=$(type systemctl 2>&1)
    if [[ $typeSystemCtl !=  *"not found"* ]]; then
	SERVICECMD="systemctl"
    fi
}

function hasService {
    local typeService=$(type service 2>&1)
    if [[ $typeService !=  *"not found"* ]]; then
	SERVICECMD="service"
    fi
}

function findServiceCommand {
    hasSystemCtl
    hasService

    if [[ $SERVICECMD != "systemctl" && $SERVICECMD != "service" ]]; then
	echo "Unsupport service command"
	exit
    fi
}
