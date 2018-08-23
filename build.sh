#!/bin/bash

echo WARNING! Need docker and docker compose to work. This script will attempt to isntall and configure it if it doesnt exist. This is for Centos7

read -p "Press enter to continue"


echo "installing docker"
yum install curl -y
yum install docker -y
systemctl start docker 
systemctl status docker
systemctl enable docker
sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "installing git"
yum install git -y

echo "installing wget"
yum install wget -y


echo Creating the necessary directories for jenkins and sonarqube
mkdir -p /docker/data/sonarqube/
mkdir /docker/data/sonarqube/sonarqube_conf
mkdir /docker/data/sonarqube/sonarqube_data
mkdir /docker/data/sonarqube/sonarqube_extensions
mkdir /docker/data/sonarqube/sonarqube_bundled-plugins
mkdir -p /docker/data/postgres/postgresql
mkdir /docker/data/postgres/postgresql_data
mkdir /docker/data/jenkins/

echo Move over files there
mv build.sh /docker/
mv clean.sh /docker/
mv display-jenkins-pass.sh /docker/
mv config-remote-docker.sh /docker/
mv docker-compose.yml /docker/
mv postgres /docker/
mv sonarqube /docker/
mv jenkins /docker/
cd /docker/
wget https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.2.0.1227-linux.zip

echo "Open firewall"
firewall-cmd --zone=public --add-port=9000/tcp --permanent
firewall-cmd --zone=public --add-port=9002/tcp --permanent
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --zone=public --add-port=50000/tcp --permanent
firewall-cmd --reload

echo configure docker for remote access
#./config-remote-docker.sh

echo Start the docker containers
docker-compose up
