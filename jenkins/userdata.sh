
#!/bin/bash

set -euxo pipefail

# Update package index
apt-get update -y

# Install Java 21
apt-get install -y openjdk-21-jdk curl

# Verify Java
java -version

# Add Jenkins repository key
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key \
  -o /usr/share/keyrings/jenkins-keyring.asc

# Add Jenkins repository
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  > /etc/apt/sources.list.d/jenkins.list

# Update package index
apt-get update -y

# Install Jenkins
apt-get install -y jenkins

# Enable and start Jenkins
systemctl enable jenkins
systemctl start jenkins

# Wait for Jenkins to initialize
for i in {1..30}; do
    if systemctl is-active --quiet jenkins; then
        break
    fi
    sleep 10
done

# Verify Jenkins
systemctl status jenkins --no-pager

# Print initial admin password
echo "=================================="
echo "Jenkins installation completed!"
echo "=================================="

if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
    cat /var/lib/jenkins/secrets/initialAdminPassword
fi

echo "Jenkins URL: http://$(hostname -I | awk '{print $1}'):8080"
