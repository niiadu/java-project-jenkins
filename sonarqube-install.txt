# update and upgrade the ubuntu server
sudo apt update && sudo apt upgrade -y

# Changing The Hostname of The EC2 
sudo hostnamectl set-hostname sonar
sudo su - ubuntu

# Configure ElasticSearch
sudo vi /etc/sysctl.conf

# Add the following configurations
vm.max_map_count=262144
fs.file-max=65536
ulimit -n 65536
ulimit -u 4096

# reboot the server
sudo reboot

# Install the PostgreSQL repository
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -

# Install the PostgreSQL database server by running
sudo apt install postgresql postgresql-contrib -y

# Start and Enable PostgreSQL server to start automatically at boot time by running:
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Check Status of PostgreSQL server
sudo systemctl status postgresql

# Change the password for the default PostgreSQL user
sudo passwd postgres

# Switch to the postgres user
su - postgres

# Create a new user by typing
createuser sonar

# Switch to the PostgreSQL shell
psql

# Set a password for the newly created user for SonarQube database
ALTER USER sonar WITH ENCRYPTED password 'sonar';

# Create a new database for PostgreSQL database by running
CREATE DATABASE sonarqube OWNER sonar;

# Grant database access to sonar
GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar;

# Exit from the psql shell
\q

# Switch back to the sudo user by running the exit command
exit

# Installation of Java and Verifying Java installation
cd /opt
sudo apt-get install openjdk-17-jdk zip -y
java -version

# Installing and Extracting the zip file
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.4.87374.zip
sudo unzip sonarqube-9.9.4.87374.zip

# Remove The Zip File and Rename the Extracted File
sudo rm -rf sonarqube-9.9.4.87374.zip
sudo mv sonarqube-9.9.4.87374/ sonarqube

# Create a new user and new group called sonar
sudo groupadd sonar
sudo useradd sonar -g sonar -d /opt/sonarqube
sudo chown -R sonar:sonar /opt/sonarqube

# Find the following lines
#sonar.jdbc.username=
#sonar.jdbc.password=

# Uncomment and provide the PostgreSQL username and password of the database that we have created earlier
sonar.jdbc.username=sonar
sonar.jdbc.password=sonar

# Add this configuration to sonar.properties file
sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube

# Configure Systemd service for sonar service
sudo vi /etc/systemd/system/sonar.service

# Add the following configuration
[Unit]

Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

User=sonar
Group=sonar
Restart=always

LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target

# Reload the systemd daemon
sudo systemctl daemon-reload

# enable, start and check status of SonarQube as a service
sudo systemctl enable sonar
sudo systemctl start sonar
sudo systemctl status sonar

# access sonarqube
http://ip-address-sonarqube:9000