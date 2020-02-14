#!/bin/bash

########################################################################################################################################

#Here you can set your java path. If you have set the system variable JAVA_HOME you do not have to change anything.
JavaPath=$JAVA_HOME

#EXAMPLE: JavaPath=/usr/lib64/jvm/jre-1.8.0-openjdk

#Here you can set the name of the tmp directory
tmp=tmpTomcatApache

#Here you can set the Ports of all Server

#Please remember that you have to open the ports in the firewall!

Server1_HTTP_Port=8080
Server1_HTTPS_Port=8443
Server1_Shutdown_Port=8005
Server1_AJP_Port=8009

Server2_HTTP_Port=8081
Server2_HTTPS_Port=8444
Server2_Shutdown_Port=8006
Server2_AJP_Port=8010

Server3_HTTP_Port=8082
Server3_HTTPS_Port=8445
Server3_Shutdown_Port=8007
Server3_AJP_Port=8011

Server4_HTTP_Port=8083
Server4_HTTPS_Port=8446
Server4_Shutdown_Port=8008
Server4_AJP_Port=8012

#Here you can set the name of the servers directorys
ServerDirectory1=apache-tomcat-1
ServerDirectory2=apache-tomcat-2
ServerDirectory3=apache-tomcat-3
ServerDirectory4=apache-tomcat-4

#########################################################################################################################################

################################
AUTHOR="Robin Schumacher"
VERSION="1.0"
###############################

clear
echo "##########################################################"
echo ""
echo "Install Multiple Instances of Apache Tomcat on Linux"
echo -n "VERSION" $VERSION; echo -n " Script by" $AUTHOR
echo ""
echo ""
echo "##########################################################"

echo ""
echo "1. Configure installation parameter"
echo ""

echo "##########################################################"

echo ""
echo "Before you can use this script you’ll have to install the Java Development Kit (JDK) or  Java Standard Edition Runtime Environment (JRE)!!!"
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
echo -n "Configure Apache Tomcat Servers as Service? [y] = yes / [n] = no ? "
read Service

if [[ $Service = 'y' ]] || [[  $Service = 'Y' ]]; then
	Service=true
	echo "Configure Tomcat Servers as Service!"
else
	Service=false
fi
echo ""

echo "##########################################################"
echo ""
echo "2. Downloading Apache tomcat and extract to temp"
echo ""
echo "##########################################################"

echo ""
mkdir $tmp
cd $tmp

TOMCAT_VER=`curl --silent http://mirror.vorboss.net/apache/tomcat/tomcat-8/ | grep v8 | awk '{split($5,c,">v") ; split(c[2],d,"/") ; print d[1]}'`
wget -N http://mirror.vorboss.net/apache/tomcat/tomcat-8/v${TOMCAT_VER}/bin/apache-tomcat-${TOMCAT_VER}.tar.gz

