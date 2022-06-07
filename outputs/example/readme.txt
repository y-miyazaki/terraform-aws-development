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

   docker context create {yourcontext} --docker "host=ssh://ec2_user@{host}"
   docker context use {yourcontext}
   docker context list

4. use Visual Studio Code Remote Container to make the connection.
