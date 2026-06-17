terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = var.aws_region
}

# ECR Repository to store Docker images
resource "aws_ecr_repository" "app" {
    name = var.app_name
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {
        scan_on_push = true
    }
}

# VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "${var.app_name}-vpc"
    }
}

# Public Subnets
resource "aws_subnet" "public_a" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "${var.aws_region}a"
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.app_name}-public-a"
    }
}

resource "aws_subnet" "public_b" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "${var.aws_region}b"
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.app_name}-public-b"
    }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "${var.app_name}-igw"
    }
}

# Route Table
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }

    tags = {
        Name = "${var.app_name}-public-rt"
    }
}

# Route Table Associations
resource "aws_route_table_association" "public_a" {
    subnet_id = aws_subnet.public_a.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
    subnet_id = aws_subnet.public_b.id
    route_table_id = aws_route_table.public.id
}

# Security Group for Load Balancer
resource "aws_security_group" "alb" {
    name = "${var.app_name}-alb-sg"
    description = "Security group for load balancer"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.app_name}-alb-sg"
    }
}

# Security Group for ECS Tasks
resource "aws_security_group" "ecs" {
    name = "${var.app_name}-ecs-sg"
    description = "Security group for ECS tasks"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port = var.container_port
        to_port = var.container_port
        protocol = "tcp"
        security_groups = [aws_security_group.alb.id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.app_name}-ecs-sg"
    }
}

# Application Load Balancer
resource "aws_lb" "app_lb" {
    name = "${var.app_name}-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb.id]
    subnets = [aws_subnet.public_a.id, aws_subnet.public_b.id]

    tags = {
        Name = "${var.app_name}-alb"
    }
}

# Target Group
resource "aws_lb_target_group" "app" {
    name = "${var.app_name}-tg"
    port = var.container_port
    protocol = "HTTP"
    vpc_id = aws_vpc.main.id
    target_type = "ip"
    
    health_check {
        path = "/health"
        interval = 30
        healthy_threshold = 2
        unhealthy_threshold = 2
    }

    tags = {
        Name = "${var.app_name}-tg"
    }
}

# Load Balancer Listener
resource "aws_lb_listener" "app" {
    load_balancer_arn = aws_lb.app_lb.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.app.arn
    }
}

# ECS Cluster
resource "aws_ecs_cluster" "main" {
    name = "${var.app_name}-cluster"

    tags = {
        Name = "${var.app_name}-cluster"
    }
}

# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_execution" {
    name = "${var.app_name}-ecs-task-execution-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = "ecs-tasks.amazonaws.com"
                }
                Action = "sts:AssumeRole"
            }
        ]
    })

    tags = {
        Name = "${var.app_name}-ecs-task-execution-role"
    }
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
    role = aws_iam_role.ecs_execution.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "app" {
    family = var.app_name
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu = "256"
    memory = "512"
    execution_role_arn = aws_iam_role.ecs_execution.arn

    container_definitions = jsonencode([
        {
            name = var.app_name
            image = "${aws_ecr_repository.app.repository_url}:latest"
            portMappings = [
                {
                    containerPort = var.container_port
                    protocol = "tcp"
                }
            ]
            logConfiguration = {
                logDriver = "awslogs"
                options = {
                    "awslogs-group" = "/ecs/${var.app_name}"
                    "awslogs-region" = var.aws_region
                    "awslogs-stream-prefix" = "ecs"
                }
            }
        }
    ])
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "app" {
    name = "/ecs/${var.app_name}"
    retention_in_days = 7

    tags = {
        Name = "${var.app_name}-log-group"
    }
}

# ECS Service
resource "aws_ecs_service" "app" {
    name = "${var.app_name}-service"
    cluster = aws_ecs_cluster.main.id
    task_definition = aws_ecs_task_definition.app.arn
    desired_count = 1
    launch_type = "FARGATE"

    network_configuration {
        subnets = [aws_subnet.public_a.id, aws_subnet.public_b.id]
        security_groups = [aws_security_group.ecs.id]
        assign_public_ip = true
    }

    load_balancer {
        target_group_arn = aws_lb_target_group.app.arn
        container_name = var.app_name
        container_port = var.container_port
    }

    depends_on = [aws_lb_listener.app]

    tags = {
        Name = "${var.app_name}-service"
    }
}

# CloudWatch Alarm for high HTTP 5xx errors
resource "aws_cloudwatch_metric_alarm" "http_5xx" {
    alarm_name = "${var.app_name}-http-5xx-alarm"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = 2
    metric_name = "HTTPCode_Target_5XX_Count"
    namespace = "AWS/ApplicationELB"
    period = 60
    statistic = "Sum"
    threshold = 10
    alarm_description = "Triggers when 5xx errors exceed 10 for 2 consecutive minutes"
    treat_missing_data = "notBreaching"

    dimensions = {
        LoadBalancer = aws_lb.app_lb.arn_suffix
        TargetGroup = aws_lb_target_group.app.arn_suffix
    }
}

# CloudWatch Alarm for ECS CPU Utilization
resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
    alarm_name = "${var.app_name}-cpu-utilization-alarm"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = 2
    metric_name = "CPUUtilization"
    namespace = "AWS/ECS"
    period = 60
    statistic = "Average"
    threshold = 80
    alarm_description = "Triggers when CPU utilization exceeds 80% for 2 consecutive minutes"
    treat_missing_data = "notBreaching"

    dimensions = {
        ClusterName = aws_ecs_cluster.main.name
        ServiceName = aws_ecs_service.app.name
    }
}