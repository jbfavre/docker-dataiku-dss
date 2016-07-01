#!/bin/bash
set -e

DATAIKUDATA=/var/lib/dataiku
DATAIKUPROG=/home/dataiku

# Dataiku Science Studio should be shut down properly
function shut_down() {
  echo "Shutting Down Dataiku Automation node"
  /bin/su - dataiku -c "${DATAIKUDATA}/bin/dss stop"
  exit
}

trap "shut_down" SIGKILL SIGTERM SIGHUP SIGINT EXIT

/bin/chown dataiku:dataiku ${DATAIKUDATA}

if [ -f ${DATAIKUDATA}/bin/dss ]; then
  echo "Upgrading Dataiku Automation node"
  /bin/su - dataiku -c "cd ${DATAIKUPROG} && ./installer.sh -t automation -d ${DATAIKUDATA} -u -y"
else
  echo "Installing Dataiku Automation node"
  /bin/su - dataiku -c "cd ${DATAIKUPROG} && ./installer.sh -t automation -d ${DATAIKUDATA} -p 11000"
fi

if [ -f ${DATAIKUDATA}/bin/dss ]; then
  /bin/su - dataiku -c "${DATAIKUDATA}/bin/dss run"
else
  exit 1
fi
