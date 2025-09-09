output "ec2_public_ip" {
  description = "EC2 고정 퍼블릭 IP (EIP 조회)"
  value       = data.aws_eip.static.public_ip
}

output "ssh_keygen_reset_command" {
  description = "SSH Known Hosts 초기화 명령어"
  value       = "ssh-keygen -R ${data.aws_eip.static.public_ip}"
}

output "ssh_connect_command" {
  description = "SSH 접속 명령어"
  value       = "ssh -i ./${var.key_name} ubuntu@${data.aws_eip.static.public_ip}"
}
