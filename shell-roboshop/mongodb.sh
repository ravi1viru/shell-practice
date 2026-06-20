#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOG_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOG_FOLDER
echo "script starting time : $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]
then
   echo -e " ERROR :: Please run the script with root user" |tee -a $LOG_FILE
   exit 1
else
   echo "code is run with the rootuser" |tee -a $LOG_FILE
fi

VALIDATE(){
    if [ $1 -eq 0 ]
    then
      echo "$2 is ... $R SUCCESS $N" &>>$LOG_FILE
    else
      echo " $2 is  ... $R FAILURE $N" &>>$LOG_FILE
      exit 1
    fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Coping mongo repo" | tee -a $LOG_FILE

dnf install mongodb-org -y 
VALIDATE $? "install mongodb" | tee -a $LOG_FILE

systemctl enable mongod 
VALIDATE $? "enable mongodb" | tee -a $LOG_FILE

systemctl start mongod 
VALIDATE $? "start mongodb" | tee -a $LOG_FILE

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "editig mongodb.conf to accept the remote connections" | tee -a $LOG_FILE

systemctl restart mongod
VALIDATE $? "restarting mangodb" | tee -a $LOG_FILE