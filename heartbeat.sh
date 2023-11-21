#!/bin/bash
#Author : Arunagiriswaran E
#Company : ZOHOCORP
export COLUMNS=5000
MON_AGENT_PROG_NAME="MonitoringAgent.py"
MON_AGENT_WATCHDOG_PROG_NAME="MonitoringAgentWatchdog.py"
SUCCESS=0
FAILURE=1

isAgentRunning() {
	PID=$(ps auxww | grep $MON_AGENT_PROG_NAME | grep -v grep | grep -v $MON_AGENT_WATCHDOG_PROG_NAME | awk -F ' ' '{print $2}')
	if [ "$PID" == "" ]; then 
	    return $FAILURE
	else	    
    	return $SUCCESS
	fi        
}
isAgentRunning