#!/bin/bash

echo "installaling $1"

sudo apt-get update && sudo apt-get install $1 -y

echo "sucessfuully installaed"
