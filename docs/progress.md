# Project Progress Log

## What We're Building
A Go REST API containerized with Docker, deployed to AWS using Terraform for
infrastructure provisioning, with a CI/CD pipeline via GitHub Actions and basic
monitoring via CloudWatch. The goal is demonstrating a full DevOps lifecycle
end to end.

## Full Project Sequence
1. Go REST API — done
2. Docker containerization — in progress
3. GitHub Actions CI/CD pipeline
4. Terraform to provision AWS infrastructure
5. Deploy containerized app to AWS via the pipeline
6. Monitoring with CloudWatch, stretch goal Grafana/Prometheus

---

## Session 1

### What Was Built
- Created GitHub repo (Cloud-Project) with SSH authentication configured
- Built a Go REST API with a single /health endpoint using Go's standard library
- Created a Dockerfile using a multi-stage build
- Created CLAUDE.md and docs/progress.md for project context and progress tracking

### What Was Learned

**Go REST API basics**
- net/http handles routing and HTTP server functionality
- Handler functions take two parameters: ResponseWriter (write back to caller)
  and Request (incoming request data)
- json.NewEncoder writes Go data structures directly into the response as JSON

**HTTP Headers**
- Headers are metadata that travel alongside requests and responses
- Content-Type tells the receiver what format the response body is in
- application/json is the standard Content-Type for API responses

**Dockerfile multi-stage build**
- Stage 1 (builder): Uses golang:1.26-alpine to compile the Go binary. 1.26 is the latest version of Go at the current time(6/16/26)
- Stage 2: Uses a minimal alpine image and copies only the compiled binary
- Result is a small, production-appropriate container image

**Why Terraform over manual AWS console**
- Infrastructure as code means your environment is version controlled and
  reproducible — anyone can clone the repo and spin up the same environment
- Clicking through the AWS console manually leaves no record of what was built
  or how — Terraform files are that record
- This is standard practice in DevOps roles and a direct talking point in interviews

## Session 2

### What Was Built
- Created GitHub Actions CI pipeline with two jobs: build and docker
- Pipeline automatically triggers on every push to main branch

### What Was Learned

**Continuous Integration (CI)**
- CI automatically builds and tests code on every push
- Prevents "integration hell" by catching broken code immediately
- Standard infrastructure in professional engineering teams

**CI vs CD**
- CI: automated building and testing on every push
- CD: automated deployment of successfully built artifacts to an environment
- We have CI now, CD comes when we wire up AWS deployment

**GitHub Actions concepts**
- Workflows are defined in .github/workflows/ as yaml files
- Each job runs on a fresh isolated virtual machine
- Jobs have no shared state — each needs its own checkout step
- actions/checkout@v4 clones your repo onto the runner machine so code is available
- Actions are versioned with @ syntax — pinning versions prevents unexpected changes

**go build -o main .**
- -o flag specifies the output binary name
- . tells Go to compile code in the current directory

### Next Steps
- Set up Terraform to provision AWS infrastructure
- Wire up CD in the pipeline to deploy to AWS
- Configure monitoring

## Session 3

### What Was Built
- Terraform configuration with three files: main.tf, variables.tf, outputs.tf
- AWS infrastructure provisioned including VPC, subnets, internet gateway,
  route tables, security groups, ALB, ECR repository, ECS cluster, ECS task
  definition, ECS service, IAM roles, and CloudWatch log group
- Docker image pushed to ECR
- Application deployed and running on AWS ECS Fargate
- Live endpoint confirmed returning JSON response

### What Was Learned

**Terraform basics**
- Infrastructure as code — resources defined in .tf files and provisioned
  by running terraform plan then terraform apply
- variables.tf defines reusable input values
- outputs.tf surfaces useful values after apply like the app URL
- terraform plan previews changes without applying them — always run this first
- Resources reference each other by name e.g. aws_lb.app_lb.arn

**AWS infrastructure concepts**
- VPC: isolated network environment for your resources
- Subnets: subdivisions of the VPC across availability zones for redundancy
- Internet Gateway: connects the VPC to the public internet
- Route Table: defines where network traffic gets directed
- Security Groups: firewall rules controlling what traffic is allowed in and out
- ALB (Application Load Balancer): accepts public traffic on port 80 and
  forwards it to containers on port 8080 internally
- ECR: AWS private Docker image registry
- ECS Fargate: managed container runtime — AWS handles the underlying servers
- IAM Role: grants ECS permission to pull images and write logs
- CloudWatch Log Group: captures container logs for observability

**ECR image push process**
- Authenticate Docker to ECR using aws ecr get-login-password
- Tag local image with full ECR repository URL
- Push tagged image to ECR
- Force ECS service redeployment to pick up new image

## Session 4

### What Was Built
- Full CD pipeline added to GitHub Actions
- Every push to main now automatically builds, tests, pushes to ECR,
  and redeploys to ECS without any manual steps
- Live endpoint confirmed returning JSON after automated deployment
- .gitignore added to protect sensitive Terraform files from being committed

### What Was Learned

**CD Pipeline concepts**
- needs: build ensures deploy job only runs if build passes — broken code
  never gets deployed
- if: github.ref condition restricts deployment to main branch only —
  pull requests only trigger build and test, not deployment
- IMAGE_TAG uses github.sha (commit hash) instead of latest — every
  deployment is traceable to a specific commit
- wait-for-service-stability makes the pipeline wait until ECS confirms
  the new container is healthy before marking the run green

**GitHub Secrets**
- AWS credentials stored as encrypted secrets in GitHub repo settings
- Referenced in yaml as ${{ secrets.AWS_ACCESS_KEY_ID }} — never exposed
  in logs or code
- The correct way to handle credentials in any CI/CD pipeline

**Security concepts**
- Never commit .terraform/, terraform.tfstate, or .terraform.lock.hcl
- tfstate contains live infrastructure state including sensitive values
- .gitignore protects against accidental commits of sensitive files
- Bots actively scan GitHub for exposed credentials — exposure can result
  in immediate account compromise

**Full pipeline flow**
- git push → GitHub Actions triggers → build job compiles and tests Go
  code → deploy job builds Docker image → pushes to ECR with commit SHA
  as tag → downloads current ECS task definition → renders new task
  definition with updated image → deploys to ECS → waits for stability
  confirmation → pipeline marks green

### Next Steps
- Configure monitoring via CloudWatch
- Clean up and document the project README for portfolio presentation