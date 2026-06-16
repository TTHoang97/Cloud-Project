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

### Next Steps
- Begin Terraform configuration for AWS infrastructure