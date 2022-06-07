#!/bin/bash
set -e
#--------------------------------------------------------------
# Install the Scheduler CLI
#--------------------------------------------------------------
if [ -z "$(command -v python)" ] && [ -z "$(command -v python3)" ]; then
    echo "This command need to install \"python\"."
    exit 1
fi
curl -O https://s3.amazonaws.com/solutions-reference/aws-instance-scheduler/latest/scheduler-cli.zip
unzip -o scheduler-cli.zip -d scheduler-cli	
cd scheduler-cli
if [ -n "$(command -v python)" ]; then
    python setup.py install
elif [ -n "$(command -v python3)" ]; then
    python3 setup.py install
fi
cd ../
rm -rf scheduler-cli.zip
