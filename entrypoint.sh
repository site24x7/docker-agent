#!/bin/bash
#Author : Arunagiriswaran E
#Company : ZOHOCORP
SUCCESS=0
WARNING=1
FAILURE=2
BOOL_TRUE='True'
BOOL_FALSE='False'

ERROR_MSG=""
SEVERE_FLAG=$BOOL_FALSE
PRODUCT_NAME_UPPERCASE='SITE24X7'
PRODUCT_NAME_LOWERCASE='site24x7'


if [ -z $KEY ]; then
	SEVERE_FLAG=$BOOL_TRUE
	ERROR_MSG="KEY not set as env variable!!!"
fi

if [[ -z $EKS_FARGATE && -z $GKE_AUTOPILOT && -z $SERVERLESS ]]; then
        if [ ! -d /host/proc ]; then
                SEVERE_FLAG=$BOOL_TRUE
                ERROR_MSG="$ERROR_MSG /proc folder not mounted from host to /host/proc in container."
        fi
        if [ ! -d /host/sys ]; then
                SEVERE_FLAG=$BOOL_TRUE
                ERROR_MSG="$ERROR_MSG /sys folder not mounted from host to /host/sys in container."
        fi
fi

#if [ ! -S /var/run/docker.sock ]; then
#	SEVERE_FLAG=$BOOL_TRUE
#	ERROR_MSG="$ERROR_MSG /var/run/docker.sock file not mounted from host to /var/run/docker.sock in container."
#fi 

if [ "$SEVERE_FLAG" == "$BOOL_TRUE" ]; then
	printf "$ERROR_MSG Hence quitting!!! \n"
	exit $FAILURE
fi

#check_result=`/opt/site24x7/venv/bin/python singleinstance.py`
#if [ "$?" = "1" ]; then
#	printf "$check_result"
#	exit $FAILURE
#fi

variableUpdate(){
	PRODUCT_HOME=$INSTALL_DIR/$PRODUCT_NAME_LOWERCASE
	MON_AGENT_NAME=monagent
	PYTHON_VENV_HOME=$PRODUCT_HOME/venv
	PYTHON_VENV_HOME_ACTIVATE=$PYTHON_VENV_HOME/bin/activate
	PYTHON_VENV_BIN_PATH=$PYTHON_VENV_HOME/bin/python
	PYTHON_VENV_PIP_PATH=$PYTHON_VENV_HOME/bin/pip
	MON_AGENT_HOME=$PRODUCT_HOME/$MON_AGENT_NAME
	MON_AGENT_BIN_DIR=$MON_AGENT_HOME/bin
	MON_AGENT_LIB_DIR=$MON_AGENT_HOME/lib
	MON_AGENT_LOG_DIR=$MON_AGENT_HOME/logs
	MON_AGENT_PYPI_DIR=$MON_AGENT_HOME/pypi
	MON_AGENT_LOG_DETAIL_DIR=$MON_AGENT_LOG_DIR/details
	MON_AGENT_UNINSTALL_FILE=$MON_AGENT_BIN_DIR/uninstall
	MON_AGENT_BIN_BOOT_SERVICE_FILE=$MON_AGENT_BIN_DIR/monagentservice
	MON_AGENT_BIN_BOOT_FILE=$MON_AGENT_BIN_DIR/monagent
	MON_AGENT_WATCHDOG_BIN_BOOT_FILE=$MON_AGENT_BIN_DIR/monagentwatchdog
	MON_AGENT_BIN_PROFILE=$MON_AGENT_BIN_DIR/profile.sh
	MON_AGENT_BIN_PROFILE_ENV=$MON_AGENT_BIN_DIR/profile.env.sh
	MON_AGENT_PROFILE=$MON_AGENT_HOME/.profile
	MON_AGENT_PROFILE_ENV=$MON_AGENT_HOME/.profile.env
	MON_AGENT_CONF_DIR=$MON_AGENT_HOME/conf
	MON_AGENT_CONF_FILE=$MON_AGENT_CONF_DIR/monagent.cfg
	MON_AGENT_ERR_FILE=$MON_AGENT_LOG_DETAIL_DIR/monagent_err
	MON_AGENT_WATCHDOG_ERR_FILE=$MON_AGENT_LOG_DETAIL_DIR/monagent_watchdog_err
	BINARY_TAR_FILE=site24x7agent.tar.gz
	MON_AGENT_INSTALL_LOG=$PRODUCT_HOME/site24x7install.log
	MON_AGENT_CONTACT_SUPPORT_MESSAGE="Please contact support with $MON_AGENT_INSTALL_LOG , $MON_AGENT_LOG_DIR  and $MON_AGENT_LOG_DETAIL_DIR folder."
	PRESENT_INIT_DAEMON_NAME=""
	#user varaibles
	MON_AGENT_GROUP=$PRODUCT_NAME_LOWERCASE'-group'
	MON_AGENT_USER=$PRODUCT_NAME_LOWERCASE'-agent'
	MON_AGENT_SUPERVISOR_CONF_FILE=$MON_AGENT_CONF_DIR/supervisor.conf
	SUPERVISOR_CONFD_DIR=/etc/supervisor/conf.d
	SUPERVISOR_CONFD_FILE=$SUPERVISOR_CONFD_DIR/site24x7-agent.conf
        ALPINE_SUPERVISOR_CONFD_FILE=/etc/supervisor.d/site24x7-agent.ini
}

