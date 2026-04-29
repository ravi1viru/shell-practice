!#/bin/bash

USERID=$(id -u)
if [ $USERID -ne 0 ]
then
    echo "Error : please run with root user"
else
    echo "already it has runnig with root user"
fi