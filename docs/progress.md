# Project Progress Log

## What We're Building
A Go REST API containerized with Docker, deployed to AWS using Terraform for
infrastructure provisioning, with a CI/CD pipeline via GitHub Actions and
monitoring via CloudWatch. Full DevOps lifecycle, end to end. PROJECT COMPLETE
as of Session 5 — now in job application phase.

## Full Project Sequence (all complete)
1. Go REST API — done
2. Docker containerization — done
3. GitHub Actions CI/CD pipeline — done
4. Terraform AWS infrastructure — done
5. Deploy containerized app to AWS via pipeline — done
6. Monitoring with CloudWatch — done
7. README for portfolio presentation — done

---

## Session 1
Built GitHub repo with SSH auth, Go REST API with /health endpoint, Dockerfile
with multi-stage build, CLAUDE.md and docs/progress.md.

Learned: net/http basics, HTTP handler signatures, Content-Type headers,
Dockerfile multi-stage build pattern, why Terraform beats manual console setup.

## Session 2
Built GitHub Actions CI pipeline (build + docker jobs), triggers on push to main.

Learned: CI vs CD distinction, GitHub Actions job isolation (each job is a fresh
VM, no shared state, each needs its own checkout step), actions/checkout@v4,
action versioning with @ syntax, go build -o flag meaning.

## Session 3
Built Terraform config (main.tf, variables.tf, outputs.tf). Provisioned VPC,
subnets, IGW, route tables, security groups, ALB, ECR, ECS cluster/task/service,
IAM roles, CloudWatch log group. Pushed Docker image to ECR. App deployed and
live on ECS Fargate, confirmed JSON response from live endpoint.

Learned: Terraform plan/apply workflow, core AWS networking concepts (VPC,
subnets, IGW, route tables, security groups), ALB port translation (80 public
→ 8080 container), ECR auth/tag/push process, ECS Fargate as managed container
runtime.

## Session 4
Built full CD pipeline in GitHub Actions — auto build, test, push to ECR,
redeploy to ECS on every push to main. Added .gitignore after a near-miss
where terraform.tfstate and .terraform/ were about to be committed.

Learned: needs: keyword for job dependencies, if: github.ref to restrict
deploys to main only, commit SHA image tagging for traceability, GitHub
Secrets for credential handling, why tfstate/.terraform/ must never be
committed (live infra state, large binaries), bots actively scan GitHub for
exposed AWS credentials.

**Important debugging note:** .gitignore initially failed to exclude the
Terraform/ folder on Windows Git Bash despite correct-looking entries —
resolved using wildcard patterns (`**/.terraform/`, `*.tfstate` without
directory prefix) instead of path-prefixed patterns. If similar gitignore
issues recur, try wildcard-first patterns.

## Session 5
Added CloudWatch alarms for high 5xx errors and high CPU utilization via
Terraform, both using evaluation_periods = 2 to avoid false-positive triggers
from single spikes. Verified both alarms active in AWS console.

Learned: evaluation_periods/period/treat_missing_data semantics, alarm
dimensions scoping (LoadBalancer/TargetGroup vs ClusterName/ServiceName),
logs vs alarms as complementary observability (logs = what happened, alarms
= something's wrong now).

## Session 6
Wrote comprehensive README.md for the repo (architecture diagram, tech stack
table, what-this-demonstrates section, local dev instructions, CI/CD pipeline
explanation). Project is now portfolio-presentable.

Began resume repositioning: rewriting professional summary and adding a
dedicated Projects section to lead with Cloud-Project as primary credential,
ahead of work history. Built rehearsed interview talking points for the five
questions most likely to come up about this project (Fargate vs EC2, Terraform
vs console, commit SHA tagging, alarm evaluation periods, load balancer for a
single container).

### Next Steps
- Finish reviewing/finalizing the repositioned resume
- Resume targeted job applications (2-3/day, quality over volume) once resume
  is finalized
- Optional stretch: expand API beyond /health, add Grafana/Prometheus
