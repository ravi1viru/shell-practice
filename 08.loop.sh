#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOG_FOLDER="/var/log/shell-practice"

SCRIPT_NAME=$(echo "$0" | cut -d "." -f1)

LOG_NAME="$LOG_FOLDER/$SCRIPT_NAME.log"

PACKAGES=("nginx" "mysql" "python")

mkdir -p "$LOG_FOLDER"

userid=$(id -u)

if [ "$userid" -ne 0 ]
then
    echo -e "$R Error :: please run with root user $N"
    exit 1
else
    echo -e "$Y installing with root user $N"
fi

VALIDATE() {
    if [ "$1" -eq 0 ]
    then
        echo "$2 is installing SUCCESS"
    else
        echo "$2 is installing FAILURE"
    fi
}

for package in "${PACKAGES[@]}"
do

    dnf list installed "$package" &>> "$LOG_NAME"

    if [ $? -ne 0 ]
    then
        echo "please install the $package server"
        dnf install "$package" -y
        VALIDATE $? "$package"
    else
        echo "already installed $package server, no need"
    fi

done