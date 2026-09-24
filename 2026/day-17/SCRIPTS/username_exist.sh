#!/bin/bash

<< usage
- take user name as input
- take password as input
- check if user already exist
- create the user
usage

read -p "enter the username: " username
read -p "enter the password: " password

if id "$username" &>/dev/null; then
    echo "The user $username exists."
    exit 1
else
    echo "The user $username does not exist."
fi

sudo useradd -m $username -p $password

echo "user $username added successfully"
