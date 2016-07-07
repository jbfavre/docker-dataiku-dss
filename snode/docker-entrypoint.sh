#!/bin/bash
set -e

DATAIKUDATA=/var/lib/dataiku
DATAIKUPROG=/home/dataiku
DATAIKULICENSE=/etc/dataiku/license.json
DATAIKUAPISERVICE=/var/cache/dataiku

IS_DSS_CONFIGURED=0
HAS_DSS_LICENSE=0

# Override ownership of DSS data directory
# Avoid issue if modifications have been made on host side
/bin/chown -R dataiku:dataiku ${DATAIKUDATA}

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
    echo "** Installing Dataiku as API Node with community license"
    DSSINSTALLOPT="-p 12000"
elif [ ${IS_DSS_CONFIGURED} -eq 0 -a ${HAS_DSS_LICENSE} -eq 1 ];
then
    echo "* DSS is not installed"
    echo "* Custom license file found"
    echo "** Installing Dataiku as API Node with custom license"
    DSSINSTALLOPT="-l ${DATAIKULICENSE} -p 12000"
elif [ ${IS_DSS_CONFIGURED} -eq 1 ];
then
    echo "* DSS hass already been installed"
    echo "** Upgrading Dataiku API Node"
    DSSINSTALLOPT="-u -y"
else
    echo "*** Oooops… Shouldn't be there :-/"
    exit 1
fi
/bin/su - dataiku -c "cd ${DATAIKUPROG} && ./installer.sh -t api -d ${DATAIKUDATA} ${DSSINSTALLOPT}"

# We need to start DSS to be able to install bundles
if [ -f ${DATAIKUDATA}/bin/dss ]; then
  /bin/su - dataiku -c "${DATAIKUDATA}/bin/dss start"
else
  exit 1
fi

# Install API service
# Bundle must be named like: <service>_v<version>_<endpoint>
for BUNDLE in $(ls -1 ${DATAIKUAPISERVICE}/*.zip)
do
    bundle_filename=${BUNDLE#${DATAIKUAPISERVICE}/}
    bundle_name=${bundle_filename%.zip}
    service_name=${bundle_name%%_v*_*}
    service_version=${bundle_name#${service_name}_v}
    service_version=${service_version%_*}

    # Check if service exists
    # Create service if it doesn't exist
    service_nb=$(/bin/su - dataiku -c "/var/lib/dataiku/bin/apinode-admin services-list" | grep ${service_name} | wc -l)
    if [ ${service_nb} -gt 0 ]
    then
        echo "* Service ${service_name} found, nothing to do"
    else
        echo "* Service ${service_name} not found, creating"
        /bin/su - dataiku -c "cd ${DATAIKUDATA} && ./bin/apinode-admin service-create ${service_name}"
    fi
    # Install Bundle if not already installed
    service_gen_name=${bundle_name#${service_name}_}
    if [ -d ${DATAIKUDATA}/services/${service_name}/gens/${service_gen_name} ]
    then
        echo "** Bundle ${service_gen_name} found, nothing to do"
    else
        echo "** Bundle ${service_gen_name} not found, importing"
        /bin/su - dataiku -c "cd ${DATAIKUDATA} && ./bin/apinode-admin service-import-generation ${service_name} ${BUNDLE}"
    fi
    # Switch on most recent one
    /bin/su - dataiku -c "cd ${DATAIKUDATA} && ./bin/apinode-admin service-switch-to-newest ${service_name}"
done

# We need to stop DSS once bundles are installed
if [ -f ${DATAIKUDATA}/bin/dss ]; then
  /bin/su - dataiku -c "${DATAIKUDATA}/bin/dss stop"
else
  exit 1
fi

# Once installed or upgraded, we can start DSS
if [ -f ${DATAIKUDATA}/bin/dss ]; then
  /bin/su - dataiku -c "${DATAIKUDATA}/bin/dss run"
else
  exit 1
fi
