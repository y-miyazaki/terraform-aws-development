#!/bin/bash
set -e
TIMEZONE=${1:-Asia/Tokyo}

#--------------------------------------------------------------
# Install the Scheduler CLI
#--------------------------------------------------------------
# pattern1:
# Mon 9:00 to 23:59
# Tue 0:00 to 23:59
# Wed 0:00 to 23:59
# Thu 0:00 to 23:59
# Fri 9:00 to 21:00
scheduler-cli create-period --name "mon-start-9am" --begintime 09:00 --endtime 23:59 --weekdays mon --stack base-instance-scheduler
scheduler-cli create-period --name "tue-thu-full-day" --weekdays tue-thu --stack base-instance-scheduler
scheduler-cli create-period --name "fri-stop-9pm" --begintime 00:00 --endtime 22:00 --weekdays fri --stack base-instance-scheduler
scheduler-cli create-schedule --name "mon-9am-fri-9pm" --periods mon-start-9am,tue-thu-full-day,fri-stop-9pm --timezone ${TIMEZONE} --stack base-instance-scheduler

# pattern2: 
# Mon 9:00 to 21:00
# Tue 9:00 to 21:00
# Wed 9:00 to 21:00
# Thu 9:00 to 21:00
# Fri 9:00 to 21:00
scheduler-cli create-period --name "mon-fri-9am-9pm" --begintime 09:00 --endtime 21:00 --weekdays mon-fri --stack base-instance-scheduler
scheduler-cli create-schedule --name "mon-fri-9am-9pm" --periods mon-fri-9am-9pm --timezone ${TIMEZONE} --stack base-instance-scheduler
