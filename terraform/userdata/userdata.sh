#!/bin/bash
#--------------------------------------------------------------
# Variables
# https://k3d.io/v5.4.1/#releases
#--------------------------------------------------------------
K3D_VERSION=v5.4.1

#--------------------------------------------------------------
# Install docker
#--------------------------------------------------------------
yum -y update
yum -y install docker
systemctl start docker.service
systemctl enable docker.service

usermod -a -G docker ec2-user

cat <<EOF >/etc/docker/daemon.json
{"host":["tcp://0.0.0.0:2375","unix:///var/run/docker.sock"]}
EOF

mkdir -p /etc/systemd/system/docker.service.d
cat <<EOF >/etc/systemd/system/docker.service.d/override.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd
EOF
systemctl daemon-reload
systemctl restart docker.service

#--------------------------------------------------------------
# Install Git
#--------------------------------------------------------------
yum -y install git

#--------------------------------------------------------------
# k3d
# https://github.com/k3d-io/k3d
#--------------------------------------------------------------
if [ -z "$(command -v k3d)" ]; then
    curl https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=${K3D_VERSION} bash
    k3d completion bash > /usr/local/etc/bash_completion.d/k3d
fi
