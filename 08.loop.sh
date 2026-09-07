#!/bin/bash

# ==============================
# COLORS
# ==============================

R="\e[31m"       # Red
G="\e[32m"       # Green
Y="\e[33m"       # Yellow
B="\e[34m"       # Blue
C="\e[36m"       # Cyan
N="\e[0m"        # Reset
BOLD="\e[1m"


# ==============================
# LOG CONFIGURATION
# ==============================

LOG_FOLDER="/var/log/shell-practice"

SCRIPT_NAME=$(basename "$0" .sh)

LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"


# ==============================
# PACKAGES
# ==============================

PACKAGES=("nginx" "mysql" "python3")


# ==============================
# CREATE LOG DIRECTORY
# ==============================

mkdir -p "$LOG_FOLDER"


# ==============================
# CHECK ROOT USER
# ==============================

USERID=$(id -u)

if [ "$USERID" -ne 0 ]
then
    echo -e "${R}${BOLD}ERROR:${N} Please run this script with root user"
    exit 1
else
    echo -e "${G}${BOLD}SUCCESS:${N} Running with root user" | tee -a "$LOG_FILE"
fi


# ==============================
# HEADER
# ==============================

echo -e "${B}${BOLD}========================================${N}" | tee -a "$LOG_FILE"
echo -e "${C}${BOLD}       PACKAGE INSTALLATION${N}" | tee -a "$LOG_FILE"
echo -e "${B}${BOLD}========================================${N}" | tee -a "$LOG_FILE"


# ==============================
# VALIDATION FUNCTION
# ==============================

VALIDATE() {

    if [ "$1" -eq 0 ]
    then
        echo -e "${G}${BOLD}SUCCESS:${N} $2 installation completed" | tee -a "$LOG_FILE"
    else
        echo -e "${R}${BOLD}FAILURE:${N} $2 installation failed" | tee -a "$LOG_FILE"
    fi

}


# ==============================
# PACKAGE INSTALLATION
# ==============================

for package in "${PACKAGES[@]}"
do

    echo -e "${Y}Checking $package...${N}" | tee -a "$LOG_FILE"

    # Check whether package is installed
    if dnf list installed "$package" &>/dev/null
    then

        echo -e "${G}INFO:${N} $package is already installed" | tee -a "$LOG_FILE"

    else

        echo -e "${Y}Installing $package...${N}" | tee -a "$LOG_FILE"

        # Install package
        dnf install "$package" -y 2>&1 | tee -a "$LOG_FILE"

        # Check dnf status, not tee status
        VALIDATE "${PIPESTATUS[0]}" "$package"

    fi

done


# ==============================
# COMPLETED
# ==============================

echo -e "${B}${BOLD}========================================${N}" | tee -a "$LOG_FILE"
echo -e "${G}${BOLD}     SCRIPT EXECUTION COMPLETED${N}" | tee -a "$LOG_FILE"
echo -e "${B}${BOLD}========================================${N}" | tee -a "$LOG_FILE"