{
  tar -zxvf apache-tomcat-$TOMCAT_VER.tar.gz -C ./
} &> /dev/null
echo "extract apache-tomcat.tar.gz"
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
cp -ar $tmp/apache-tomcat-$TOMCAT_VER/* $ServerDirectory1

if (($AMOUNT > 1)); then
echo "Copy apache tomcat to Server 2!"
mkdir $ServerDirectory2
cp -ar $tmp/apache-tomcat-$TOMCAT_VER/* $ServerDirectory2
fi

if (($AMOUNT > 2)); then
echo "Copy apache tomcat to Server 3!"
mkdir $ServerDirectory3
cp -ar $tmp/apache-tomcat-$TOMCAT_VER/* $ServerDirectory3
fi

if (($AMOUNT > 3)); then
echo "Copy apache tomcat to Server 4!"
mkdir $ServerDirectory4
cp -ar $tmp/apache-tomcat-$TOMCAT_VER/* $ServerDirectory4
fi
rm -r $tmp
echo ""


echo "##########################################################"
echo ""
echo "5. Change server.xml "
echo ""
echo "##########################################################"

echo ""

cd $ServerDirectory1
cd conf
sed -i s/8080/$Server1_HTTP_Port/ server.xml 
sed -i s/8443/$Server1_HTTPS_Port/ server.xml 
sed -i s/8005/$Server1_Shutdown_Port/ server.xml
sed -i s/8009/$Server1_AJP_Port/ server.xml
echo ""
echo -n "Server 1: Change HTTP Connector Port...*:8080 to *:"; echo $Server1_HTTP_Port
echo -n "Server 1: Change HTTPS Connector Port..*:8443 to *:"; echo $Server1_HTTPS_Port
echo -n "Server 1: Change Shutdown Port.........*:8005 to *:"; echo $Server1_Shutdown_Port
echo -n "Server 1: Change AJP Connector Port....*:8009 to *:"; echo $Server1_AJP_Port
echo ""
cd ..
cd ..


if (($AMOUNT > 1)); then
cd $ServerDirectory2
cd conf
sed -i s/8080/$Server2_HTTP_Port/ server.xml 
sed -i s/8443/$Server2_HTTPS_Port/ server.xml 
sed -i s/8005/$Server2_Shutdown_Port/ server.xml
sed -i s/8009/$Server2_AJP_Port/ server.xml
echo ""
echo -n "Server 2: Change HTTP Connector Port...*:8080 to *:"; echo $Server2_HTTP_Port
echo -n "Server 2: Change HTTPS Connector Port..*:8443 to *:"; echo $Server2_HTTPS_Port
echo -n "Server 2: Change Shutdown Port.........*:8005 to *:"; echo $Server2_Shutdown_Port
echo -n "Server 2: Change AJP Connector Port....*:8009 to *:"; echo $Server2_AJP_Port
echo ""
cd ..
cd ..
fi

if (($AMOUNT > 2)); then
cd $ServerDirectory3
cd conf
sed -i s/8080/$Server3_HTTP_Port/ server.xml 
sed -i s/8443/$Server3_HTTPS_Port/ server.xml 
sed -i s/8005/$Server3_Shutdown_Port/ server.xml
sed -i s/8009/$Server3_AJP_Port/ server.xml
echo -n "Server 3: Change HTTP Connector Port...*:8080 to *:"; echo $Server3_HTTP_Port
echo -n "Server 3: Change HTTPS Connector Port..*:8443 to *:"; echo $Server3_HTTPS_Port
echo -n "Server 3: Change Shutdown Port.........*:8005 to *:"; echo $Server3_Shutdown_Port
echo -n "Server 3: Change AJP Connector Port....*:8009 to *:"; echo $Server3_AJP_Port
echo ""
cd ..
cd ..
fi

if (($AMOUNT > 3)); then
cd $ServerDirectory4
cd conf
sed -i s/8080/$Server4_HTTP_Port/ server.xml 
sed -i s/8443/$Server4_HTTPS_Port/ server.xml
sed -i s/8005/$Server4_Shutdown_Port/ server.xml
sed -i s/8009/$Server4_AJP_Port/ server.xml
echo -n "Server 4: Change HTTP Connector Port...*:8080 to *:"; echo $Server4_HTTP_Port
echo -n "Server 4: Change HTTPS Connector Port..*:8443 to *:"; echo $Server4_HTTPS_Port
echo -n "Server 4: Change Shutdown Port.........*:8005 to *:"; echo $Server4_Shutdown_Port
echo -n "Server 4: Change AJP Connector Port....*:8009 to *:"; echo $Server4_AJP_Port
cd ..
cd ..
fi

echo ""

echo "##########################################################"
echo ""
echo "6. Start apache tomcat servers"
echo ""
echo "##########################################################"

if [ $Service = false ]; then
echo ""
$ServerDirectory1/bin/startup.sh

if (($AMOUNT > 1)); then
echo ""
$ServerDirectory2/bin/startup.sh
fi

if (($AMOUNT > 2)); then
echo ""
$ServerDirectory3/bin/startup.sh
fi

if (($AMOUNT > 3)); then
echo ""
$ServerDirectory4/bin/startup.sh
fi
echo ""
echo "Please remember that you have to open the ports in the firewall!"
echo ""
echo "##########################################################"
else

d=`pwd`

cd /etc/systemd/system/

cat <<END >tomcat-1.service
[Unit]
Description=Tomcat - instance %i
After=syslog.target network.target

[Service]
Type=forking

User=root
Group=root

WorkingDirectory=$d/$ServerDirectory1

Environment="JAVA_HOME=$JavaPath"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"

Environment="CATALINA_PID=$d/$ServerDirectory1/temp/tomcat.pid"
Environment="CATALINA_BASE=$d/$ServerDirectory1"
Environment="CATALINA_HOME=$d/$ServerDirectory1"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=$d/$ServerDirectory1/bin/startup.sh
ExecStop=$d/$ServerDirectory1/bin/shutdown.sh

#RestartSec=10
#Restart=always

[Install]
WantedBy=multi-user.target
END


if (($AMOUNT > 1)); then
cat <<END >tomcat-2.service
[Unit]
Description=Tomcat - instance %i
After=syslog.target network.target

[Service]
Type=forking

User=root
Group=root

WorkingDirectory=$d/$ServerDirectory2/

Environment="JAVA_HOME=$JavaPath"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"

Environment="CATALINA_PID=$d/$ServerDirectory2/temp/tomcat.pid"
Environment="CATALINA_BASE=$d/$ServerDirectory2"
Environment="CATALINA_HOME=$d/$ServerDirectory2"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=$d/$ServerDirectory2/bin/startup.sh
ExecStop=$d/$ServerDirectory2/bin/shutdown.sh

#RestartSec=10
#Restart=always

[Install]
WantedBy=multi-user.target

END
systemctl daemon-reload
systemctl enable tomcat-2
sudo service tomcat-2 start

fi

if (($AMOUNT > 2)); then
cat <<END >tomcat-3.service
[Unit]
Description=Tomcat - instance %i
After=syslog.target network.target

[Service]
Type=forking

User=root
Group=root

WorkingDirectory=$d/$ServerDirectory3

Environment="JAVA_HOME=$JavaPath"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"

Environment="CATALINA_PID=$d/$ServerDirectory3/temp/tomcat.pid"
Environment="CATALINA_BASE=$d/$ServerDirectory3"
Environment="CATALINA_HOME=$d/$ServerDirectory3"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=$d/$ServerDirectory3/bin/startup.sh
ExecStop=$d/$ServerDirectory3/bin/shutdown.sh

#RestartSec=10
#Restart=always

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl enable tomcat-3
sudo service tomcat-3 start
fi

if (($AMOUNT > 3)); then
cat <<END >tomcat-4.service
[Unit]
Description=Tomcat - instance %i
After=syslog.target network.target

[Service]
Type=forking

User=root
Group=root

WorkingDirectory=$d/$ServerDirectory4

Environment="JAVA_HOME=$JavaPath"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"

Environment="CATALINA_PID=$d/$ServerDirectory4/temp/tomcat.pid"
Environment="CATALINA_BASE=$d/$ServerDirectory4"
Environment="CATALINA_HOME=$d/$ServerDirectory4"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=$d/$ServerDirectory4/bin/startup.sh
ExecStop=$d/$ServerDirectory4/bin/shutdown.sh

#RestartSec=10
#Restart=always

[Install]
WantedBy=multi-user.target
END
systemctl daemon-reload
systemctl enable tomcat-4
sudo service tomcat-4 start
fi

systemctl daemon-reload
systemctl enable tomcat-1
sudo service tomcat-1 start

echo ""
echo -n "service tomcat-1 status : "; echo -n $(systemctl show -p SubState --value tomcat-1)

if (($AMOUNT > 1)); then 
echo ""
echo -n "service tomcat-2 status : "; echo -n $(systemctl show -p SubState --value tomcat-2)
fi

if (($AMOUNT > 2)); then 
echo ""
echo -n "service tomcat-3 status : "; echo -n $(systemctl show -p SubState --value tomcat-3)
fi

if (($AMOUNT > 3)); then 
echo ""
echo -n "service tomcat-4 status : "; echo -n $(systemctl show -p SubState --value tomcat-4)
fi

echo ""
echo ""
echo "Please remember that you have to open the ports in the firewall!"
echo ""
echo "##########################################################"
fi
