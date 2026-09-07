#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOG_FOLDER="/var/log/shell-practice"

SCRIPT_NAME=$(echo "$0" | cut -d "." -f1)

LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"

PACKAGES=("nginx" "mysql" "python")

mkdir -p "$LOG_FOLDER"

userid=$(id -u)

if [ "$userid" -ne 0 ]
then
    echo -e "$R Error :: please run with root user $N" | tee -a "$LOG_FILE"
    exit 1
else
    echo -e "$Y Installing with root user $N" | tee -a "$LOG_FILE"
fi


VALIDATE() {

    if [ "$1" -eq 0 ]
    then
        echo "$2 installation SUCCESS" | tee -a "$LOG_FILE"
    else
        echo "$2 installation FAILURE" | tee -a "$LOG_FILE"
    fi

}


for package in "${PACKAGES[@]}"
do

    dnf list installed "$package" &>> "$LOG_FILE"

    if [ $? -ne 0 ]
    then

        echo "Please install the $package package" | tee -a "$LOG_FILE"

        dnf install "$package" -y 2>&1 | tee -a "$LOG_FILE"

        VALIDATE "${PIPESTATUS[0]}" "$package"

    else

        echo "Already installed $package package, no need to install" | tee -a "$LOG_FILE"

    fi

done