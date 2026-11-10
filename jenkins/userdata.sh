#!/bin/bash

# Capture all output
exec > >(tee -a /var/log/jenkins-install.log) 2>&1

set -euxo pipefail

echo "===================================="
echo "Starting Jenkins Installation"
echo "Date: $(date)"
echo "===================================="

# Update Ubuntu
apt-get update -y

# Install Java 21 and curl
apt-get install -y openjdk-21-jdk curl

# Verify Java
java -version

# Add Jenkins repository key
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key \
  -o /usr/share/keyrings/jenkins-keyring.asc

# Add Jenkins repository
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  > /etc/apt/sources.list.d/jenkins.list

# Update repositories
apt-get update -y

# Install Jenkins
apt-get install -y jenkins

# Enable and start Jenkins
systemctl enable jenkins
systemctl start jenkins

# Wait for Jenkins
sleep 30

# Verify Jenkins
systemctl status jenkins --no-pager

echo "===================================="
echo "Jenkins Installation Completed"
echo "===================================="

# Initial admin password
if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
    cat /var/lib/jenkins/secrets/initialAdminPassword
fi

echo "Installation finished at $(date)"
