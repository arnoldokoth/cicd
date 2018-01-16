resource "aws_instance" "jenkins" {
  ami                    = "ami-cb9ec1b1"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.public.id}"
  vpc_security_group_ids = ["${aws_security_group.jenkins_sg.id}"]
  key_name               = "${var.key_name}"


  connection {
    user        = "ec2-user"
    private_key = "${file(var.private_key_path)}"
    agent       = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install docker -y",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user",
      "sudo docker run -d -p 80:8080 --name jenkins jenkinsci/blueocean",
    ]
  }

  tags {
    Name      = "Jenkins Build Server"
    Terraform = "true"
  }
}

# STAGING INSTANCES
resource "aws_instance" "staging1" {
    ami = "ami-cb9ec1b1"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.private1.id}"
    vpc_security_group_ids = ["${aws_security_group.server.id}"]
    key_name = "${var.key_name}"
    private_ip = "10.1.1.10"

    connection {
        user = "ec2-user"
        private_key = "${file(var.private_key_path)}"
        agent = false
    }

    provisioner "remote-exec" {
        inline = [
            "sudo yum update -y",
            "sudo yum install docker -y",
            "sudo service docker start",
            "sudo usermod -a -G docker ec2-user"
        ]
    }

    tags {
        Name = "Web Server 1"
        Environment = "Staging"
        Terraform = "true"
    }
}

resource "aws_instance" "staging2" {
    ami = "ami-cb9ec1b1"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.private2.id}"
    vpc_security_group_ids = ["${aws_security_group.server.id}"]
    key_name = "${var.key_name}"
    private_ip = "10.1.2.10"

    connection {
        user = "ec2-user"
        private_key = "${file(var.private_key_path)}"
        agent = false
    }

    provisioner "remote-exec" {
        inline = [
            "sudo yum update -y",
            "sudo yum install docker -y",
            "sudo service docker start",
            "sudo usermod -a -G docker ec2-user"
        ]
    }

    tags {
        Name = "Web Server 2"
        Environment = "Staging"
        Terraform = "true"
    }
}

# STAGING ELB
resource "aws_elb" "staging" {
    availability_zones = ["${data.aws_availability_zones.available.names[1]}", "${data.aws_availability_zones.available.names[2]}"]

    listener {
        instance_port = 5000
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }

    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 3
        target              = "HTTP:5000/"
        interval            = 30
    }

    instances = ["${aws_instance.staging1.id}", "${aws_instance.staging2.id}"]
    cross_zone_load_balancing = true
    idle_timeout = 400
    connection_draining = true
    connection_draining_timeout = 400


    tags {
        Name = "Staging ELB"
        Environment = "Staging"
        Terraform = true
    }
}

# PRODUCTION INSTANCES
resource "aws_instance" "prod1" {
    ami = "ami-cb9ec1b1"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.private1.id}"
    vpc_security_group_ids = ["${aws_security_group.server.id}"]
    key_name = "${var.key_name}"
    private_ip = "10.1.1.20"

    connection {
        user = "ec2-user"
        private_key = "${file(var.private_key_path)}"
        agent = false
    }

    provisioner "remote-exec" {
        inline = [
            "sudo yum update -y",
            "sudo yum install docker -y",
            "sudo service docker start",
            "sudo usermod -a -G docker ec2-user"
        ]
    }

    tags {
        Name = "Production Server 1"
        Environment = "Production"
        Terraform = "true"
    }
}

resource "aws_instance" "prod2" {
    ami = "ami-cb9ec1b1"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.private2.id}"
    vpc_security_group_ids = ["${aws_security_group.server.id}"]
    key_name = "${var.key_name}"
    private_ip = "10.1.2.20"

    connection {
        user = "ec2-user"
        private_key = "${file(var.private_key_path)}"
        agent = false
    }

    provisioner "remote-exec" {
        inline = [
            "sudo yum update -y",
            "sudo yum install docker -y",
            "sudo service docker start",
            "sudo usermod -a -G docker ec2-user"
        ]
    }

    tags {
        Name = "Production Server 2"
        Environment = "Production"
        Terraform = "true"
    }
}

# PRODUCTION ELB
resource "aws_elb" "prod" {
    availability_zones = ["${data.aws_availability_zones.available.names[1]}", "${data.aws_availability_zones.available.names[2]}"]

    listener {
        instance_port = 5000
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }

    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 3
        target              = "HTTP:5000/"
        interval            = 30
    }

    instances = ["${aws_instance.prod1.id}", "${aws_instance.prod2.id}"]
    cross_zone_load_balancing = true
    idle_timeout = 400
    connection_draining = true
    connection_draining_timeout = 400


    tags {
        Name = "Production ELB"
        Environment = "Production"
        Terraform = true
    }
}
