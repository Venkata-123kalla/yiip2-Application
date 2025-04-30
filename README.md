# Yii2 Docker Swarm Deployment Guide

## 🚀 Step-by-Step Implementation Process

### 1️⃣ Infrastructure Setup
1. **Provision AWS EC2 Instance**
   - Launch Ubuntu 22.04 LTS instance (t2.medium recommended)
   - Configure security groups to allow:
     - SSH (22)
     - HTTP (80)
     - HTTPS (443)
     - Docker Swarm ports (2377, 7946, 4789)
   - Attach an elastic IP for consistent address

2. **Configure SSH Access**
   - Generate new SSH key pair
   - Add public key to EC2 instance
   - Test SSH connection

### 2️⃣ Application Preparation
1. **Set Up Yii2 Application**
   - Create minimal Yii2 project or clone sample repository
   - Ensure all dependencies are in `composer.json`
   - Configure database connection if needed

2. **Containerize the Application**
   - Create Dockerfile with:
     - PHP-FPM base image
     - Necessary PHP extensions
     - Composer installation
     - Yii2 entrypoint configuration
   - Build and test image locally

### 3️⃣ Docker Swarm Configuration
1. **Initialize Swarm Mode**
   - SSH into EC2 instance
   - Run `docker swarm init`
   - Save join tokens for future node additions

2. **Create Docker Stack**
   - Prepare `docker-compose.yml` with:
     - Service definitions
     - Replica settings
     - Health checks
     - Resource limits
   - Deploy stack with `docker stack deploy`

### 4️⃣ NGINX Reverse Proxy Setup
1. **Install and Configure NGINX**
   - Install NGINX on host machine (not in container)
   - Create virtual host configuration:
     - Proxy pass to Swarm service
     - SSL configuration (Let's Encrypt)
     - Health check endpoint
   - Test configuration and restart NGINX

### 5️⃣ Ansible Automation
1. **Create Ansible Playbook**
   - Structure playbook with roles for:
     - Docker installation
     - NGINX configuration
     - Swarm initialization
     - Application deployment
   - Use variables for configurable parameters

2. **Run Provisioning**
   - Set up inventory file with EC2 IP
   - Execute playbook to automate entire setup
   - Verify all components are running

### 6️⃣ CI/CD Pipeline Implementation
1. **Configure GitHub Actions**
   - Create workflow file in `.github/workflows/`
   - Set up triggers for main branch pushes
   - Add steps for:
     - Building Docker image
     - Pushing to registry
     - SSH deployment

2. **Implement Deployment Steps**
   - Add workflow to:
     1. Build and tag new image
     2. Push to Docker Hub/GHCR
     3. SSH into EC2 instance
     4. Pull new image
     5. Update Swarm service

### 7️⃣ Verification and Testing
1. **Validate Deployment**
   - Check running containers with `docker service ps`
   - Test application through NGINX
   - Verify health checks

2. **Test Rollback Procedure**
   - Simulate failed deployment
   - Verify automatic rollback works
   - Check logs for errors
