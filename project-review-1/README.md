# Multi-Application Deployment on AWS

## Complete Production-Style AWS Infrastructure Deployment

---

# Table of Contents

1. Project Overview
2. Architecture Overview
3. Architecture Flow
4. AWS Services Used
5. Technologies Used
6. Networking Architecture
7. VPC Configuration
8. Public and Private Subnets
9. Internet Gateway
10. NAT Gateway
11. Route Tables
12. Security Groups
13. Amazon Route 53
14. DNS Resolution Flow
15. Application Load Balancer (ALB)
16. ALB Listener Rules
17. Target Groups
18. Host-Based Routing
19. EC2 Application Layer
20. PM2 Process Management
21. MongoDB Database Layer
22. Dockerized MongoDB Deployment
23. Launch Templates
24. Auto Scaling Groups (ASG)
25. Health Checks and Self-Healing
26. Traffic Flow Explanation
27. Database Backup Workflow
28. Amazon S3 Backup Storage
29. High Availability and Fault Tolerance
30. Project Workflow Step-by-Step
31. Folder Structure
32. Key Features
33. Future Improvements
34. Conclusion

---

# 1. Project Overview

This project demonstrates a complete production-style multi-application deployment on AWS using modern cloud architecture concepts. The main objective of this project is to host multiple applications inside a single AWS infrastructure using scalable, secure, and highly available services.

In this project, two different applications are deployed:

* Organic Application
* Fitness Application

Both applications are hosted behind a single Application Load Balancer (ALB) using host-based routing. The infrastructure is designed using public and private subnets for better security and follows real-world cloud deployment practices.

The project also includes:

* Route 53 DNS management
* Application Load Balancer
* Target Groups
* Auto Scaling Groups
* Launch Templates
* MongoDB Database
* Dockerized Deployment
* Database Backup Automation
* Amazon S3 Backup Storage
* High Availability Architecture
* Self-Healing Infrastructure

This architecture simulates how modern enterprise applications are deployed in production environments.

---

# 2. Architecture Overview

The architecture is divided into multiple layers:

## User Layer

Users access the applications using custom domain names:

* organic.in-sur.site
* fitness.in-sur.site

These domains are managed using Amazon Route 53.

---

## Networking Layer

The networking layer contains:

* VPC
* Public Subnets
* Private Subnets
* Internet Gateway
* NAT Gateway
* Route Tables
* Security Groups

This layer controls the communication and security between all AWS resources.

---

## Load Balancing Layer

The Application Load Balancer receives internet traffic and distributes requests to backend applications.

The ALB uses:

* Listener Rules
* Host-Based Routing
* Target Groups
* Health Checks

---

## Application Layer

The application layer contains:

* EC2 Instances
* Auto Scaling Groups
* PM2 Managed Applications

Applications are deployed inside private subnets for better security.

---

## Database Layer

MongoDB database is deployed using Docker Compose inside an EC2 instance.

The database layer is completely private and accessible only from application instances.

---

## Backup Layer

Automated MongoDB backups are uploaded to Amazon S3 using a shell script.

This improves:

* Disaster Recovery
* Data Durability
* Backup Management

---

# 3. Architecture Flow

The complete request flow works like this:

```text
User
   ↓
Route 53 DNS Resolution
   ↓
Application Load Balancer
   ↓
Listener Rules
   ↓
Target Group Selection
   ↓
Auto Scaling Group
   ↓
EC2 Application Instances
   ↓
MongoDB Database
```

---

# 4. AWS Services Used

| AWS Service               | Purpose                      |
| ------------------------- | ---------------------------- |
| Amazon EC2                | Application Hosting          |
| Amazon Route 53           | DNS Management               |
| Application Load Balancer | Traffic Distribution         |
| Auto Scaling Group        | Automatic Scaling            |
| Launch Templates          | Instance Configuration       |
| Target Groups             | Traffic Routing              |
| Amazon S3                 | Backup Storage               |
| VPC                       | Network Isolation            |
| NAT Gateway               | Outbound Internet Access     |
| Internet Gateway          | Public Internet Connectivity |

---

# 5. Technologies Used

