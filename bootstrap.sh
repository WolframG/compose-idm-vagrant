#### In production the following passwords have to be changed:
# Root pass for mysql (here... echo to the mysql pass file)
# IDM pass for mysql (inside war)
# UAA pass for mysql (vagrant/uaa/uaa_override_config/)

## Passwords used for Mysql connections
echo "root">root_mysql_pass.txt
echo "idm_pass">idm_pass.txt
echo "uaa_pass">uaa_pass.txt

## Setting up mysql 
sudo debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password `cat root_mysql_pass.txt`"
sudo debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password `cat root_mysql_pass.txt`"
sudo apt-get update
sudo apt-get -y install mysql-server-5.5 

#creating users and databases in mysql
if [ ! -f /var/log/databasesetup ];
then
## UAA mysql password is located in /vagrant/uaa/uaa_override_config/uaa.yml
## IDM mysql password is located in the datasource.properties inside the war... 
    echo "CREATE USER 'idm'@'localhost' IDENTIFIED BY '"`cat idm_pass.txt`"'" | mysql -uroot -p`cat root_mysql_pass.txt`
    echo "CREATE USER 'uaa'@'localhost' IDENTIFIED BY '"`cat uaa_pass.txt`"'" | mysql -uroot -p`cat root_mysql_pass.txt`
    echo "CREATE DATABASE composeidentity" | mysql -uroot -p`cat root_mysql_pass.txt`
    echo "CREATE DATABASE uaa" | mysql -uroot -p`cat root_mysql_pass.txt`
    echo "GRANT ALL ON composeidentity.* TO 'idm'@'localhost'" | mysql -uroot -p`cat root_mysql_pass.txt`
    echo "GRANT ALL ON uaa.* TO 'uaa'@'localhost'" | mysql -uroot -p`cat root_mysql_pass.txt`
    echo "flush privileges" | mysql -uroot -p`cat root_mysql_pass.txt`
    touch /var/log/databasesetup

fi

## Installing java VM
sudo apt-get -y install openjdk-7-jdk

## Installing tomcat7
sudo apt-get -y  install tomcat7 

### Setting up the uaa
cp -r /vagrant/tomcat/ /var/lib/tomcat7/conf/
cp /vagrant/uaa/uaa.war /var/lib/tomcat7/webapps/

## Installing git
sudo apt-get -y install git

## Insatlling curl
sudo apt-get install -y curl

## Installing gradle
sudo apt-get install -y unzip
sudo -s
cd /opt
wget -P ./  https://services.gradle.org/distributions/gradle-2.1-bin.zip
unzip gradle-2.1-bin
chmod -R 777 ./gradle-2.1/
./gradle-2.1/bin/gradle

#adding grade var
echo "export PATH=$PATH:/opt/gradle-2.1/bin">>/home/vagrant/.profile 
. ~/.profile
#Put gradle in the path now!
export PATH=$PATH:/opt/gradle-2.1/bin

#Installing IDM
service tomcat7 stop
cp /vagrant/tomcat/setenv.sh /usr/share/tomcat7/bin/
chown www-data /usr/share/tomcat7/bin/setenv.sh
chmod 755 /usr/share/tomcat7/bin/setenv.sh


mkdir /opt/compose-idm/
cp -r /vagrant/compose-idm/build/ /opt/compose-idm/
cd /opt/compose-idm/build/
./compile.sh
chmod 755 bin/*
mv bin/COMPOSEIdentityManagement-0.8.0.war /var/lib/tomcat7/webapps/ROOT.war
rm -rf /var/lib/tomcat7/webapps/ROOT
chown www-data /var/lib/tomcat7/webapps/ROOT.war
service tomcat7 start





