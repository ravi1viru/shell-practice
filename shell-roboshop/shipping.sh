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

dnf install maven -y
VALIDATE $? "istall maven"

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

curl -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip  &>>$LOG_FILE
VALIDATE $? "download catelogue"

cd /app  &>>$LOG_FILE
unzip /tmp/shipping.zip &>>$LOG_FILE
VALIDATE $? "unzip the file"

mvn clean package 
VALIDATE $? "cleanthe all packages in maven"

mv target/shipping-1.0.jar shipping.jar 
VALIDATE $? "moving and renaming jar files"

cp $SCRIPT_DIR/shipping.service /etc/systemd/system/shipping.service

systemctl daemon-reload
VALIDATE $? "relod"

systemctl enable shipping 
systemctl start shipping
VALIDATE $? "start shipping"

dnf install mysql -y 
VALIDATE $? "istall mysql"

mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRavi1viru@1 < /app/db/schema.sql
mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRavi1viru@1 < /app/db/app-user.sql 
mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRavi1viru@1 < /app/db/master-data.sql
systemctl restart shipping
VALIDATE $? "start shipping"