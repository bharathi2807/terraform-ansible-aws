
# Cloud Infrastructure Automation using Terraform and Ansible on AWS

This project demonstrates end-to-end infrastructure automation on AWS using Terraform and configuration management using Ansible. It provisions a highly available and scalable architecture with Auto Scaling and Load Balancing.

---

## 🚀 Architecture Overview

- Custom VPC with public subnets across multiple Availability Zones
- Internet Gateway and Route Tables for internet access
- Application Load Balancer (ALB) for traffic distribution
- Auto Scaling Group (ASG) for dynamic scaling of EC2 instances
- Launch Template for consistent EC2 configuration
- Terraform remote backend using S3 and DynamoDB
- Ansible for configuration management using dynamic inventory

---

## 🛠️ Technologies Used

- AWS (EC2, VPC, ALB, S3, IAM, Auto Scaling, DynamoDB)
- Terraform (Infrastructure as Code)
- Ansible (Configuration Management)
- Linux
- Nginx (Web Server)

---

## 📁 Project Structure

```

terraform-ansible-aws/
├── terraform/
│   ├── main.tf
│   ├── output.tf
|   |-- userdata.sh
│   ├── variables.tf
│   └── provider.tf
│
├── bootstrap/
│   ├── main.tf
|
├── ansible/
│   ├── ansible.cfg
│   ├── inventory.ini.tpl
│   ├── playbook.yml
│   └── roles/
│       └── webserver/
│           ├── tasks/
│           │   └── main.yml
│           └── files/
│               ├── index.html
│
└── README.md

````

---

## ⚙️ Prerequisites

- AWS CLI configured (`aws configure`)
- Terraform installed
- Ansible installed
- SSH key pair created in AWS

---

## 🔧 Setup Instructions

### Step 1: Bootstrap Backend (One-time setup)

Create S3 bucket and DynamoDB table for Terraform state:

```bash
cd bootstrap
terraform init
terraform apply
````

---

### Step 2: Deploy Infrastructure

```bash
cd terraform
terraform init
terraform apply
```

This will:

* Create VPC, Subnets, Security Groups
* Deploy ALB
* Create Launch Template
* Create Auto Scaling Group
* Configure scaling policy

---

### Step 3: Configure Servers using Ansible

Check dynamic inventory:
```bash
pip install boto boto3

ansible-galaxy collection install amazon.aws
````

```bash
ansible-inventory -i aws_ec2.yml --list
```

Run playbook:

```bash
ansible-playbook -i aws_ec2.yml playbook.yml
```

This will:

* Install Nginx
* Start service
* Deploy sample web page

---

## 🔄 Auto Scaling

* Minimum instances: 1
* Desired instances: 2
* Maximum instances: 3
* Scaling policy based on CPU utilization (60%)

---

## 🌐 Access Application

* Use ALB DNS name (from Terraform output)
* Open in browser → Nginx page should load

---

## 📊 Monitoring

* Basic health checks via ALB
* Instance status via AWS console
* Kubernetes-style monitoring not implemented in this project

---

## ⚠️ Key Highlights

* Infrastructure fully automated using Terraform
* State management with S3 and DynamoDB locking
* Dynamic scaling using Auto Scaling Group
* Load-balanced architecture across multiple AZs
* Configuration managed using Ansible dynamic inventory

---

## 🚧 Limitations

* No advanced monitoring/alerting (Prometheus/Grafana not included)
* No CI/CD pipeline integration (manual execution)
* Basic security (open SSH/HTTP for demo purposes)

---

## 📌 Future Enhancements

* Integrate Jenkins CI/CD pipeline
* Add CloudWatch monitoring and alerts
* Implement HTTPS with ACM and ALB
* Improve security group restrictions

---

## 👨‍💻 Author

**Jeeva Bharathi**
Aspiring DevOps / Cloud Engineer

---
