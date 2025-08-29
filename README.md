# Custom VPC with Public & Private Subnets + CI/CD Infrastructure

This Terraform configuration creates a comprehensive infrastructure for a web application with CI/CD capabilities, including:

## Architecture

The configuration creates:
- **VPC**: Custom VPC with CIDR block 10.0.0.0/16
- **Public Subnets**: 2 public subnets (10.0.1.0/24, 10.0.2.0/24) across 2 AZs
- **Private Subnets**: 2 private subnets (10.0.11.0/24, 10.0.12.0/24) across 2 AZs
- **Internet Gateway**: For public subnet internet access
- **NAT Gateway**: For private subnet internet access (placed in first public subnet)
- **Route Tables**: Separate routing for public and private subnets

## Infrastructure Components

### EC2 Instances
- **Public EC2 Instance**: Hosts Jenkins, SonarQube, Prometheus, and Grafana
  - Instance Type: t3.medium (configurable)
  - Services: Jenkins (8080), SonarQube (9000), Prometheus (9090), Grafana (3000)
  - Auto-installs Docker and starts all services via user data
- **Private EC2 Instance**: For application deployment
  - Instance Type: t3.small (configurable)
  - Secure placement in private subnet

### Security Groups
- **Public EC2 Security Group**: Allows SSH, HTTP, HTTPS, and service-specific ports
- **Private EC2 Security Group**: Allows traffic from public subnets only
- **ALB Security Group**: For load balancer (if using ALB)

### IAM Roles & Policies
- **EC2 Role**: With permissions for S3, CloudWatch, and CloudWatch Logs
- **Instance Profile**: Attached to EC2 instances for secure credential management

### Storage & CDN (Optional)
- **S3 Bucket**: For storing application assets
- **CloudFront Distribution**: Global CDN for fast content delivery
- **Route 53**: Domain management (optional, commented out)

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- AWS region access (default: us-east-1)
- EC2 Key Pair for SSH access
- Domain name (optional, for Route 53)

## Usage

1. **Copy and customize variables**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Review the plan**:
   ```bash
   terraform plan
   ```

4. **Apply the configuration**:
   ```bash
   terraform apply
   ```

5. **Destroy resources** (when done):
   ```bash
   terraform destroy
   ```

## Customization

You can customize the configuration by modifying `terraform.tfvars`:

- **VPC & Networking**: CIDR blocks, availability zones, region
- **EC2 Configuration**: Instance types, key pair name
- **Domain**: Route 53 configuration (optional)
- **Security**: Port configurations in security groups

## Service Access

After deployment, access your services at:

- **Jenkins**: `http://<public-ip>:8080`
- **SonarQube**: `http://<public-ip>:9000`
- **Prometheus**: `http://<public-ip>:9090`
- **Grafana**: `http://<public-ip>:3000`

## Outputs

The configuration provides these outputs:
- `vpc_id`: VPC ID
- `public_ec2_public_ip`: Public IP of the public EC2 instance
- `private_ec2_private_ip`: Private IP of the private EC2 instance
- `s3_bucket_name`: S3 bucket name for app assets
- `cloudfront_distribution_domain`: CloudFront distribution domain

## Security Notes

- Public subnets have `map_public_ip_on_launch = true` for internet access
- Private subnets route internet traffic through NAT Gateway
- Security groups restrict access to necessary ports only
- IAM roles follow least privilege principle
- All resources are properly tagged for cost tracking

## Cost Considerations

- **NAT Gateway**: ~$32.40/month
- **EC2 Instances**: t3.medium (~$30/month), t3.small (~$15/month)
- **CloudFront**: Pay-per-use pricing
- **S3**: Pay-per-use storage pricing
- **Route 53**: $0.50/month per hosted zone + $0.40/month per million queries

## Next Steps

1. **Customize Security Groups**: Restrict SSH access to your IP address
2. **Configure Jenkins**: Set up your CI/CD pipelines
3. **Set up Monitoring**: Configure Prometheus and Grafana dashboards
4. **Deploy Application**: Use the private EC2 instance for your application
5. **Set up Load Balancer**: Add ALB for production traffic management
6. **Configure SSL**: Add ACM certificates for HTTPS

## Troubleshooting

- **SSH Access**: Ensure your key pair exists in AWS and security group allows SSH
- **Service Access**: Check if services are running: `docker ps`
- **Security Groups**: Verify security group rules allow necessary traffic
- **IAM Permissions**: Ensure EC2 instances have proper IAM roles attached
