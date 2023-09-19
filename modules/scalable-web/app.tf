
# Fill in the data block below:
# Code for looking up the latest Amazon Linux 2 AMI
# in the current region.
data "aws_ami" "amazon-linux-2" {
# ...
}

# leave the rest of this file as it is


# The instances represent the web app servers
resource "aws_instance" "webapp_instances" {
  ami           = data.aws_ami.amazon-linux-2.id 
  instance_type = var.instance_type
  count         = var.num-replicas
  subnet_id     = element(aws_subnet.app-subnets.*.id, count.index)

  # associate public IP address so instance can be reached from internet

  associate_public_ip_address = var.associate_public_ip

  # this associates the instance with the security group
  vpc_security_group_ids = [aws_security_group.instances.id]

  # this code executes when the instance is created
  # here we are create a placeholder index.html file
  # that shows basic diagnostic information about the instance
  # http://169.254.169.254 is a special IP address that AWS
  # recognizes and provides metadata about the instance
  user_data = <<-EOF
    #!/bin/bash
    cat <<END_OF_FILE > index.html
    <html>
    <head>
      <title>AWS Diagnostic Details</title>
    </head>
    <body>
      <h1>Diagnostics for ${var.app-name}</h1>
      <h2>Hello World ${count.index}</h2>
      <h3>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</h3>
      <p>Region: $(curl -s http://169.254.169.254/latest/meta-data/placement/region)</p>
      <p>Availability Zone: $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>
    </body>
    </html>
    END_OF_FILE
    python3 -m http.server 8080 &
    EOF
}