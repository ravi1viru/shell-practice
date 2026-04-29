#!/bin/bash

LOG_FOLDER="/var/log/shell-practice"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_NAM="$LOG_FOLDER/$SCRIPT_NAME.log"
PACKAGES=("mysql" "python3" "nginx")
mkdir -p $LOG_FOLDER
USERID=$(id -u)
if [ $USERID -ne 0 ]
then
   echo -e " ERROR :: Please run the script with root user" &>>$LOG_NAM
   exit 1
else
   echo "code is run with the rootuser" &>>$LOG_NAM
fi
VALIDATE(){
    if [ $1 -eq 0 ]
    then
      echo "the software $2 is installed ... SUCCESS" &>>$LOG_NAM
    else
      echo "the software $2 is installed ... FAILURE" &>>$LOG_NAM
      exit 1
    fi
}
for package in ${PACKAGES[@]}
do
    dnf list installed $package &>>$LOG_NAM
if [ $? -ne 0 ]
then 
echo "please install the $package server" &>>$LOG_NAM
     dnf install $package -y
     VALIDATE $? "$package"
else      
echo "already installed the $package server no need" &>>$LOG_NAM
fi
done