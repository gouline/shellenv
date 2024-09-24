#!/bin/bash

# AWS profile switcher
if [ -f $HOME/.aws/config ]; then
    aws-profile() { 
        export AWS_PROFILE=$1
    }
    complete -W "`sed -nE 's:^\[profile (.+)\]$:\1:p' $HOME/.aws/config | tr '\n' ' '`" aws-profile
fi
