#!/bin/bash

USERID=$(id -u)
if [ $USERID -ne 0 ]
then
    echo "Error : please run with root user"
else
    echo "already it has runnig with root user"
fi
dnf list installed mysql
if [ $? -ne 0 ]
   echo "please install the mysql"
   dnf install mysql -y
if [ $? -eq 0 ]
then
   echo "mysql install status is success"
else 
   echo "mysql install status is failure"
   exit 1
else
   echo "mysql is already installed nothing to do" 
fi
