#!/bin/bash

AMI_ID="ami-0220d79f3f480ecf5"
SG_ID="sg-06d6e4665a94c1ffe"
INSTANCES=("mangodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "dispatch" "frontend")
ZONE_ID="Z07938342NCI81HS4HAH4"
DOMAIN_NAME="leardevops.online"

for instance in ${INSTANCES[@]}
do
INSTANCE_ID=$(aws ec2 run-instances --image-id ami-0220d79f3f480ecf5 --instance-type t2.micro --security-group-ids sg-06d6e4665a94c1ffe --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" --query "Instances[0].InstanceId" --output text)

if [ $instance != "frontend" ]
then
    IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
else
    IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
fi

echo "$instance IP address: $IP"
done