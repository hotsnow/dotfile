#!/bin/bash

netstat -nlt |grep -v '[53]6000' |egrep -v '5000|2222'
exit 0

# clean root
cd /root && ls -d app_* |grep -v tgz |xargs rm -rf
find /root -name app_\* -mtime +30 rm {} \;

mv /root/app_* /root/*.tgz /data/backup/ &

# clean apache
find /usr/local/apache2 -name hero_\* -mtime +30 -exec rm {} \;
find /usr/local/apache2 -name \*.tgz -mtime +30 -exec rm {} \;
find /usr/local/apache2/hero -name \*.tgz -exec rm {} \;
find /usr/local/apache2/hero -name thread.log.\* -mtime +7 -exec rm {} \;

cd /usr/local/apache2/ && mv hero_* *.tgz /data/backup/ &

# clean tomcat
for i in {1..6}; do
    find /usr/local/tomcat$i/logs -mtime +7 -exec rm {} \;
    find /usr/local/tomcat$i/webapps -name s_\* -mtime +30 -exec rm {} \;
    find /usr/local/tomcat$i/webapps -name \*.tgz -mtime +30 -exec rm {} \;
    find /usr/local/tomcat$i/webapps/s -name \*.tgz -exec rm {} \;
    echo "" > /usr/local/tomcat$i/logs/catalina.out
    cd /usr/local/tomcat$i/webapps && mv \*.tgz s_*  /data/backup &
done

exit 0
# you tmp script
cd /usr/local/apache2 && tar zcf /data/backup/hero_`date +%F`.tgz hero
cd /usr/local/tomcat1/webapps && tar zcf /data/backup/s_`date +%F`.tgz s
ls /data/backup/hero_`date +%F`.tgz
ls /data/backup/s_`date +%F`.tgz
