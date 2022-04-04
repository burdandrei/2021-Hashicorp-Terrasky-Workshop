data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    organization = var.tfc_organization_name
    workspaces = {
      name = "VPC"
    }
  }
}

resource "aws_db_subnet_group" "demo" {
  name       = "demo"
  subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnets

  tags = {
    Name = "Demo"
  }
}


resource "aws_security_group" "rds" {
  name   = "demo_rds"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "demo_rds"
  }
}

resource "aws_db_parameter_group" "demo" {
  name   = "demo"
  family = "postgres13"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "demo" {
  identifier             = "demo"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "13.1"
  username               = "edu"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.demo.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.demo.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}

