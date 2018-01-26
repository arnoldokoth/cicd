resource "aws_instance" "jenkins" {
  ami                    = "ami-97785bed"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.public1.id}"
  vpc_security_group_ids = ["${aws_security_group.jenkins_sg.id}"]
  key_name               = "${var.key_name}"
  iam_instance_profile   = "aws_ec2_ec2_role"

  connection {
    user        = "ec2-user"
    private_key = "${file(var.private_key_path)}"
    agent       = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install docker -y",
      "sudo yum remove java-1.7.0-openjdk -y",
      "sudo yum install java-1.8.0 -y",
      "sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo",
      "sudo rpm --import http://pkg.jenkins-ci.org/redhat-stable/jenkins-ci.org.key",
      "sudo yum install jenkins -y",
      "sudo yum install git -y",
      "sudo pip install ansible",
      "sudo service jenkins start",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user",
      "sudo usermod -a -G docker jenkins",
    ]
  }

  tags {
    Name      = "Jenkins Build Server"
    Terraform = "true"
  }
}

# STAGING INSTANCES
resource "aws_instance" "staging1" {
  ami                    = "ami-cb9ec1b1"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.public1.id}"
  vpc_security_group_ids = ["${aws_security_group.server.id}"]
  key_name               = "${var.key_name}"
  private_ip             = "10.1.0.10"
  iam_instance_profile   = "aws_ec2_ec2_role"

  tags {
    Name        = "Staging Server 1"
    Environment = "Staging"
    Terraform   = "true"
  }
}

# PRODUCTION INSTANCES
resource "aws_instance" "prod1" {
  ami                    = "ami-cb9ec1b1"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.public2.id}"
  vpc_security_group_ids = ["${aws_security_group.server.id}"]
  key_name               = "${var.key_name}"
  private_ip             = "10.1.1.10"
  iam_instance_profile   = "aws_ec2_ec2_role"

  tags {
    Name        = "Production Server 1"
    Environment = "Production"
    Terraform   = "true"
  }
}
