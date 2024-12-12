The GitHub Link for the Application Code Is:

https://github.com/N4si/DevSecOps-Project.git

#!/bin/bash

# Update system packages
sudo apt update -y && sudo apt upgrade -y

# 1. Install Docker
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
sudo apt install -y docker-ce
sudo systemctl enable docker && sudo systemctl start docker
sudo usermod -aG docker $USER

# 2. Install Kubernetes (kubectl)
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

# 3. Install Jenkins
sudo apt install -y openjdk-11-jdk
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update -y
sudo apt install -y jenkins
sudo systemctl enable jenkins && sudo systemctl start jenkins

# Display installation completion message
echo "Docker, Kubernetes, and Jenkins installation complete."

# Reminder to reload the shell for Docker group changes
echo "Please log out and log back in to apply Docker group membership."



# Update and Install Prerequisites
sudo apt update -y
sudo apt install -y openjdk-11-jdk wget unzip software-properties-common

# SonarQube Setup
echo "Installing SonarQube..."
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.0.0.68432.zip
unzip sonarqube-10.0.0.68432.zip
cd sonarqube-10.0.0.68432/bin/linux-x86-64
./sonar.sh start
cd ~

# Prometheus Setup
echo "Installing Prometheus..."
wget https://github.com/prometheus/prometheus/releases/download/v2.46.0/prometheus-2.46.0.linux-amd64.tar.gz
tar -xvf prometheus-2.46.0.linux-amd64.tar.gz
cd prometheus-2.46.0.linux-amd64
nohup ./prometheus --config.file=prometheus.yml &
cd ~

# Grafana Setup
echo "Installing Grafana..."
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
sudo apt update
sudo apt install -y grafana
sudo systemctl start grafana-server
sudo systemctl enable grafana-server

# Trivy Setup
echo "Installing Trivy..."
wget https://github.com/aquasecurity/trivy/releases/download/v0.46.0/trivy_0.46.0_Linux-64bit.deb
sudo dpkg -i trivy_0.46.0_Linux-64bit.deb

