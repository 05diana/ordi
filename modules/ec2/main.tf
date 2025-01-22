
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  create                      = true
  name                        = "${terraform.workspace}-bastion"
  instance_type               = "t2.nano"
  associate_public_ip_address = true
  subnet_id                   = var.public_subnet_ids[0]
  vpc_security_group_ids = [
    var.ssh_sg_id,
    var.postgresql_sg_id,
  ]

  user_data = <<EOF
#!/bin/bash
yum install -y nc tmux
amazon-linux-extras install -y postgresql14 ansible2
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
    Environment = terraform.workspace
  }
}
