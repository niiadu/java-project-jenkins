# update and upgrade the ubuntu server
sudo apt update && sudo apt upgrade -y

# change hostname and switch to the new hostname
sudo hostnamectl set-hostname jenkins
sudo su - ubuntu

# install Java 17 and verify the installation
sudo apt install fontconfig openjdk-17-jre -y
java -version

# Install jenkins
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins

# Start and Enable Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Check Status of Jenkins with 
sudo systemctl status jenkins

# Access Jenkins run on port 8080
http://ip-address:8080