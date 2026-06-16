# Cloud-Project - Claude Context File

## Project Goal
Build a complete end-to-end DevOps project to demonstrate real-world skills for
DevOps/Platform Engineering/SRE roles while beginning to learn and utilize AI tools. Priority is learning by doing, not perfection.

## Current Stack
- Language: Go
- Containerization: Docker
- Cloud: AWS
- CI/CD: GitHub Actions (upcoming)
- Monitoring: TBD (Datadog or Grafana/Prometheus)

## Project Structure
Cloud-Project/
├── main.go          # Go REST API entry point
├── go.mod           # Go module definition
├── Dockerfile       # Container configuration
├── CLAUDE.md        # This file - project context for Claude
└── docs/
└── progress.md  # Running log of progress and learnings

## Decisions Made
- Using Go because of prior experience at American Express
- Single health check endpoint to start, will expand API over time
- Docker multi-stage build to keep image size small

## Current Status
- [x] GitHub repo created with SSH authentication
- [x] Go REST API built with /health endpoint
- [x] Dockerfile created (in progress - not yet verified running)
- [ ] Docker image built and running locally
- [ ] GitHub Actions CI/CD pipeline
- [ ] Deployed to AWS
- [ ] Monitoring configured

## How To Use This File
Paste the contents of this file at the start of any new Claude conversation
to restore full project context instantly.