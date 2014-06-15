#!/bin/sh
if [ -f /app/.profile.d/app-env.sh ]; then
	test -d /home/git/.ssh || mkdir -p /home/git/.ssh
	sed "s/export //" /app/.profile.d/app-env.sh > /home/git/.ssh/environment
	. /home/git/.ssh/environment
	echo $REDIS_URL > /home/git/.ssh/REDIS_URL
fi