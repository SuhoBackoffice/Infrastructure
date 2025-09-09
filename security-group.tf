resource "aws_security_group" "ec2_sg" {
  name        = "baekgwa_blog-ec2-sg"
  description = "Allow SSH, HTTP, HTTPS, App Ports"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH Access (22)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }

  ingress {
    description = "HTTP Access (80)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_cidr
  }

  ingress {
    description = "HTTPS Access (443)"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_cidr
  }

  ingress {
    description = "MySQL Access"
    from_port   = var.rdbms_port
    to_port     = var.rdbms_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_cidr
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "suho_application-ec2-sg"
  }
}
