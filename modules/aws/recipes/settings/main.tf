
#--------------------------------------------------------------
# Output
#--------------------------------------------------------------
resource "null_resource" "this" {
  for_each = var.users
  triggers = {
    key_name            = each.value.key_name
    private_key_openssh = each.value.private_key_openssh
    instance_id         = each.value.instance_id
  }
  provisioner "local-exec" {
    command = "rm -rf ../outputs/${self.triggers.key_name}"
    when    = destroy
  }
  provisioner "local-exec" {
    command = <<EOA
    mkdir -p ../outputs/${self.triggers.key_name}
    cat <<EOF > ../outputs/${self.triggers.key_name}/config
Host ${self.triggers.key_name}
  HostName ${self.triggers.instance_id}
  User ec2-user
  Port 22
  StrictHostKeyChecking no
  TCPKeepAlive yes
  IdentityFile ~/.ssh/id_rsa_${self.triggers.key_name}
  IdentitiesOnly yes
  ServerAliveInterval 60
  ServerAliveCountMax 3
  ProxyCommand aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters portNumber=%p
EOF
    cat <<EOF > ../outputs/${self.triggers.key_name}/id_rsa_${self.triggers.key_name}
${nonsensitive(self.triggers.private_key_openssh)}
EOF
    cat <<EOF > ../outputs/${self.triggers.key_name}/readme.txt
### Install AWS CLI

_Skip this section if you already have AWS CLI installed on your local PC._

Install the AWS CLI on your local PC from the link below.  
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

### Install AWS Systems Manager Plugin

_Skip this section if you already have AWS Systems Manager Plugin installed on your local PC._

Install the AWS Systems Manager Plugin on your local PC from the link below.  
https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html

### Set SSH Configuration
Run the commands as described to set up SSH and configure the Docker context.

1. add the contents of "config" to "~/.ssh/config".

2. copy "~/.ssh/id_rsa_{username}" to "~/.ssh/".

3. execute the command to configure to the Docker context as follows.
   This command will set up a connection to the Docker environment in the remote environment.
   If you want to revert to the original context, run "docker context use {your context}".

   docker context create ${self.triggers.key_name} --docker "host=ssh://ec2_user@${self.triggers.key_name}"
   docker context use ${self.triggers.key_name}
   docker context list

4. use Visual Studio Code Remote Container to make the connection.
EOF
EOA
  }
}
