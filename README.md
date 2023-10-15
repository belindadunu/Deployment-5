# Deploying a Banking Application on AWS

## 1. Introduction:
The goal of this project was to deploy a 3-tier banking app using Terraform for infrastructure as code and Jenkins for CI/CD automation. In response to specific challenges faced during manual deployments, this approach was adopted to enhance consistency, collaboration, and the overall quality of deployments.

## 2. Infrastructure Overview:

### VPC Configuration:
- CIDR Block: 10.0.0.0/16
  - Custom VPC provides isolation and security for applications  
- 2 public subnets in separate AZs
- Internet gateway for public subnet internet access
- 2 Ubuntu 18.04 t2.micro EC2 instances for build server and application isolation

### Security Groups:
- **Jenkins SG:**
  - Opens port 8080 and 22
- **App SG:**
  - Opens port 8000 and 22

## 3. Purpose and Benefits:
By embracing Terraform and Jenkins, our team aimed to achieve several significant benefits:
- **Scalability:** Seamlessly scale infrastructure based on demand for optimal performance during high traffic periods.
- **Security:** Implement security protocols, user access controls, and network security policies.
- **Collaboration:** Facilitate teamwork through version-controlled infrastructure as code, enabling effective collaboration among team members.
- **Maintainability:** Ensure easy maintenance and updates of infrastructure components, leading to improved system stability and reduced downtime.

## 4. Challenges and Solutions:
### Challenges Faced:


### Solutions Implemented:


### Lessons Learned:
The challenges encountered provided valuable insights, emphasizing the importance of meticulous planning and collaborative problem-solving. These lessons will guide our future deployments, ensuring smoother processes and faster resolutions. *elaborate here*

## 5. Security Measures:
To guarantee the security of our deployed application, the following measures were implemented:
- **User Access Controls:** Restriction of user access through secure authentication methods, ensuring authorized personnel can modify configurations (was config, access keys, key pairs).
- **Network Security Policies:** Strict firewall rules and network segmentation to prevent unauthorized access attempts.

## 6. Testing Procedures:
### Test Scenarios:


### Test Results:


## 7. Scalability and Future Enhancements:
### Scalability Measures:
The infrastructure was designed with scalability in mind, allowing for seamless expansion of resources based on demand through Terraform if/when reuired. Load balancers and auto-scaling configurations could be implemented to ensure the application can handle varying workloads effectively.

### Future Enhancements:

## 8. Conclusion:
### Achievements:
This deployment initiative resulted in several key achievements, including enhanced deployment speed, improved reliability, and strengthened security measures....
