output "app_endpoint_url_index" {
  value = aws_lb.quest_alb.dns_name
}

output "app_endpoint_url_docker" {
  value = "${aws_lb.quest_alb.dns_name}/docker"
}

output "app_endpoint_url_aws" {
  value = "${aws_lb.quest_alb.dns_name}/aws"
}

output "app_endpoint_url_secret" {
  value = "${aws_lb.quest_alb.dns_name}/secret_word"
}

output "app_endpoint_url_loadbalanced" {
  value = "${aws_lb.quest_alb.dns_name}/loadbalanced"
}

## TODO
output "app_endpoint_url_tls" {
  value = "${aws_lb.quest_alb.dns_name}/tls"
}
