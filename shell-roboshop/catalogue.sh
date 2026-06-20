#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOG_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD

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
      echo -e "$2 is ... $R SUCCESS $N" |tee -a $LOG_FILE
    else
      echo -e " $2 is  ... $Y FAILURE $N" |tee -a $LOG_FILE
      exit 1
    fi
}

dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "disable the node js previous vesrions"

dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? "enable the version 20"

dnf install nodejs -y &>>$LOG_FILE
VALIDATE $? "install nodejs"

id roboshop
if [ $? -ne 0 ]
 then
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
VALIDATE $? "create roboshop user"
 else
  echo "user already created no need to create new one"
fi

mkdir -p /app  &>>$LOG_FILE
VALIDATE $? "create app directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip  &>>$LOG_FILE
VALIDATE $? "download catelogue"

cd /app  &>>$LOG_FILE
unzip /tmp/catalogue.zip &>>$LOG_FILE
VALIDATE $? "unzip the file"

npm install &>>$LOG_FILE
VALIDATE $? "install dependenicies"

cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service &>>$LOG_FILE
VALIDATE $? "Coping catelogue sevices"

systemctl daemon-reload &>>$LOG_FILE
systemctl enable catalogue  &>>$LOG_FILE
systemctl start catalogue &>>$LOG_FILE
VALIDATE $? "starting catelogue"

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "mangodb client"

mongosh --host mongodb.leardevops.online </app/db/master-data.js &>>$LOG_FILE