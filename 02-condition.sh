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

