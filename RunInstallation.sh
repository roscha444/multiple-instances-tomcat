#!/bin/bash

##### Constants

ServerDirectory1=apache-tomcat-1
ServerDirectory2=apache-tomcat-2
ServerDirectory3=apache-tomcat-3
ServerDirectory4=apache-tomcat-4

AUTHOR="Robin Schumacher"
VERSION="0.1"
AMOUNT=0

clear
echo "##########################################################"
echo ""
echo "Run Multiple Instances of Apache Tomcat on Linux"
echo "VERSION" $VERSION
echo "Script by" $AUTHOR
echo ""
echo "##########################################################"

echo ""
echo "1. Configure installation parameter"
echo ""

echo "##########################################################"

echo ""
echo "MAX INSTALLATIONS 4"
echo -n "Number of tomcat installations: "
read AMOUNT

if !(($AMOUNT > 0 && $AMOUNT < 5)); then
	clear
	echo "##########################################################"
	echo ""
	echo "Exiting Script to many installations"
	echo ""
	echo "##########################################################"
	exit 1
fi
echo ""

echo "##########################################################"
echo ""
echo "2. Downloading Apache tomcat and extract to /tmp"
echo ""
echo "##########################################################"

echo ""
mkdir tmp
cd tmp
wget https://www-us.apache.org/dist/tomcat/tomcat-9/v9.0.30/bin/apache-tomcat-9.0.30.tar.gz

{
  tar -zxvf apache-tomcat-9.0.30.tar.gz -C ./
} &> /dev/null
echo "extract apache-tomcat-9.0.30.tar.gz to tmp!"
cd ..
echo ""

echo "##########################################################"
echo ""
echo "3. Copy files to server directorys"
echo ""
echo "##########################################################"

echo""
echo "Copy apache tomcat to Server 1!"
mkdir $ServerDirectory1
cp -ar tmp/apache-tomcat-9.0.30/* $ServerDirectory1

if (($AMOUNT > 1)); then
echo "Copy apache tomcat to Server 2!"
mkdir $ServerDirectory2
cp -ar tmp/apache-tomcat-9.0.30/* $ServerDirectory2
fi

if (($AMOUNT > 2)); then
echo "Copy apache tomcat to Server 3!"
mkdir $ServerDirectory3
cp -ar tmp/apache-tomcat-9.0.30/* $ServerDirectory3
fi

if (($AMOUNT > 3)); then
echo "Copy apache tomcat to Server 4!"
mkdir $ServerDirectory4
cp -ar tmp/apache-tomcat-9.0.30/* $ServerDirectory4
fi
rm -r tmp
echo ""


echo "##########################################################"
echo ""
echo "5. Change server.xml "
echo ""
echo "##########################################################"

echo ""

echo "Server 1: HTTP Port...........*:8080"
echo "Server 1: HTTPS Port..........*:8443"
echo "Server 1: Shutdown Port.......*:8005"
echo "Server 1: AJP Connector Port..*:8009"
echo ""

if (($AMOUNT > 1)); then
cd $ServerDirectory2
cd conf
sed -i s/8080/8081/ server.xml 
sed -i s/8443/8444/ server.xml 
sed -i s/8005/8006/ server.xml
sed -i s/8009/8010/ server.xml
echo "Server 3: Change HTTP Connector Port...*:8080 to *:8081"
echo "Server 3: Change HTTPS Connector Port..*:8443 to *:8444"
echo "Server 3: Change Shutdown Port.........*:8005 to *:8006"
echo "Server 3: Change AJP Connector Port....*:8009 to *:8010"
echo ""
cd ..
cd ..
fi

if (($AMOUNT > 2)); then
cd $ServerDirectory3
cd conf
sed -i s/8080/8082/ server.xml 
sed -i s/8443/8445/ server.xml 
sed -i s/8005/8007/ server.xml
sed -i s/8009/8011/ server.xml
echo "Server 3: Change HTTP Connector Port...*:8080 to *:8082"
echo "Server 3: Change HTTPS Connector Port..*:8443 to *:8445"
echo "Server 3: Change Shutdown Port.........*:8005 to *:8007"
echo "Server 3: Change AJP Connector Port....*:8009 to *:8011"
echo ""
cd ..
cd ..
fi

if (($AMOUNT > 3)); then
cd $ServerDirectory4
cd conf
sed -i s/8080/8083/ server.xml 
sed -i s/8443/8446/ server.xml
sed -i s/8005/8008/ server.xml
sed -i s/8009/8012/ server.xml
echo "Server 3: Change HTTP Connector Port...*:8080 to *:8083"
echo "Server 3: Change HTTPS Connector Port..*:8443 to *:8446"
echo "Server 3: Change Shutdown Port.........*:8005 to *:8008"
echo "Server 3: Change AJP Connector Port....*:8009 to *:8012"
cd ..
cd ..
fi

echo ""

echo "##########################################################"
echo ""
echo "6. Start apache tomcat servers"
echo ""
echo "##########################################################"

echo ""
$ServerDirectory1/bin/startup.sh

echo ""
if (($AMOUNT > 1)); then
$ServerDirectory2/bin/startup.sh
fi

echo ""
if (($AMOUNT > 2)); then
$ServerDirectory3/bin/startup.sh
fi

echo ""
if (($AMOUNT > 3)); then
$ServerDirectory4/bin/startup.sh
fi
echo ""