# Deploy Jenkins on AWS EC2 using Terraform

## Project Overview

This project provisions an AWS EC2 instance with Ubuntu 24.04 LTS and automatically installs Jenkins using Terraform and EC2 User Data.

### Architecture

- Cloud Provider: AWS
- Region: us-east-1 (Mumbai)
- OS: Ubuntu 24.04 LTS
- Instance Type: t3.medium
- Java: OpenJDK 21
- CI/CD Tool: Jenkins
- Infrastructure as Code: Terraform
- Storage: 20 GB gp3

### Project Structure

```text
jenkins/
├── main.tf
├── variables.tf
├── outputs.tf
├── userdata.sh
├── terraform.tfvars
└── README.md
```

## Step 1: Create AWS EC2 Key Pair

Create a new AWS Key Pair using AWS CLI.

```bash
aws ec2 create-key-pair \
  --key-name my-keypair \
  --region us-east-1 \
  --query 'KeyMaterial' \
  --output text > my-keypair.pem
```

Set the correct permissions:

```bash
chmod 400 my-keypair.pem
```

Verify the key pair:

```bash
aws ec2 describe-key-pairs \
  --key-names my-keypair \
  --region us-east-1
```

**Important:** Keep `my-keypair.pem` secure. Do not upload it to GitHub.

## Step 2: Configure Terraform Variables

Update `terraform.tfvars`:

```hcl
aws_region           = "us-east-1"
instance_type        = "t3.medium"
key_name             = "my-keypair"

allowed_ssh_cidr     = "YOUR_PUBLIC_IP/32"
allowed_jenkins_cidr = "YOUR_PUBLIC_IP/32"
```

Replace `YOUR_PUBLIC_IP` with your public IP address.

## Step 3: Initialize Terraform

Initialize the Terraform working directory.

```bash
terraform init
```

This downloads the AWS provider and initializes Terraform.

## Step 4: Validate Terraform Configuration

```bash
terraform validate
```

Expected result:

```text
Success! The configuration is valid.
```

## Step 5: Review Terraform Execution Plan

```bash
terraform plan
```

Review the resources Terraform is going to create:

- AWS Security Group
- AWS EC2 Instance
- Ubuntu 24.04 AMI selection

## Step 6: Deploy Infrastructure

Execute the Terraform configuration:

```bash
terraform apply -auto-approve
```

Terraform will:

1. Identify the Ubuntu 24.04 AMI.
2. Create the Security Group.
3. Configure SSH and Jenkins ports.
4. Launch the EC2 instance.
5. Execute the Jenkins installation script through User Data.
6. Install Java 21 and Jenkins.
7. Start and enable Jenkins.

**Note:** EC2 instance creation does not mean Jenkins installation is complete. Allow a few minutes for User Data execution.

## Step 7: Get EC2 Public IP

```bash
terraform output jenkins_public_ip
```

Get the Jenkins URL:

```bash
terraform output jenkins_url
```

Get all Terraform outputs:

```bash
terraform output
```

## Step 8: Connect to EC2 using SSH

Use the private key created in Step 1.

```bash
ssh -i my-keypair.pem ubuntu@EC2_PUBLIC_IP
```

Replace `EC2_PUBLIC_IP` with the actual public IP returned by Terraform.

## Step 9: Verify Jenkins Installation

Check Java:

```bash
java -version
```

Check Jenkins service:

```bash
sudo systemctl status jenkins
```

Check Jenkins port:

```bash
sudo ss -tulnp | grep 8080
```

Check Jenkins installation logs:

```bash
sudo tail -f /var/log/cloud-init-output.log
```

## Step 10: Retrieve Jenkins Initial Admin Password

Execute:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Copy the password.

## Step 11: Access Jenkins Dashboard

Open your browser:

```text
http://EC2_PUBLIC_IP:8080
```

1. Enter the initial administrator password.
2. Select Install suggested plugins.
3. Create your first administrator user.
4. Complete the Jenkins setup.

Jenkins is now ready!

## Step 12: Destroy AWS Infrastructure

After completing the lab, remove the infrastructure to avoid unnecessary AWS charges.

```bash
terraform destroy -auto-approve
```

**Note:** The EC2 instance and Security Group will be deleted. The separately created AWS Key Pair remains in your account.

## Troubleshooting

### Jenkins installation not completed

Check:

```bash
sudo tail -100 /var/log/cloud-init-output.log
```

### Jenkins service not running

```bash
sudo systemctl restart jenkins
sudo systemctl status jenkins
```

### SSH permission denied

```bash
chmod 400 my-keypair.pem
```

Verify that the key pair name and AWS region match your Terraform configuration.

### Jenkins dashboard not accessible

Verify Security Group inbound rules:

| Port | Protocol | Purpose |
|---|---|---|
| 22 | TCP | SSH |
| 8080 | TCP | Jenkins Web UI |

Also verify:

```bash
sudo systemctl status jenkins
```

---

## Learning Outcomes

After completing this lab, you will understand:

- AWS EC2 provisioning using Terraform.
- AWS Security Group configuration.
- AWS Key Pair creation using CLI.
- Terraform init, plan, apply and destroy.
- EC2 User Data and automated software installation.
- Java and Jenkins installation on Ubuntu.
- Connecting to EC2 using SSH.
- Accessing and configuring Jenkins.
