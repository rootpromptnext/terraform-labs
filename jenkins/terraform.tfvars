
aws_region         = "us-east-1"
instance_type      = "t3.medium"
key_name           = "my-keypair"

# Replace with your public IP
allowed_ssh_cidr   = "0.0.0.0/0"

# For lab purposes only. Restrict this to your IP in production.
allowed_jenkins_cidr = "0.0.0.0/0"
