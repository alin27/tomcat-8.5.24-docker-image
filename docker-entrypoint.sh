#!/bin/bash

#
# Default usage: docker-entrypoint.sh start-tomcat
#

# set -e

export CATALINA_HOME=/opt/tomcat
export PATH=/opt/tomcat:$PATH

#
# Start Tomcat server
#
echo "=> Starting Tomcat server"
exec gosu tomcat $CATALINA_HOME/bin/catalina.sh run
exec gosu tomcat "$@"
