# AWS EC2 Setup with Terraform

This project uses **Terraform** to automate the creation of an AWS infrastructure with two EC2 instances:

- **EC2 Instance 1**: Accessible from the internet via **public IP** using **SSH**.
- **EC2 Instance 2**: Accessible **only privately** via **SSH** from EC2 Instance 1 (bastion host setup).

## 🚀 Project Features

- Creates a **VPC** with public and private subnets.
- Configures **Internet Gateway** and **NAT Gateway**.
- Sets up **Route Tables** for internet access.
- Deploys **two EC2 instances**:
  - **First EC2** (public subnet, public IP, SSH accessible).
  - **Second EC2** (private subnet, accessible only through first EC2).

## 🛠️ Technologies Used

- [Terraform](https://www.terraform.io/)
- [AWS EC2](https://aws.amazon.com/ec2/)
- [AWS VPC](https://aws.amazon.com/vpc/)
