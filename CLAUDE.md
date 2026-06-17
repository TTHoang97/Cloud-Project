# Cloud-Project - Claude Context File

## Project Goal
Build a complete end-to-end DevOps project to demonstrate real-world skills for
DevOps/Platform Engineering/SRE roles while utiziling AI Tools. Priority is learning by doing, not perfection.

## Current Stack
- Language: Go
- Containerization: Docker
- Infrastructure as Code: Terraform
- Cloud: AWS
- CI/CD: GitHub Actions
- Monitoring: CloudWatch (baseline), Grafana/Prometheus (stretch goal)

## Project Structure
Cloud-Project/
├── main.go              # Go REST API entry point
├── go.mod               # Go module definition
├── Dockerfile           # Container configuration
├── CLAUDE.md            # This file - project context for Claude
├── .github/
│   └── workflows/
│       └── deploy.yml   # GitHub Actions CI/CD pipeline
├── terraform/
│   ├── main.tf          # Core infrastructure definition
│   ├── variables.tf     # Input variables
│   └── outputs.tf       # Output values
└── docs/
└── progress.md      # Running log of progress and learnings

## Decisions Made
- Using Go because of prior experience at American Express
- Single health check endpoint to start, will expand API over time
- Docker multi-stage build to keep image size small
- Terraform to provision all AWS infrastructure instead of manual console setup
- Infrastructure as code approach means environment is reproducible and documented

## Current Status
- [x] GitHub repo created with SSH authentication
- [x] Go REST API built with /health endpoint
- [x] Dockerfile created (in progress - not yet verified running)
- [x] Docker image built and verified running locally
- [x] GitHub Actions CI/CD pipeline
- [X] Terraform AWS infrastructure provisioned
- [X] Application deployed to AWS
- [x] CD pipeline wired up to auto-deploy on push
- [ ] Monitoring configured

## How To Use This File
Paste the contents of this file at the start of any new Claude conversation
to restore full project context instantly.