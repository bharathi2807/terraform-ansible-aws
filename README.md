# 🌍  Terraform + Ansible AWS Infrastructure Automation

## 🚀 Project Overview
This project demonstrates an **end-to-end DevOps workflow** where AWS infrastructure is provisioned using **Terraform** and configured automatically using **Ansible**.

The setup creates a **highly available web application** using two EC2 instances behind an **Application Load Balancer (ALB)**, all deployed inside a custom VPC.

---

## Architecture
- Custom **VPC** with public subnets across two Availability Zones  
- **Internet Gateway** and Route Tables  
- Two **EC2 instances** provisioned using Terraform  
- **Application Load Balancer (ALB)** for traffic distribution  
- **Security Groups** allowing SSH and HTTP access  
- **Nginx** installed and configured using Ansible  
- Static web content deployed via Ansible  

---

## 🧰 Tools & Technologies

* **Terraform** — Infrastructure provisioning
* **Ansible** — Configuration management
* **AWS** (EC2, VPC, ALB, Security Groups, S3)  
* **Nginx** — Web server
* **Linux** (Amazon Linux) 
* **Git & GitHub**  

---

## 🧱 Project Structure

```

terraform-ansible-aws/
├── terraform/
│   ├── main.tf
│   ├── output.tf
|   |-- userdata.sh
│   ├── variables.tf
│   └── provider.tf
│
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


```

---


## Project Flow
1. Terraform provisions AWS infrastructure:
   - VPC, subnets, IGW, route tables  
   - EC2 instances  
   - Application Load Balancer and target groups  
2. Terraform dynamically generates **Ansible inventory**  
3. Ansible installs and configures **Nginx** on EC2 instances  
4. Web application becomes accessible via **ALB DNS name**  

---

## How to Run

### 1. Provision Infrastructure
```bash
cd terraform
terraform init
terraform apply
```

### 2. Configure Servers using Ansible
```bash
cd ansible
ansible-playbook -i inventory.ini playbook.yml
```

### Output

* Nginx web page accessible via ALB DNS

* Load balanced traffic across two EC2 instances

### Notes

* Terraform state files and SSH keys are excluded using .gitignore

* Inventory is generated dynamically using Terraform templates

* Designed for learning and portfolio demonstration purposes

---

## 👨‍💻 Author

**Jeeva Bharathi**
Aspiring DevOps / Cloud Engineer

---