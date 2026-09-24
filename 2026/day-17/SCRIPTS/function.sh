#!/bin/bash


<<usage

./function.sh hello

inside function call

install_package docker.io

usage

echo "$1 is the main argumant passed to the script "

install_package() {

sudo apt-get install $1


}
