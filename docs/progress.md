# Project Progress Log

## What We're Building
A Go REST API containerized with Docker, deployed to AWS, with a CI/CD pipeline
via GitHub Actions and basic monitoring. The goal is demonstrating a full DevOps
lifecycle end to end.

---

## Session 1

### What Was Built
- Created GitHub repo (Cloud-Project) with SSH authentication configured
- Built a Go REST API with a single /health endpoint using Go's standard library
- Created a Dockerfile using a multi-stage build

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

### Current Blockers
- None

### Next Steps
- Verify Docker image builds and runs locally
- Push Dockerfile to GitHub
- Set up GitHub Actions CI/CD pipeline