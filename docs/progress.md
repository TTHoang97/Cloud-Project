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
- Stage 1 (builder): Uses golang:1.23-alpine to compile the Go binary
- Stage 2: Uses a minimal alpine image and copies only the compiled binary
- Result is a small, production-appropriate container image

**Why Terraform over manual AWS console**
- Infrastructure as code means your environment is version controlled and
  reproducible — anyone can clone the repo and spin up the same environment
- Clicking through the AWS console manually leaves no record of what was built
  or how — Terraform files are that record
- This is standard practice in DevOps roles and a direct talking point in interviews

### Current Blockers
- None

### Next Steps
- Verify Docker image builds and runs locally
- Push all files to GitHub
- Set up GitHub Actions CI/CD pipeline
- Begin Terraform configuration for AWS infrastructure