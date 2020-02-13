#!/bin/bash


#Here you can set your java path!!!

JavaPath=$JAVA_HOME
#EXAMPLE: JavaPath=/usr/lib64/jvm/jre-1.8.0-openjdk

#Here you can set the name of the tmp directory
tmp=tmpTomcatApache

#Here you can set the name of the servers directorys
ServerDirectory1=apache-tomcat-1
ServerDirectory2=apache-tomcat-2
ServerDirectory3=apache-tomcat-3
ServerDirectory4=apache-tomcat-4


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
wget https://www-us.apache.org/dist/tomcat/tomcat-9/v9.0.30/bin/apache-tomcat-9.0.30.tar.gz

{
  tar -zxvf apache-tomcat-9.0.30.tar.gz -C ./
} &> /dev/null
echo "extract apache-tomcat-9.0.30.tar.gz"
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
cp -ar $tmp/apache-tomcat-9.0.30/* $ServerDirectory1

if (($AMOUNT > 1)); then
echo "Copy apache tomcat to Server 2!"
mkdir $ServerDirectory2
cp -ar $tmp/apache-tomcat-9.0.30/* $ServerDirectory2
fi

if (($AMOUNT > 2)); then
echo "Copy apache tomcat to Server 3!"
mkdir $ServerDirectory3
cp -ar $tmp/apache-tomcat-9.0.30/* $ServerDirectory3
fi

if (($AMOUNT > 3)); then
echo "Copy apache tomcat to Server 4!"
mkdir $ServerDirectory4
cp -ar $tmp/apache-tomcat-9.0.30/* $ServerDirectory4
fi
rm -r $tmp
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

if (($AMOUNT > 1)); then
cd $ServerDirectory2
cd conf
sed -i s/8080/8081/ server.xml 
sed -i s/8443/8444/ server.xml 
sed -i s/8005/8006/ server.xml
sed -i s/8009/8010/ server.xml
echo ""
echo "Server 2: Change HTTP Connector Port...*:8080 to *:8081"
echo "Server 2: Change HTTPS Connector Port..*:8443 to *:8444"
echo "Server 2: Change Shutdown Port.........*:8005 to *:8006"
echo "Server 2: Change AJP Connector Port....*:8009 to *:8010"
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
echo "Server 4: Change HTTP Connector Port...*:8080 to *:8083"
echo "Server 4: Change HTTPS Connector Port..*:8443 to *:8446"
echo "Server 4: Change Shutdown Port.........*:8005 to *:8008"
echo "Server 4: Change AJP Connector Port....*:8009 to *:8012"
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
echo "##########################################################"
fi
