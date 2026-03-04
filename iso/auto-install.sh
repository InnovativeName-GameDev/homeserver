#!/usr/bin/env bash
if [ -z "$INSTALLER_RAN" ]; then
    export INSTALLER_RAN=1
    /etc/install.sh
fi