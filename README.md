CloudFormation
==============

This repo contains a number for CloudFormation Templates for a Multi-AZ Elastic Load Balanced AutoScale Architecture.
There are several templates to support a number of use cases:

1) AutoScaling.Scheduled.cft is a CloudFormation template that launches a Multi-AZ, ELB fronted AutoScale group.  The Autoscale group
will scale out and in based on datetime.  This is the most simple of the .cft's

2) AutoScaling.CloudWatchAlarm.cft is a CloudFormation template that launches a Multi-AZ, ELB fronted AutoScale group.  This Autoscale group
scales out and in based on CPU utilization.  

3) AutoScaling.CloudWatchAlarm.ChefPEM.cft is a CloudFormation template that launches a Multi-AZ, ELB fronted AutoScale group.
Each EC2 instance in the AS Group is configured via Cloud-init to prepare the instance for a Chef bootstrap.  The Chef bootstrap 
authentication will be pem file based and utilize the same ssh certificate as EC2.  Upon EC2 boot completion,
Cloud-init will run the UserData script embedded in the template to prepare the instance.  The UserData scripts are located in the
ChefUserDataScripts directory.  This directory contains both the plain script as well as the JSON encoded verion.  

4) AutoScaling.CloudWatchAlarm.ChefPW.cft is a CloudFormation template that launches a Multi-AZ, ELB fronted AutoScale group.
Each EC2 instance in the AS Group is configured via Cloud-init to prepare the instance for a Chef bootstrap.  The Chef bootstrap 
authentication will be password based.  Upon EC2 boot completion, Cloud-init will run the UserData script embedded in the 
template to prepare the instance.  The UserData scripts are located in the ChefUserDataScripts directory.  This directory contains both the plain script as well as the JSON encoded verion. 

Feedback is always welcome and thanks for stopping by.
