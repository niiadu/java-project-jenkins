# update and upgrade the ubuntu server
sudo apt update && sudo apt upgrade -y

# Changing The Hostname of The EC2 
sudo hostnamectl set-hostname nexus
sudo su - ubuntu

# A new user called nexus and grant sudo access to manage nexus services as it is not advisable to run nexus as a root user
sudo adduser nexus
sudo echo "nexus ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/nexus
sudo su - nexus

# Installation of Java and Verifying Java installation
cd /opt
sudo apt install openjdk-8-jdk -y
java -version

# Installing and Extracting Nexus Repository
sudo wget https://download.sonatype.com/nexus/3/nexus-3.65.0-02-unix.tar.gz
sudo tar -xzvf nexus-3.65.0-02-unix.tar.gz

# Remove The Zip File and Rename the Extracted File
sudo rm -rf nexus-3.65.0-02-unix.tar.gz
sudo mv nexus-3.65.0-02 nexus

# Change the ownership of nexus and sonatype-work directories.
sudo chown -R nexus:nexus /opt/nexus
sudo chown -R nexus:nexus /opt/sonatype-work

# Adding the nexus user to the nexus.rc file:
sudo vi /opt/nexus/bin/nexus.rc

#run_as_user="" uncomment this and add the nexus user
run_as_user="nexus"

# Create a new service file for Nexus using the vi editor
sudo vi /etc/systemd/system/nexus.service

# Add the following configuration
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target

# Reload the systemd daemon
sudo systemctl daemon-reload

# Start and Enable Nexus
sudo systemctl start nexus.service
sudo systemctl enable nexus.service

# Verify Status of Nexus
sudo systemctl status nexus.service