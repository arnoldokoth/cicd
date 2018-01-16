output "jenkins_public_dns" {
  value = "${aws_instance.jenkins.public_dns}"
}

output "staging_elb_dns" {
    value = "${aws_elb.staging.dns_name}"
}

output "production_elb_dns" {
    value = "${aws_elb.prod.dns_name}"
}
