
## Issues Faced

## Compromised AWS Credentials
During testing, my AWS account credentials were inadvertently exposed in the public GitHub repository. This led to the credentials being compromised.

**To resolve this:**

1. Reset the AWS credentials and generated new access keys.
2. Updated the credentials stored in Terraform configuration files with the new keys.

## Invalid Key Pair Error
After resetting credentials, Terraform apply began failing with an "InvalidKeyPair.NotFound" error when trying to launch EC2 instances.

The cause was the existing key pair was associated with the compromised credentials. **To fix:**

1. Deleted the old key pair within AWS which was tied to old credentials.
2. Created a new key pair using Terraform's aws_key_pair resource.
3. Associated the new key pair to EC2 instances.

This ensured that only Terraform had access to the new key pair, improving security.

## Takeaways
- Be careful not to commit confidential data like AWS credentials to public repositories.
- Reset compromised credentials immediately and rotate access keys.
- Manage infrastructure elements like key pairs through Terraform rather than manually.


## Optimizations

1. **Integrate Terraform and Jenkins**
   - Use Jenkins to run `terraform apply` to provision infrastructure.
   - Add validation checks in Jenkins to verify the environment is ready before deploying application code.

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

