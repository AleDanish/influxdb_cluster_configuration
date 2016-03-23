#!/bin/bash
echo "-> Database configuration"
/usr/bin/yes | sudo apt-get purge influxdb
mkdir -p /tmp/influxdb
wget https://s3.amazonaws.com/influxdb/influxdb_0.9.6.1_amd64.deb -P /tmp/influxdb
sudo dpkg -i /tmp/influxdb/influxdb_0.9.6.1_amd64.deb

echo "-> Configuration file, hostname changes"
myip=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
#myfloatingip= cat < ../influxdb_floatingip
echo $myfloatingip
sudo python string_substitution.py /etc/influxdb/influxdb.conf hostname $myip

sudo touch /etc/default/influxdb
sudo chmod o+w /etc/default/influxdb

if [ "$1" == "" ]; then
   #Master
   echo "-> Configuring MASTER host - Removing option file"
   sudo echo "" > /etc/default/influxdb
else
   #Slave
   echo "-> Configuring SLAVE host - Creating option file"
   hosts=$1:8088
   for var in "${@:2}"
   do
      hosts=$hosts,$var:8088
   done
   sudo echo INFLUXD_OPTS=\"-join $hosts\" > /etc/default/influxdb
fi

echo "-> Delete meta folder"
sudo rm -rf /var/opt/influxdb/meta/*
sudo rm -rf /var/lib/influxdb/meta/*

echo "-> InfluxDb process restart"
sudo service influxdb restart
echo "-> Finish setting up host!"

