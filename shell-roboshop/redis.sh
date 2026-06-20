#!/bin/bash

START_TIME=$(date +%s)
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
   echo -e " $R ERROR :: Please run the script with root user $N" |tee -a $LOG_FILE
   exit 1
else
   echo -e "$R code is run with the rootuser $N" |tee -a $LOG_FILE
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

dnf module disable redis -y &>>$LOG_FILE
VALIDATE $? "disable redis"

dnf module enable redis:7 -y &>>$LOG_FILE
VALIDATE $? "enable redis"

dnf install redis -y  &>>$LOG_FILE
VALIDATE $? "istall redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "access all the ports"

systemctl enable redis  &>>$LOG_FILE
systemctl start redis   &>>$LOG_FILE
VALIDATE $? "start the redis"

END_TIME=$(date +%s)
TOTAL_TIME=$(($START_TIME - $END_TIME))

echo "Total time taken to complete the script is : $TOTAL_TIME"  |tee -a $LOG_FILE