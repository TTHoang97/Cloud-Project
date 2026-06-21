# Cloud-Project - Claude Context File

## Project Goal
Build a complete end-to-end DevOps project to demonstrate real-world skills for
DevOps/Platform Engineering/SRE roles while utilizing AI tools. Priority is learning
by doing, not perfection. PROJECT IS FUNCTIONALLY COMPLETE — now in job application phase.

## Current Stack
- Language: Go
- Containerization: Docker
- Infrastructure as Code: Terraform
- Cloud: AWS (ECS Fargate, ECR, ALB, VPC, CloudWatch, IAM)
- CI/CD: GitHub Actions (CI + CD, full pipeline)
- Monitoring: CloudWatch logs + alarms (CPU, 5xx errors)

## Project Structure
```
Cloud-Project/
├── main.go              # Go REST API entry point
├── go.mod               # Go module definition
├── Dockerfile            # Multi-stage container build
├── CLAUDE.md             # This file - project context for Claude
├── .gitignore            # Excludes .terraform/, tfstate, AWS creds
├── README.md              # Public-facing project documentation
├── .github/
│   └── workflows/
│       └── deploy.yml    # Full CI/CD pipeline (build, test, deploy)
├── Terraform/
│   ├── main.tf            # All AWS infrastructure + CloudWatch alarms
│   ├── variables.tf       # Input variables
│   └── outputs.tf         # app_url output
└── docs/
    └── progress.md        # Running log of progress and learnings
```

## Decisions Made
- Go chosen due to prior AmEx experience
- Docker multi-stage build to keep image size minimal
- Terraform for all AWS infrastructure — no manual console provisioning
- ECS Fargate over EC2 — no server management overhead
- Commit SHA used as Docker image tag (not "latest") for deployment traceability
- ALB in front of single container — enables zero-downtime deploys, positions for scaling
- CloudWatch alarms use evaluation_periods = 2 to avoid false positives from single spikes

## Current Status — PROJECT COMPLETE
- [x] GitHub repo created with SSH authentication
- [x] Go REST API built with /health endpoint
- [x] Dockerfile created and verified running locally
- [x] Docker image built and verified running locally
- [x] GitHub Actions CI pipeline
- [x] Terraform AWS infrastructure provisioned
- [x] Docker image pushed to ECR
- [x] Application deployed to AWS via ECS Fargate
- [x] CD pipeline wired up — full automated deployment on push
- [x] Monitoring configured (CloudWatch logs + 2 alarms)
- [x] README written for portfolio presentation
- [ ] Resume repositioned around this project (in progress)
- [ ] Job applications resumed with updated resume

## Current Phase: Job Application
Project build phase is done. Focus is now on:
1. Finalizing repositioned resume (DevOps/Platform Engineering framing)
2. Practicing articulating project decisions for interviews (see talking points below)
3. Resuming targeted job applications (quality over volume — 2-3/day)

## Interview Talking Points (rehearsed, know these cold)
- Why ECS Fargate over EC2: serverless containers, no patching/server management,
  tradeoff is less control + slightly higher cost, worth it for this use case
- Why Terraform over console: version controlled, reproducible, documented infra
- Why commit SHA tags not "latest": traceability, easier rollback/debugging
- Why 2 evaluation periods on alarms: prevents false positives from traffic spikes
- Why load balancer for one container: zero-downtime deploys via health-check-based
  routing; positions architecture to scale horizontally with no code changes

## How To Use This File
Paste the contents of this file at the start of any new Claude conversation
to restore full project context instantly. Also mention you're a job seeker
transitioning from Production Support to DevOps/Platform/SRE roles, based in
Greenville SC, and that Claude should act as a brutally honest technical
advisor and accountability partner, not a softening assistant.
