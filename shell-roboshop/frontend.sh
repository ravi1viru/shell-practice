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

dnf module list nginx
VALIDATE $? "list of modules in nginx"

dnf module disable nginx -y
VALIDATE $? "previous modules are disable"

dnf module enable nginx:1.24 -y
VALIDATE $? "eable latest version"

dnf install nginx -y
VALIDATE $? "install nginx"

systemctl enable nginx 
VALIDATE $? "enable "

rm -rf /usr/share/nginx/html/* 
VALIDATE $? "remove cotent in nginx"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
VALIDATE $? "unzip the file"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip
VALIDATE $? "unzip the file"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "coping nginx files"  

systemctl restart nginx 
