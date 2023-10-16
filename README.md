# Running a Retail Banking Application on an EC2 Server with Terraform and Jenkins

## Overview
The objective of this project was to deploy a 3-tier banking application leveraging Terraform for infrastructure provisioning and Jenkins for Continuous Integration/Continuous Deployment (CI/CD) automation. In response to specific challenges faced during manual deployments, this approach was adopted to enhance consistency, collaboration, and the overall quality of deployments.

## Infrastructure Overview
- VPC with 10.0.0.0/16 CIDR
  - Custom VPC provides isolation and security for applications
- 2 public subnets in separate AZs
  - Public subnets allow internet connectivity for Jenkins and app servers
- Internet gateway for public subnet internet access
- 2 Ubuntu 18.04 t2.micro EC2 instances
  - Separate instances for building server and app isolation
- Security groups restricting access
  - Jenkins SG opens port 8080 and 22
  - App SG opens port 8000 and 22

<img width="451" alt="Screen Shot 2023-10-14 at 7 08 05 AM" src="https://github.com/belindadunu/Deployment_5/assets/139175163/14a9513c-9526-4dc9-a83a-c58a455168d7">

## Jenkins Server Setup
- Installed Jenkins on the first EC2 instance
  - Dedicated server for CI/CD automation
- Created Jenkins user account for deployment
  - Enhanced security for managing deployments
- Generated SSH keys and copied the public key to the app server
  - Allows SSH access without a password from Jenkins to the app instance
 
![Screen Shot 2023-10-15 at 4 02 43 AM](https://github.com/belindadunu/Deployment_5/assets/139175163/41fe3fbe-a81e-4004-8611-051674ec2a3c)

## Jenkins CI/CD Pipeline
- Multibranch pipeline triggered by GitHub changes
  - Automates build and deploy for all branches
- Jenkinsfilev1 deploy stage copies and runs setup.sh on the app server
  - Automates deploying the latest version of the application
  - setup.sh installs dependencies and starts the application
  - Script contains steps required to deploy the app

## Updating Application
- Modified HTML content in the second branch
  - Simulates code change to the application
- Wanted to test out changes before merging to the main branch
- Ran build using Jenkinsfilev2 on a new branch
- Jenkinsfilev2 Clean stage terminates processes
  - Ensures fresh deployment of new code
- Verified updated application functionality as expected
- Deploy stage runs setup2.sh to redeploy the application
  - Gets the latest code changes from the second branch
- Ran build using Jenkinsfilev1 to deploy merged the main branch

<img width="1219" alt="Screen Shot 2023-10-15 at 6 22 47 PM" src="https://github.com/belindadunu/Deployment_5/assets/139175163/66750f70-375a-47b3-9e40-ca375ad26bfb">
_the original home.html web application_.

<img width="1219" alt="Screen Shot 2023-10-15 at 3 03 25 PM" src="https://github.com/belindadunu/Deployment_5/assets/139175163/f3fe7572-2f6f-404e-b19b-6e980c7e41df">
_the updated web application after running the Jenkinsfilev2 and re-running the Jenkinsfilev1_.

## 3. Purpose and Benefits:
By embracing Terraform and Jenkins, we aim to achieve several significant benefits:
- **Scalability:** Seamlessly scale infrastructure based on demand for optimal performance during high traffic periods.
- **Security:** Implement robust encryption protocols, user access controls, and network security policies.
- **Collaboration:** Facilitate teamwork through version-controlled infrastructure as code, enabling effective collaboration among team members.
- **Maintainability:** Ensure easy maintenance and updates of infrastructure components, leading to improved system stability and reduced downtime.

## Issues Faced

### 1. Compromised AWS Credentials
During testing, my AWS account credentials were inadvertently exposed in the public GitHub repository. This led to the credentials being compromised.

**To resolve this:**

1. Reset the AWS credentials and generate new access keys.
2. Updated the credentials stored in Terraform configuration files with the new keys.

### 2. Invalid Key Pair Error
After resetting credentials, Terraform apply began failing with an "InvalidKeyPair.NotFound" error when trying to launch EC2 instances.

```sh
Error: creating EC2 Instance: InvalidKeyPair.NotFound: The key pair 'BelindaKeyPair' does not exist
```

The cause was the existing key pair was associated with the compromised credentials. **To fix:**

1. Deleted the old key pair within AWS which was tied to old credentials.
2. Created a new key pair using Terraform's aws_key_pair resource.
3. Associated the new key pair to EC2 instances.

This ensured that only Terraform had access to the new key pair, improving security.

### Takeaways
- Be careful not to commit confidential data like AWS credentials to public repositories.
- Reset compromised credentials immediately and rotate access keys.
- Manage infrastructure elements like key pairs through Terraform rather than manually.

### 3. Setup.sh Not Found
When first configuring the Jenkins pipeline, the Deploy stage kept failing with a "setup.sh not found" error.

Root cause:

The path to setup.sh specified in the Jenkinsfile was incorrect:

```sh
sh "scp setup.sh ubuntu@IP:/home/ubuntu"
```

This was trying to copy setup.sh from the local workspace path rather than the cloned repository path.

**Resolution:**
Updated the path to correctly reference setup.sh within the cloned repo:

```sh
"scp repo/setup.sh ubuntu@IP:/home/ubuntu"
```

This ensured Jenkins could find setup.sh before trying to copy it to the remote server.

## Optimizations
1. **Integrate Terraform and Jenkins**
   - Use Jenkins to run `terraform apply` to provision infrastructure.
   - Add validation checks in Jenkins to verify the environment is ready before deploying the application code.

2. **Launch Configuration and Auto Scaling**
   - Create a launch configuration with an AMI baked with application dependencies.
   - Set up auto-scaling groups using the launch configuration to scale instances based on demand.

3. **Terraform Modules**
   - Break infrastructure into reusable modules for VPC, network, compute, load balancing, etc.
   - Improves collaboration, maintainability, and consistency.

4. **Cost Optimization:**
   - Regularly monitor your AWS resources to identify underutilized instances. Consider using reserved instances for predictable workloads and spot instances for non-critical tasks to optimize costs.

6. **Backup and Disaster Recovery:**
   - Implement regular automated backups of your data and applications. Utilize AWS services like Amazon S3 for data storage and configure lifecycle policies to move data to cost-effective storage classes over time.

## Conclusion
This project demonstrated the use of Terraform and Jenkins to automate the deployment of a 3-tier banking application on AWS infrastructure. The implementation of infrastructure as code and CI/CD pipelines significantly improves consistency, collaboration, and maintainability of the deployment process.

During the architectural design, a decision was made to place both the Jenkins server and the application instances in public subnets with internet access. An alternative approach could be placing the application servers in private subnets with no direct internet connectivity.

**Public Subnets:**
- Simpler to connect to both Jenkins and app servers from the internet.
- May reduce the need for a bastion host or VPN.
- Jenkins UI remains accessible for easier administration.

**Private Subnets:**
- Increased security for application servers by removing public exposure.
- Access is controlled through a bastion host, VPN, or proxy.
- May add complexity for administering both Jenkins and app servers.

For this initial implementation, public subnets were chosen for their simplicity. However, as the application grows and security requirements evolve, utilizing private subnets for the application tier could enhance the overall security posture. This highlights the importance of continuously evaluating and improving architectural decisions to meet changing needs.

