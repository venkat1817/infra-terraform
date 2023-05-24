#!/bin/bash
cd /tmp

#install docker
yum install docker -y

#install java
wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm
#install java by using the rpm command
rpm -ivh jdk-8u131-linux-x64.rpm

#install jenkins

#Enable EPEL
wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
#installing jenkins with rpm
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
#update
yum update -y
#install jenkins
yum install jenkins -y
#start
systemctl start jenkins
#enable the OS level service
systemctl enable jenkins
