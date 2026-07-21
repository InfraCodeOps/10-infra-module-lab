
# Fill in the data block below:
# Code for looking up the latest x86_64 Amazon Linux 2023 AMI
# in the current region.
data "aws_ami" "amazon-linux-2023" {
# ...
}

# leave the rest of this file as it is


# The instances represent the web app servers
resource "aws_instance" "webapp_instances" {
  ami           = data.aws_ami.amazon-linux-2023.id
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
    TOKEN=$(curl -sS -X PUT -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" http://169.254.169.254/latest/api/token)
    INSTANCE_ID=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
    REGION=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/region)
    AVAILABILITY_ZONE=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)

    cat <<END_OF_FILE > index.html
    <html>
    <head>
      <title>AWS Diagnostic Details</title>
    </head>
    <body>
      <h1>Diagnostics for ${var.app-name}</h1>
      <h2>Hello World ${count.index}</h2>
      <h3>Instance ID: $INSTANCE_ID</h3>
      <p>Region: $REGION</p>
      <p>Availability Zone: $AVAILABILITY_ZONE</p>
    </body>
    </html>
    END_OF_FILE
    python3 -m http.server 8080 &
    EOF
}
