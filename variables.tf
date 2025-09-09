variable "instance_type" {
  description = "EC2 인스턴스 타입"
  type        = string
}

variable "key_name" {
  description = "AWS 키페어 이름 (AWS 상의 이름이며, 파일명이 아님)"
  type        = string
}

variable "key_public_file" {
  description = "SSH 공개키 파일 경로 (예: suho-application-key.pem.pub)"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "SSH 허용할 IP 대역"
  type        = list(string)
}

variable "allowed_http_cidr" {
  description = "8080 포트 허용할 IP 대역"
  type        = list(string)
}

variable "ami_id" {
  description = "EC2 인스턴스에 사용할 AMI ID (리전 종속)"
  type        = string
}

variable "allocation_id" {
  description = "수동 발급 Elastic IP의 Allocation ID (eipalloc-...)"
  type        = string
}

variable "root_volume_size" {
  description = "루트 볼륨 사이즈 (GiB)"
  type        = number
}

variable "root_volume_type" {
  description = "루트 볼륨 타입 (gp3 등)"
  type        = string
}

variable "rdbms_root_password" {
  description = "DB root 비밀번호"
  type        = string
  sensitive   = true
}

variable "rdbms_username" {
  description = "애플리케이션 DB 사용자 이름"
  type        = string
}

variable "rdbms_password" {
  description = "애플리케이션 DB 사용자 비밀번호"
  type        = string
  sensitive   = true
}

variable "rdbms_port" {
  description = "DB 포트"
  type        = number
}

variable "mysql_query_log_path" {
  description = "MySQL 슬로우/쿼리 로그 경로"
  type        = string
}

data "aws_eip" "static" {
  id = var.allocation_id
}
