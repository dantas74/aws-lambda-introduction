#!/bin/bash

## Install packages ##
pip install -r requirements.txt lib/python
rm -rf lib/python/*dist-info

## Applies new routes ##
terraform -chdir=terraform apply -auto-approve

## Outputs the information ##
terraform -chdir=terraform output
