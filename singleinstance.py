'''
Created on 25-Jan-2018

@author: giri
'''
import psutil
import sys
psutil.PROCFS_PATH = "/host/proc"
filter_list = ["Site24x7Agent", "MonitoringAgent.py"]
for proc in psutil.process_iter():
    try:
        pinfo = proc.as_dict(attrs=["name", "exe", "cmdline", "pid"])
    except Exception as e:
        continue
    if type(pinfo["cmdline"]) is list:
        process_name = " ".join(pinfo["cmdline"]).strip()
        if process_name:
            final_list = list(filter(lambda x : x in process_name, filter_list))
            if final_list:
                print("Site24x7Agent already running with pid {} hence quitting!!!".format(pinfo["pid"]))
                sys.exit(1)
                