# Cloud Project

A production-pattern REST API demonstrating a complete DevOps lifecycle —
from local development through containerization, infrastructure provisioning,
and automated deployment to AWS.

## Live Endpoint

GET http://cloud-project-alb-1395068385.us-east-1.elb.amazonaws.com/health

## Architecture
GitHub Push → GitHub Actions CI/CD → Docker Build → ECR → ECS Fargate
↑
Terraform-provisioned infrastructure
VPC · ALB · ECS · ECR · CloudWatch

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Go |
| Containerization | Docker (multi-stage build) |
| Infrastructure as Code | Terraform |
| Cloud | AWS (ECS Fargate, ECR, ALB, VPC, CloudWatch) |
| CI/CD | GitHub Actions |
| Monitoring | CloudWatch Logs + Alarms |

## What This Demonstrates

- **Infrastructure as Code** — All AWS infrastructure defined in Terraform,
  version controlled and reproducible from scratch
- **Containerization** — Multi-stage Docker build producing a minimal
  production image
- **CI/CD Pipeline** — Automated build, test, and deployment on every push
  to main. Pull requests trigger build and test only
- **Deployment traceability** — Every deployment tagged with Git commit SHA,
  making rollbacks and auditing straightforward
- **Observability** — CloudWatch log group capturing container output,
  alarms monitoring CPU utilization and HTTP 5xx error rates
- **Security** — Credentials managed via GitHub Secrets, sensitive
  Terraform state excluded from version control, ECS tasks only accept
  traffic from the load balancer via security group rules

## Project Structure
Cloud-Project/

├── main.go                      # Go REST API
├── go.mod                       # Go module definition
├── Dockerfile                   # Multi-stage container build
├── .github/
│   └── workflows/
│       └── deploy.yml           # CI/CD pipeline
├── Terraform/
│   ├── main.tf                  # AWS infrastructure
│   ├── variables.tf             # Input variables
│   └── outputs.tf               # Output values
└── docs/
└── progress.md              # Build log and learnings

## Infrastructure

Provisioned entirely via Terraform:

- **VPC** with public subnets across two availability zones
- **Application Load Balancer** accepting public traffic on port 80
- **ECS Fargate** running the containerized API — no server management required
- **ECR** private registry storing Docker images tagged by commit SHA
- **CloudWatch** log group with 7 day retention and alarms for CPU and errors
- **IAM** roles scoped to minimum required permissions for ECS task execution

## API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| GET | /health | Returns service health status |

## Local Development

**Prerequisites:** Go 1.26+, Docker

```bash
# Clone the repo
git clone git@github.com:TTHoang97/Cloud-Project.git
cd Cloud-Project

# Run locally
go run main.go

# Build and run in Docker
docker build -t cloud-project .
docker run -p 8080:8080 cloud-project

# Hit the endpoint
curl http://localhost:8080/health
```

## CI/CD Pipeline

Every push to main triggers the full pipeline:

1. Build and test Go code
2. Build Docker image tagged with commit SHA
3. Push image to ECR
4. Update ECS task definition with new image
5. Deploy to ECS and wait for stability confirmation

Pull requests trigger steps 1 only — no deployment until code is merged.