#!/bin/bash

# Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
BOLD="\e[1m"
RESET="\e[0m"

# Log configuration
LOG_FOLDER="/var/log/shell-practice"

SCRIPT_NAME=$(echo "$0" | cut -d "." -f1)

LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"

# Packages to install
PACKAGES=("nginx" "mysql" "python")

# Create log directory
mkdir -p "$LOG_FOLDER"

# Check root user
USERID=$(id -u)

if [ "$USERID" -ne 0 ]
then
    echo -e "${RED}${BOLD}ERROR:${RESET} Please run this script with root user" | tee -a "$LOG_FILE"
    exit 1
else
    echo -e "${GREEN}${BOLD}SUCCESS:${RESET} Running with root user" | tee -a "$LOG_FILE"
fi

echo -e "${BLUE}${BOLD}========================================${RESET}" | tee -a "$LOG_FILE"
echo -e "${CYAN}${BOLD}       PACKAGE INSTALLATION${RESET}" | tee -a "$LOG_FILE"
echo -e "${BLUE}${BOLD}========================================${RESET}" | tee -a "$LOG_FILE"


# Validation function
VALIDATE() {

    if [ "$1" -eq 0 ]
    then
        echo -e "${GREEN}${BOLD}SUCCESS:${RESET} $2 installation completed" | tee -a "$LOG_FILE"
    else
        echo -e "${RED}${BOLD}FAILURE:${RESET} $2 installation failed" | tee -a "$LOG_FILE"
    fi

}


# Install packages
for package in "${PACKAGES[@]}"
do

    echo -e "${YELLOW}Checking $package...${RESET}" | tee -a "$LOG_FILE"

    dnf list installed "$package" &>> "$LOG_FILE"

    if [ $? -ne 0 ]
    then

        echo -e "${YELLOW}Installing $package...${RESET}" | tee -a "$LOG_FILE"

        dnf install "$package" -y 2>&1 | tee -a "$LOG_FILE"

        VALIDATE "${PIPESTATUS[0]}" "$package"

    else

        echo -e "${CYAN}INFO:${RESET} $package is already installed" | tee -a "$LOG_FILE"

    fi

done

echo -e "${BLUE}${BOLD}========================================${RESET}" | tee -a "$LOG_FILE"
echo -e "${GREEN}${BOLD}       SCRIPT EXECUTION COMPLETED${RESET}" | tee -a "$LOG_FILE"
echo -e "${BLUE}${BOLD}========================================${RESET}" | tee -a "$LOG_FILE"