#!/bin/bash
set -e

DATAIKUDATA=/var/lib/dataiku
DATAIKUPROG=/home/dataiku
DATAIKULICENSE=/etc/dataiku/license.json

# Override ownership of DSS data directory
# Avoid issue if modifications have been made on host side
/bin/chown dataiku:dataiku ${DATAIKUDATA}

# Check Dataiku installation status
IS_DSS_CONFIGURED=0
if [ -f ${DATAIKUDATA}/bin/dss ]; then
    IS_DSS_CONFIGURED=1
fi
# Check license status
# API node requires a valid license to start
HAS_DSS_LICENSE=0
if [ -f ${DATAIKULICENSE} ]; then
    HAS_DSS_LICENSE=1
fi

# Define installer options to be run
# Depends on DSS being already installed or not
# Depends on custom license being provided or not
if [ ${IS_DSS_CONFIGURED} -eq 0 -a ${HAS_DSS_LICENSE} -eq 0 ];
then
    echo "* DSS is not installed"
    echo "* No custom license file found"
    echo "** Installing Dataiku as Automation Node with community license"
    DSSINSTALLOPT=""
elif [ ${IS_DSS_CONFIGURED} -eq 0 -a ${HAS_DSS_LICENSE} -eq 1 ];
then
    echo "* DSS is not installed"
    echo "* Custom license file found"
    echo "** Installing Dataiku as Automation Node with custom license"
    DSSINSTALLOPT="-l ${DATAIKULICENSE} -p 11000"
elif [ ${IS_DSS_CONFIGURED} -eq 1 ];
then
    echo "* DSS hass already been installed"
    echo "** Upgrading Dataiku Automation Node"
    DSSINSTALLOPT="-u -y"
else
    echo "*** Oooops… Shouldn't be there :-/"
    exit 1
fi
/bin/su - dataiku -c "cd ${DATAIKUPROG} && ./installer.sh -t automation -d ${DATAIKUDATA} ${DSSINSTALLOPT}"

# Once installed or upgraded, we can start DSS
if [ -f ${DATAIKUDATA}/bin/dss ]; then
  /bin/su - dataiku -c "${DATAIKUDATA}/bin/dss run"
else
  exit 1
fi