log(){
		echo $(date +"%F %T.%N") "    $1" >> $MON_AGENT_INSTALL_LOG 2>&1
}

findAndReplace() {
	log "FIND AND REPLACE : String : $1 File : $2"
	sed -i "$1" "$2" 
}

python_function(){
VALUE=`/opt/site24x7/venv/bin/python <<END
import os
env_dict = os.environ
key = "$1"
key_lower = key.lower()
key_upper = key.upper()
result = "0"
if key in env_dict:
	result = env_dict[key]
elif key_lower in env_dict:
	result = env_dict[key_lower]
elif key_upper in env_dict:
	result = env_dict[key_upper]
if not result.strip():
	result = "0"
print(result)
END`
echo $VALUE

}

domain_decider(){
VALUE=`/opt/site24x7/venv/bin/python <<END
import os
domain_map_dict = {
    "us": "https://staticdownloads.site24x7.com",
    "eu": "https://staticdownloads.site24x7.eu",
    "cn": "https://staticdownloads.site24x7.cn",
    "au": "https://staticdownloads.site24x7.net.au",
    "in": "https://staticdownloads.site24x7.in",
    "gd": "https://staticdownloads.site24x7.com",
    "jp": "https://staticdownloads.site24x7.jp",
    "in_hd": "https://staticdownloads.site24x7.in"
}
domain = "https://staticdownloads.site24x7.com"
if "KEY" in os.environ:
        device_key = os.environ["KEY"]
        prefix = '_'.join(device_key.split('_')[:-1])
        if prefix in domain_map_dict.keys():
                domain = domain_map_dict[prefix]
print(domain)
END`
echo $VALUE
}


getEnvValues(){
	GN_VALUE=`python_function gn`
	CT_VALUE=`python_function ct`
	TP_VALUE=`python_function tp`
	NP_VALUE=`python_function np`
	RP_VALUE=`python_function rp`
	INSTALLER_VALUE=`python_function installer`
	PROXY_VALUE=`python_function proxy`
	DN_VALUE=`python_function dn`
	KEY_VALUE=`python_function KEY`
	HOST_VALUE=`python_function HOST`
	TAGS_VALUE=`python_function tags`
	GROUP_VALUE=`python_function gn`

}

constructInstallationParam(){
        if [ ! -d $MON_AGENT_HOME ]; then
		bash Site24x7MonitoringAgent.install -i -key="$KEY_VALUE" -proxy="$PROXY_VALUE" -dn="$DN_VALUE" -gn="$GN_VALUE" -ct="$CT_VALUE" -tp="$TP_VALUE" -np="$NP_VALUE" -rp="$RP_VALUE" -installer="$INSTALLER_VALUE" -gn="$GROUP_VALUE" -tags="$TAGS_VALUE" -da -psw 
	fi
        if [ -d $SUPERVISOR_CONFD_DIR ]; then
	    if [ ! -f $SUPERVISOR_CONFD_FILE ]; then
		cp $MON_AGENT_SUPERVISOR_CONF_FILE $SUPERVISOR_CONFD_FILE
	    fi
        else
            if [ ! -f $ALPINE_SUPERVISOR_CONFD_FILE ]; then
                mkdir /etc/supervisor.d 2>/dev/null
                cp $MON_AGENT_SUPERVISOR_CONF_FILE $ALPINE_SUPERVISOR_CONFD_FILE
            fi
        fi
}

INSTALL_DIR="/opt"
variableUpdate
getEnvValues

x=1
while [ $x -le 60 ]
do
	DOMAIN=`domain_decider`
        wget $DOMAIN/server/archive/linux/1940/Site24x7MonitoringAgent.install
        if [ $? = 0 ]
        then
                constructInstallationParam
                break
        fi
        x=$(( $x+1 ))
        printf "Not able to download Site24x7 Agent Installer - Retry after 1 minute \n"
        sleep 60
done

exec "$@"
