output "jenkins_public_dns" {
  value = "${aws_instance.jenkins.public_dns}"
}

output "staging_public_dns" {
  value = "${aws_instance.staging1.public_dns}"
}

output "prod_public_dns" {
  value = "${aws_instance.prod1.public_dns}"
}
