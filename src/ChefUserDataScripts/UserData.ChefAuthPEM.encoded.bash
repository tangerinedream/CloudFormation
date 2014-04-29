"#!/bin/bash\n",
"export LOG_FILE=\"/tmp/cloud-init_log.txt\"\n",
"echo [`date +%F`][`date +%T`] Cloud-init script initiated >>\"${LOG_FILE}\"\n",
"###\n",
"#\n",
"#  This script takes the necessary steps to enable a linux AMI (e.g. Ubuntu) for Chef to be installed later via Knife.  It has the following responsibilities:\n",
"# 1. general update of system\n",
"# 2. User 'opscode' creation\n",
"# 3. Instead of SSH Password based Authentication, use the AWS PEM \"key file\" file for authentication\n",
"# 4. Enable sudo privileges for 'opscode' user.\n",
"#\n",
"#  The associated knife command usage would be similar to:\n",
"#      knife bootstrap $NODE_IP --sudo -x <ssh-user-id> -i <path to (AWS).pem file> -N \"<your node name>\"\"\n",
"#      when prompted, enter sudo passcode for <ssh-user-id>\n",
"###\n",
"\n",
"###\n",
"# Log commands executed to /var/log/\n",
"set -x\n",
"###\n",
"\n",
"### \n",
"# Bring system up to date\n",
"apt-get -y update\n",
"# apt-get -y upgrade\n",
"echo [`date +%F`][`date +%T`] apt-get complete >>\"${LOG_FILE}\"\n",
"### \n",
"\n",
"###\n",
"# Create opscode user and set password\n",
"export TARGET_UID=\"opscode\"\n",
"useradd -m -s /bin/bash -p '$6$Ka3r1lxR$75GM7Cc2g86KafLQC3T4Tbb.YxAHXcgbpL9BDs.nETQSiabnrsGeKfk6DCuzQAGcm0YpTJkQs44moHJM..AqB/' \"${TARGET_UID}\"\n",
"echo [`date +%F`][`date +%T`] opscode user created >>\"${LOG_FILE}\"\n",
"###\n",
"\n",
"###\n",
"# In this version, you need not modify the sshd_config file.  However, you do need to know the location of where the AWS Key File is located, so you can copy it to opscode user\n",
"if [ -d \"/home/bitnami\" ]\n",
"then\n",
"  export SOURCE_UID=\"bitnami\"\n",
"else\n",
"  if [ -d \"/home/ec2user\" ] \n",
"  then\n",
"    export SOURCE_UID=\"ec2user\"\n",
"  else\n",
"    export SOURCE_UID=\"ubuntu\"\n",
"  fi\n",
"fi\n",
"export SOURCE_SSH_DIR=\"/home/${SOURCE_UID}/.ssh\"\n",
"export TARGET_SSH_DIR=\"/home/${TARGET_UID}/.ssh\"\n",
"mkdir -p \"${TARGET_SSH_DIR}\"\n",
"export AWS_SOURCE_KEY_FILE=\"${SOURCE_SSH_DIR}/authorized_keys\"\n",
"export AWS_TARGET_KEY_FILE=\"${TARGET_SSH_DIR}/authorized_keys\"\n",
"# TO DO: Consider changing cp to ln -s\n",
"cp \"${AWS_SOURCE_KEY_FILE}\" \"${AWS_TARGET_KEY_FILE}\" \n",
"chown -R \"${TARGET_UID}\" \"${TARGET_SSH_DIR}\"\n",
"chgrp -R \"${TARGET_UID}\" \"${TARGET_SSH_DIR}\"\n",
"echo [`date +%F`][`date +%T`] opscode pem keyfile in place >>\"${LOG_FILE}\"\n",
"###\n",
"\n",
"###\n",
"# Edit /etc/sudoers.  Allow opscode to execute sudo based commands \n",
"# Backup the original file first\n",
"export SUDOERS_FILE=\"/etc/sudoers\"\n",
"cp \"${SUDOERS_FILE}\" \"${SUDOERS_FILE}.orig\"\n",
"#\n",
"(\n",
"cat <<EOF\n",
"\n",
"opscode ALL=(ALL:ALL) ALL\n",
"EOF\n",
") >> \"${SUDOERS_FILE}\"\n",
"echo [`date +%F`][`date +%T`] opscode authorized in sudoers file >>\"${LOG_FILE}\"\n",
"###\n",
"echo [`date +%F`][`date +%T`] Cloud-init script completed >>\"${LOG_FILE}\"\n",
"###\n"