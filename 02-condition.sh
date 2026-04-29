#!/bin/bash

USERID=$(id -u)
if [ $USERID -ne 0 ]
then
    echo "Error : please run with root user"
    exit 1
else
    echo "already it has runnig with root user"
fi
VALIDATE(){
    if [ $1 -eq 0 ]
    then 
    echo " installing $2 is successsful"
    else
    echo "installing $2 is failure"
    exit 1
    fi
    }
dnf list installed mysql
if [ $? -ne 0 ]
then
   echo "mysql not installed the please intall it"
   dnf install mysql -y
   VALIDATE $? "mysql"
   else 
   echo "mq sql is already installed"
   fi

dnf list installed nginx
if [ $? -ne 0 ]
then
   echo "nginx not installed the please intall it"
   dnf install mysql -y
   VALIDATE $? "nginx"
   else 
   echo "nginx is already installed"
   fi

dnf list installed python3
if [ $? -ne 0 ]
then
   echo "python3 not installed the please intall it"
   dnf install python3 -y
   VALIDATE $? "python3"
   else 
   echo "python3 is already installed"
   fi