| Technology     | Purpose                    |
| -------------- | -------------------------- |
| Node.js        | Backend Application        |
| PM2            | Process Manager            |
| MongoDB        | Database                   |
| Docker         | Containerization           |
| Docker Compose | Multi-Container Deployment |
| Bash Scripting | Backup Automation          |
| Linux Cron     | Scheduled Tasks            |
| AWS CLI        | AWS Service Integration    |

---

# 6. Networking Architecture

The entire infrastructure is deployed inside a custom VPC.

The VPC provides complete network isolation and allows secure communication between AWS resources.

VPC CIDR:

```bash
10.0.0.0/16
```

The VPC contains:

* Public Subnets
* Private Application Subnets
* Private Database Subnets
* Internet Gateway
* NAT Gateway
* Route Tables

---

# 7. VPC Configuration

A Virtual Private Cloud (VPC) is created to isolate the infrastructure from other AWS customers.

The VPC acts like a private network inside AWS.

Benefits of VPC:

* Network Isolation
* Security
* Controlled Communication
* Custom Routing
* Private Deployments

CIDR Used:

```bash
10.0.0.0/16
```

This provides a large private IP range for all resources.

---

# 8. Public and Private Subnets

## Public Subnets

Public subnets are used for resources that need internet access.

Resources inside Public Subnets:

* Application Load Balancer
* NAT Gateway

Public Subnet CIDR:

```bash
10.0.1.0/24
```

---

## Private Application Subnets

Application EC2 instances are deployed inside private subnets.

This improves security because users cannot directly access the EC2 instances.

Traffic only comes through the ALB.

Private App Subnet CIDR:

```bash
10.0.2.0/24
```

---

## Private Database Subnet

MongoDB database server is deployed inside a private database subnet.

The database is fully isolated from the internet.

Private DB Subnet CIDR:

```bash
10.0.3.0/24
```

---

# 9. Internet Gateway

An Internet Gateway (IGW) is attached to the VPC.

The IGW enables communication between:

* AWS Resources
* Public Internet

Without the Internet Gateway:

* Users cannot access the ALB
* Public subnets cannot communicate with the internet

The public route table routes internet traffic to the IGW.

---

# 10. NAT Gateway

The NAT Gateway is deployed inside the public subnet.

Purpose of NAT Gateway:

* Allows private subnet instances to access the internet
* Blocks inbound internet traffic

Why NAT Gateway is needed:

Private instances sometimes need internet access for:

* Package Installation
* Docker Pull
* Software Updates
* AWS CLI Communication

But they should not be publicly accessible.

The NAT Gateway solves this problem.

---

# 11. Route Tables

Route tables control network routing inside the VPC.

---

## Public Route Table

```text
10.0.0.0/16 → local
0.0.0.0/0 → Internet Gateway
```

This allows public subnet resources to communicate with the internet.

---

## Private Route Table

```text
10.0.0.0/16 → local
0.0.0.0/0 → NAT Gateway
```

This allows private instances to access the internet securely.

---

# 12. Security Groups

Security Groups act like virtual firewalls.

They control inbound and outbound traffic.

---

## ALB Security Group

Allowed:

```text
HTTP (80) from 0.0.0.0/0
```

This allows internet users to access the ALB.

---

## Application Security Group

Allowed:

```text
HTTP (80) only from ALB Security Group
SSH (22) only from My IP
```

This prevents direct internet access to EC2 instances.

---

## MongoDB Security Group

Allowed:

```text
MongoDB (27017) only from Application Security Group
SSH (22) only from My IP
```

This protects the database from unauthorized access.

---

# 13. Amazon Route 53

Amazon Route 53 is used for DNS management.

Route 53 converts domain names into IP addresses.

Without Route 53:

Users would need to access applications using IP addresses.

Instead, users can access:

* organic.in-sur.site
* fitness.in-sur.site

A hosted zone is created for:

```text
in-sur.site
```

---

# 14. DNS Resolution Flow

DNS resolution works like this:

1. User enters domain name in browser
2. Browser checks DNS records
3. Route 53 resolves the domain
4. Route 53 returns ALB DNS
5. Browser sends request to ALB
6. ALB processes the request

Example:

```text
organic.in-sur.site
   ↓
Route 53
   ↓
ALB DNS Name
```

This is how domain-based access works.

---

# 15. Application Load Balancer (ALB)

The Application Load Balancer is one of the most important components in this architecture.

