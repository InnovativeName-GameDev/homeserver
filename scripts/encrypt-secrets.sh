#!/bin/bash

sops --age $(cat ./secrets/age-public.txt) -e secrets/nextcloud-adminpassfile.unencrypted.yaml > secrets/nextcloud-adminpassfile.yaml