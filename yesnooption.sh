#!/bin/bash

function promptYesNo {
    echo -n "Do you want to continue with the "$1" (y/n): "
    read -n 1 PROMPT_RESPONSE
    echo
}