The ALB is internet-facing and deployed inside public subnets across multiple Availability Zones.

Responsibilities of ALB:

* Receives user traffic
* Distributes requests
* Performs health checks
* Applies listener rules
* Routes traffic to target groups
* Supports high availability

The ALB improves:

* Scalability
* Availability
* Traffic Management
* Fault Tolerance

---

## ALB Listener

The ALB listens on:

```text
HTTP : 80
```

The listener receives incoming requests and evaluates listener rules.

---

# 16. ALB Listener Rules

Listener rules are used to decide where traffic should go.

The ALB checks:

* Host Header
* Path
* Conditions

In this project, host-based routing is implemented.

---

## Rule 1

Condition:

```text
Host Header = organic.in-sur.site
```

Action:

```text
Forward to organic-tg
```

---

## Rule 2

Condition:

```text
Host Header = fitness.in-sur.site
```

Action:

```text
Forward to fitness-tg
```

---

# 17. Target Groups

Target Groups are used to route traffic from the ALB to EC2 instances.

Target groups are extremely important because they connect:

* ALB
* EC2 Instances
* Auto Scaling Groups

Two target groups are created:

| Target Group | Purpose             |
| ------------ | ------------------- |
| organic-tg   | Organic Application |
| fitness-tg   | Fitness Application |

---

## How Target Groups Work

1. ALB receives request
2. Listener rule matches domain
3. Request forwarded to Target Group
4. Target Group selects healthy EC2 instance
5. Traffic reaches application

---

## Health Checks

Target Groups continuously monitor instance health.

If health check fails:

* ALB stops sending traffic
* ASG replaces unhealthy instance

This enables self-healing infrastructure.

---

# 18. Host-Based Routing

Host-based routing allows multiple applications to run behind a single ALB.

The ALB checks the domain name and forwards traffic accordingly.

Example:

```text
organic.in-sur.site → organic-tg
fitness.in-sur.site → fitness-tg
```

Benefits:

* Cost Optimization
* Centralized Traffic Management
* Easier Scaling
* Simplified Architecture

---

# 19. EC2 Application Layer

Applications are deployed inside EC2 instances.

The EC2 instances are placed inside private subnets for better security.

Applications are not directly accessible from the internet.

Traffic only reaches them through:

```text
Route 53 → ALB → Target Group → EC2
```

This architecture improves security significantly.

---

# 20. PM2 Process Management

PM2 is used to manage Node.js applications.

PM2 helps:

* Keep applications running
* Restart crashed applications
* Monitor processes
* Run applications in background

Example:

```bash
pm2 start app.js
```

Benefits:

* Process Stability
* Easy Monitoring
* Automatic Restart

---

# 21. MongoDB Database Layer

MongoDB is used as the backend database.

The database is deployed inside a private subnet.

This improves:

* Security
* Isolation
* Controlled Access

Only application instances can access the database.

---

# 22. Dockerized MongoDB Deployment

MongoDB is deployed using Docker Compose.

Benefits of Dockerized MongoDB:

* Easy Deployment
* Portability
* Isolation
* Consistency
* Persistent Storage

---

## Docker Compose Configuration

The MongoDB container uses:

```yaml
MONGO_INITDB_ROOT_USERNAME
MONGO_INITDB_ROOT_PASSWORD
```

Port Mapping:

```yaml
27017:27017
```

Docker Volume:

Persistent volumes ensure data remains safe even if container restarts.

---

# 23. Launch Templates

Launch Templates store EC2 configuration.

Stored Configuration:

* AMI
* Instance Type
* Security Groups
* Key Pair
* User Data

Separate launch templates are created for:

* Organic Application
* Fitness Application

Benefits:

* Consistent Deployment
* Faster Scaling
* Reusable Configuration

---

# 24. Auto Scaling Groups (ASG)

Auto Scaling Groups automatically manage EC2 instances.

Two ASGs are created:

| ASG         | Purpose     |
| ----------- | ----------- |
| organic-asg | Organic App |
| fitness-asg | Fitness App |

---

## ASG Configuration

Desired Capacity:

```text
1
```

Minimum Capacity:

```text
1
```

Maximum Capacity:

```text
2
```

---

## ASG Responsibilities

