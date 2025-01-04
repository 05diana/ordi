
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  create                      = true
  name                        = "${var.environment}-${var.project}-bastion-host"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  subnet_id                   = var.public_subnet_ids[0]
  associate_public_ip_address = true

  user_data = <<EOF
#!/bin/bash
yum install -y nc tmux
amazon-linux-extras install -y postgresql14
mkdir -p /home/ec2-user/.ssh
cat <<EOK>> /home/ec2-user/.ssh/authorized_keys
${join("\n", var.ssh_keys)}
EOK
chown -R ec2-user:ec2-user /home/ec2-user/.ssh
chmod 500 /home/ec2-user/.ssh
chmod 400 /home/ec2-user/.ssh/authorized_keys
  EOF

  tags = {
    Terraform   = "true"
    Projectname = var.project
    Environment = var.environment
    Name        = "${var.environment}-bastion-hosts"
  }
}
