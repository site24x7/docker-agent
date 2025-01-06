#!/bin/bash
#Author : Arunagiriswaran E
#Company : ZOHOCORP

PYTHON_VENV_HOME=/opt/venv
PYTHON_VENV_BIN_PATH=$PYTHON_VENV_HOME/bin/python
PYTHON_VENV_PIP_PATH=$PYTHON_VENV_HOME/bin/pip

setup_venv(){
	python3 -m venv $PYTHON_VENV_HOME
}

install_packages(){
	#$PYTHON_VENV_PIP_PATH install --upgrade pip
	$PYTHON_VENV_PIP_PATH install -r /opt/requirements.txt >> pip_out.txt
}

setup_venv
install_packages