* Maintain desired instance count
* Replace unhealthy instances
* Distribute instances across AZs
* Enable scalability

---

# 25. Health Checks and Self-Healing

Health checks continuously monitor EC2 instances.

If an instance becomes unhealthy:

1. Target Group marks instance unhealthy
2. ALB stops sending traffic
3. ASG terminates unhealthy instance
4. ASG launches replacement instance
5. New instance automatically registers to Target Group

This is called self-healing infrastructure.

---

# 26. Traffic Flow Explanation

The complete traffic flow works like this:

## Step 1

User enters:

```text
organic.in-sur.site
```

---

## Step 2

Route 53 resolves the domain.

---

## Step 3

Traffic reaches ALB.

---

## Step 4

ALB listener checks host header.

---

## Step 5

ALB forwards request to:

```text
organic-tg
```

---

## Step 6

Target Group forwards request to healthy EC2 instance.

---

## Step 7

Application communicates with MongoDB.

---

## Step 8

Response returns back to user.

---

# 27. Database Backup Workflow

An automated MongoDB backup workflow is implemented.

Purpose:

* Disaster Recovery
* Data Protection
* Backup Automation

---

## Step 1 — Execute mongodump

The backup script executes:

```bash
mongodump
```

inside the MongoDB container.

---

## Step 2 — Copy Backup Files

Backup files are copied from container to EC2 host using:

```bash
docker cp
```

---

## Step 3 — Compress Backup

Backup files are compressed into:

```text
.tar.gz
```

archive.

---

## Step 4 — Upload to S3

Backup uploaded using:

```bash
aws s3 cp
```

---

## Step 5 — Cleanup

Temporary files are removed automatically.

---

# 28. Amazon S3 Backup Storage

MongoDB backups are stored inside:

```text
s3-kajapathy-databackup
```

Benefits:

* Durable Storage
* Cloud Backup
* Disaster Recovery
* Secure Storage

---

# 29. High Availability and Fault Tolerance

The architecture supports high availability using:

* Multi-AZ ALB Deployment
* Auto Scaling Groups
* Health Checks
* Self-Healing Infrastructure

If one instance fails:

* ALB reroutes traffic
* ASG launches replacement
* Application remains available

---

# 30. Project Workflow Step-by-Step

## Step 1

Create VPC

---

## Step 2

Create Public and Private Subnets

---

## Step 3

Attach Internet Gateway

---

## Step 4

Create NAT Gateway

---

## Step 5

Configure Route Tables

---

## Step 6

Configure Security Groups

---

## Step 7

Create Route 53 Hosted Zone

---

## Step 8

Create Application Load Balancer

---

## Step 9

Create Target Groups

---

## Step 10

Configure Host-Based Routing

---

## Step 11

Deploy EC2 Applications

---

## Step 12

Create Launch Templates

---

## Step 13

Create Auto Scaling Groups

---

## Step 14

Deploy MongoDB Database

---

## Step 15

Implement Database Backup Workflow

---

# 31. Folder Structure

```bash
project/
│
├── app/
├── docker-compose.yml
├── backup.sh
├── README.md
├── screenshots/
├── architecture/
└── scripts/
```

---

# 32. Key Features

* Multi-Application Hosting
* Host-Based Routing
* Auto Scaling
* High Availability
* Self-Healing Infrastructure
* Secure Private Subnet Deployment
* Dockerized MongoDB
* Automated Database Backup
* S3 Cloud Storage
* Production-Style Architecture

---

# 33. Future Improvements

Future enhancements can include:

* HTTPS using ACM
* CI/CD Pipeline
* Terraform Automation
* CloudWatch Monitoring
* AWS WAF
* Multi-Region Deployment
* Kubernetes Migration

---

# 34. Conclusion

This project demonstrates a complete production-style AWS infrastructure deployment using modern cloud architecture principles.

The implementation successfully combines:

* Networking
* Compute
* Scaling
* Load Balancing
* DNS Management
* Database Deployment
* Backup Automation
* High Availability
* Security

This architecture closely resembles real-world enterprise cloud deployments and provides hands-on experience with AWS infrastructure design, scalable application hosting, and cloud networking concepts.

The project also demonstrates how AWS services can work together to build secure, scalable, fault-tolerant, and production-ready cloud applications.
