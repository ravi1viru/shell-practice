#!/bin/bash

userid=$(id -u)

if [ $userid -ne 0]
then 
     echo " Error :: Please run with root user"
else 
     echo "you are installing root user "
fi

VALIDATE()

if [ $1 -eq 0 ]  

then 
     echo " $2 installation is succeess"
else 
     echo "$2 installatio is failure"
fi

dnf install nginx -y
if [ $? -ne 0 ]
then
    echo "nginx not install please install it"
    dnf install nginx -y
    VALIDATE $1 "nginx"
else
    echo "nginx i already installed"
fi