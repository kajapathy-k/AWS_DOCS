# Multi-Application Deployment on AWS

A production-style multi-application deployment architecture on AWS using **Route 53, Application Load Balancer (ALB), Auto Scaling Groups (ASG), EC2, MongoDB, Docker, and Amazon S3 Backup Workflow**.

This project demonstrates how multiple applications can be hosted securely and efficiently inside a single AWS infrastructure using **host-based routing**, **private subnet deployment**, and **high availability architecture**.

---

# Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture Overview](#architecture-overview)
3. [Technologies Used](#technologies-used)
4. [AWS Services Used](#aws-services-used)
5. [Networking Architecture](#networking-architecture)
6. [Route 53 Configuration](#route-53-configuration)
7. [Application Load Balancer (ALB)](#application-load-balancer-alb)
8. [Target Groups](#target-groups)
9. [Host-Based Routing](#host-based-routing)
10. [Auto Scaling Groups (ASG)](#auto-scaling-groups-asg)
11. [Launch Templates](#launch-templates)
12. [EC2 Application Layer](#ec2-application-layer)
13. [Dockerized MongoDB Database Layer](#dockerized-mongodb-database-layer)
14. [Database Backup Workflow](#database-backup-workflow)
15. [Amazon S3 Backup Storage](#amazon-s3-backup-storage)
16. [Security Groups](#security-groups)
17. [Traffic Flow](#traffic-flow)
18. [High Availability & Fault Tolerance](#high-availability--fault-tolerance)
19. [Project Workflow](#project-workflow)
20. [GitHub Repository Structure](#github-repository-structure)
21. [Key Learnings](#key-learnings)
22. [Future Improvements](#future-improvements)
23. [Conclusion](#conclusion)

---

# Project Overview

This project demonstrates a complete multi-application deployment on AWS using a scalable and secure cloud architecture.

Two different applications are hosted:

* **Organic Application**
* **Fitness Application**

Both applications are deployed behind a single **Application Load Balancer (ALB)** using **host-based routing**.

The infrastructure is designed using:

* Public and Private Subnets
* Internet Gateway
* NAT Gateway
* Route Tables
* Auto Scaling Groups
* Target Groups
* MongoDB Database
* Automated Database Backup Workflow

The applications are deployed inside **private subnets** for improved security, while the ALB is deployed inside **public subnets** to handle internet traffic.

---

# Architecture Overview

## Domain Routing

| Domain              | Routed To  |
| ------------------- | ---------- |
| organic.in-sur.site | organic-tg |
| fitness.in-sur.site | fitness-tg |

The Application Load Balancer checks the incoming domain name and forwards traffic to the correct target group.

---

# Technologies Used

| Technology     | Purpose                    |
| -------------- | -------------------------- |
| AWS EC2        | Application Hosting        |
| Route 53       | DNS Management             |
| ALB            | Traffic Distribution       |
| ASG            | Auto Scaling               |
| MongoDB        | Database                   |
| Docker         | Containerization           |
| Docker Compose | Multi-container Management |
| Amazon S3      | Backup Storage             |
| Linux Cron Job | Backup Automation          |
| Bash Scripting | Backup Script              |
| PM2            | Node.js Process Manager    |

---

# AWS Services Used

| AWS Service               | Purpose                      |
| ------------------------- | ---------------------------- |
| Amazon EC2                | Application Servers          |
| Amazon Route 53           | DNS Resolution               |
| Application Load Balancer | Host-Based Routing           |
| Auto Scaling Group        | Automatic Scaling            |
| Launch Templates          | Instance Configuration       |
| Target Groups             | Traffic Routing              |
| Amazon S3                 | Database Backup Storage      |
| VPC                       | Network Isolation            |
| NAT Gateway               | Outbound Internet Access     |
| Internet Gateway          | Public Internet Connectivity |

---

# Networking Architecture

The infrastructure is deployed inside a custom VPC.

## VPC CIDR

```bash
10.0.0.0/16
```

---

## Public Subnets

Public subnets contain:

* Application Load Balancer
* NAT Gateway

These subnets have direct internet access through the Internet Gateway.

Example:

```bash
10.0.1.0/24
```

---

## Private Application Subnets

Private application subnets contain:

* EC2 Application Instances
* Auto Scaling Groups

These instances do not have direct internet access.

Example:

```bash
10.0.2.0/24
```

---

## Private Database Subnet

Private database subnet contains:

* MongoDB Database Server

Example:

```bash
10.0.3.0/24
```

---

# Route 53 Configuration

Amazon Route 53 is used for DNS management.

## Hosted Zone

```bash
in-sur.site
```

---

## DNS Records

### Organic Application

```bash
organic.in-sur.site
```

Alias Record → ALB

---

### Fitness Application

```bash
fitness.in-sur.site
```

Alias Record → ALB

---

# Application Load Balancer (ALB)

The ALB is internet-facing and deployed inside public subnets across multiple Availability Zones.

Responsibilities of ALB:

* Receives internet traffic
* Checks listener rules
* Routes traffic to target groups
* Performs health checks
* Distributes traffic across healthy instances

---

## Listener

The ALB listens on:

```bash
HTTP : 80
```

---

# Target Groups

Two separate target groups are used.

| Target Group | Application         |
| ------------ | ------------------- |
| organic-tg   | Organic Application |
| fitness-tg   | Fitness Application |

---

## Why Target Groups Are Important

Target groups act as the bridge between:

* ALB
* EC2 Instances
* Auto Scaling Groups

The ALB forwards traffic to target groups, and target groups forward traffic to healthy EC2 instances.

---

## Health Checks

Health checks continuously monitor instance health.

If an instance becomes unhealthy:

* ALB stops sending traffic
* ASG replaces the instance automatically

---

# Host-Based Routing

Host-based routing is implemented using ALB listener rules.

---

## Rule 1

```bash
Host Header = organic.in-sur.site
```

Forward to:

```bash
organic-tg
```

---

## Rule 2

```bash
Host Header = fitness.in-sur.site
```

Forward to:

```bash
fitness-tg
```

---

# Auto Scaling Groups (ASG)

Two Auto Scaling Groups are created.

| ASG         | Purpose             |
| ----------- | ------------------- |
| organic-asg | Organic App Scaling |
| fitness-asg | Fitness App Scaling |

---

## ASG Features

* Maintains desired instance count
* Automatically replaces unhealthy instances
* Supports multi-AZ deployment
* Enables high availability

---

## Scaling Configuration

| Setting          | Value |
| ---------------- | ----- |
| Desired Capacity | 1     |
| Minimum Capacity | 1     |
| Maximum Capacity | 2     |

---

# Launch Templates

Launch templates store EC2 configuration.

Stored Configuration:

* AMI
* Instance Type
* Security Groups
* Key Pair
* User Data

Separate launch templates are created for:

* Organic Application
* Fitness Application

---

# EC2 Application Layer

Applications are deployed on EC2 instances inside private subnets.

Each EC2 instance runs:

* Node.js Application
* PM2 Process Manager

Applications are accessible only through the ALB.

---

# Dockerized MongoDB Database Layer

MongoDB is deployed using Docker Compose.

---

## Docker Compose Features

* MongoDB Authentication
* Persistent Volumes
* Port Mapping
* Containerized Deployment

---

## MongoDB Configuration

```yaml
MONGO_INITDB_ROOT_USERNAME
MONGO_INITDB_ROOT_PASSWORD
```

MongoDB runs inside a Docker container:

```bash
mongodb
```

Database Name:

```bash
fitness-tracker
```

---

# Database Backup Workflow

An automated MongoDB backup workflow is implemented.

---

## Backup Steps

### Step 1 — Execute mongodump

The backup script executes:

```bash
mongodump
```

inside the MongoDB Docker container.

---

### Step 2 — Copy Backup

Backup files are copied from container to EC2 host using:

```bash
docker cp
```

---

### Step 3 — Compress Backup

Backup files are compressed into:

```bash
.tar.gz
```

archive.

---

### Step 4 — Upload to Amazon S3

The backup file is uploaded using:

```bash
aws s3 cp
```

---

### Step 5 — Cleanup

Temporary files are removed automatically.

---

# Amazon S3 Backup Storage

MongoDB backups are stored in:

```bash
s3-kajapathy-databackup
```

Benefits:

* Durable storage
* Offsite backup
* Disaster recovery
* Centralized backup management

---

# Security Groups

## ALB Security Group

Allowed:

```bash
HTTP (80) from 0.0.0.0/0
```

---

## Application Security Group

Allowed:

```bash
HTTP (80) only from ALB Security Group
SSH (22) from My IP
```

---

## MongoDB Security Group

Allowed:

```bash
MongoDB (27017) only from App Security Group
SSH (22) from My IP
```

---

# Traffic Flow

```text
User
   ↓
Route 53
   ↓
Application Load Balancer
   ↓
Listener Rules
   ↓
Target Group
   ↓
Auto Scaling Group
   ↓
EC2 Application Instances
   ↓
MongoDB Database
```

---

# High Availability & Fault Tolerance

The architecture supports high availability using:

* Multi-AZ ALB Deployment
* Auto Scaling Groups
* Health Checks
* Self-Healing Infrastructure

If an EC2 instance fails:

1. ALB detects unhealthy instance
2. Stops sending traffic
3. ASG launches replacement instance
4. Traffic resumes automatically

---

# Project Workflow

## Step 1

Create VPC and Subnets

---

## Step 2

Configure Route Tables and Internet Gateway

---

## Step 3

Deploy Application Load Balancer

---

## Step 4

Configure Route 53 DNS

---

## Step 5

Create Target Groups

---

## Step 6

Configure Host-Based Routing

---

## Step 7

Launch EC2 Applications

---

## Step 8

Create Launch Templates

---

## Step 9

Create Auto Scaling Groups

---

## Step 10

Deploy MongoDB Database

---

## Step 11

Implement Database Backup Workflow

---

# GitHub Repository Structure

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

# Key Learnings

* Multi-application hosting using ALB
* Host-based routing
* DNS delegation with Route 53
* Auto Scaling implementation
* Private subnet deployment
* Dockerized database deployment
* Automated database backups
* High availability architecture
* AWS networking concepts

---

# Future Improvements

* HTTPS using ACM
* CI/CD Pipeline
* Terraform Infrastructure as Code
* CloudWatch Monitoring
* WAF Integration
* Multi-Region Deployment

---

# Conclusion

This project demonstrates a real-world AWS deployment architecture using modern cloud infrastructure concepts.

The architecture provides:

* Scalability
* High Availability
* Security
* Fault Tolerance
* Automated Recovery
* Centralized Traffic Management

The implementation successfully combines networking, compute, storage, scaling, and backup solutions into a production-style cloud deployment architecture.
