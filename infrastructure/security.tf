# Security Groups
resource "aws_security_group" "jenkins_sg" {
  vpc_id = "${aws_vpc.vpc.id}"

  # ALLOW SSH ACCESS FROM MY IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["197.176.137.116/32"]
  }

  # ALLOW HTTP ACCESS TO BUILD SERVER FROM MY IP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["197.176.137.116/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name      = "Jenkins Security Group"
    Terraform = "true"
  }
}

resource "aws_security_group" "elb" {
    vpc_id = "${aws_vpc.vpc.id}"

    # ALLOW WEB ACCESS FROM EVERYWHERE
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "ELB Security Group"
        Terraform = "true"
    }
}

resource "aws_security_group" "server" {
    vpc_id = "${aws_vpc.vpc.id}"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = ["${aws_security_group.elb.id}"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "Instance Security Group"
        Terraform = "true"
    }
}
