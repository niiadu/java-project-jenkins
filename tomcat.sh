# update and upgrade the ubuntu server
sudo apt update && sudo apt upgrade -y

# change the hostname to Tomcat
sudo hostnamectl set-hostname tomcat
sudo su -ubuntu

# Install JDK and verify the version
sudo apt install default-jdk -y
sudo apt install openjdk-17-jdk
java -version

#Installing and extracting apache tomcat
sudo wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.91/bin/apache-tomcat-9.0.91.tar.gz
sudo tar -xzvf apache-tomcat-9.0.91.tar.gz

# Remove and Rename the zip file
sudo rm -rf apache-tomcat-9.0.91.tar.gz
sudo mv apache-tomcat-9.0.85/ tomcat9

# Giving All permissions to tomcat
sudo chmod 777 -R /opt/tomcat9

# Creating Symbolic Links to Start and Stop Tomcat
sudo ln -s /opt/tomcat9/bin/startup.sh /usr/bin/starttomcat
sudo ln -s /opt/tomcat9/bin/shutdown.sh /usr/bin/stoptomcat

# Go to this file path, in other to gain tomcat manager access
sudo vi /opt/tomcat9/webapps/manager/META-INF/context.xml

<Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />
# comment out this lines with "<!-- -->"

# add your username and roles to this file path
sudo vi /opt/tomcat9/conf/tomcat-users.xml
 <user username="admin" password="admin" roles="manager-gui, manager-script, admin-gui, manager-status"/>        
 <user username="jomacs" password="jomacs" roles="manager-script, manager-gui, admin-gui"/>

# Access Tomcat on port 8080
http://ip-address:8080

