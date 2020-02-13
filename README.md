# Install Multiple Instances of Apache Tomcat on Linux 
A simple bash script to install 1 - 4 apache tomcat instances.
The script creates a separate folder for each instance and changes the ports in the server.xml
There is also the option of automatically configuring Apache Tomcat instances as a service.
## Run RunInstallation.sh

1. Go to the folder where you want to install the apache tomcat instances. The script creates subfolders for each instance in this folder.
2. Download script with
```
sudo wget https://raw.githubusercontent.com/roscha444/multiple-instances-tomcat/master/RunInstallation.sh
```
2. Make script executable
```
sudo chmod +x RunInstallation.sh
```
3. Run script with 
```
sudo ./RunInstallation.sh
```

## Ports of apache tomcats instances:

Server 1: HTTP Port...........:8080 <br />
Server 1: HTTPS Port..........:8443 <br />
Server 1: Shutdown Port.......:8005 <br />
Server 1: AJP Connector Port..:8009 <br />

Server 2: Change HTTP Connector Port...:8080 to :8081 <br />
Server 2: Change HTTPS Connector Port..:8443 to :8444 <br />
Server 2: Change Shutdown Port.........:8005 to :8006 <br />
Server 2: Change AJP Connector Port....:8009 to :8010 <br />

Server 3: Change HTTP Connector Port...:8080 to :8082 <br />
Server 3: Change HTTPS Connector Port..:8443 to :8445 <br />
Server 3: Change Shutdown Port.........:8005 to :8007 <br />
Server 3: Change AJP Connector Port....:8009 to :8011 <br />

Server 4: Change HTTP Connector Port...:8080 to :8083 <br />
Server 4: Change HTTPS Connector Port..:8443 to :8446 <br />
Server 4: Change Shutdown Port.........:8005 to :8008 <br />
Server 4: Change AJP Connector Port....:8009 to :8012 <br />

## Configured services:

service tomcat-1 start / stop / status / restart<br />
service tomcat-2 start / stop / status / restart<br />
service tomcat-3 start / stop / status / restart<br />
service tomcat-4 start / stop / status / restart<br />

## In this build Version 1.0 :
* The script creates a separate folder for each apache tomcat instance and changes the ports in the server.xml. After the installation all instances are started.
* The possibility to choose whether the apache tomcat instances should be automatically configured as a service.

## Planned in next build:
* Select apache tomcat version to install
* Start and Stop all instances with one command
