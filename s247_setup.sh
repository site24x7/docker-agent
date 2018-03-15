#!/bin/bash
#Author : Arunagiriswaran E
#Company : ZOHOCORP

PYTHON_VENV_HOME=/opt/site24x7/venv
PYTHON_VENV_BIN_PATH=$PYTHON_VENV_HOME/bin/python
PYTHON_VENV_HOME_ACTIVATE=$PYTHON_VENV_HOME/bin/activate
PYTHON_VENV_PIP_PATH=$PYTHON_VENV_HOME/bin/pip

setup_venv(){
	wget https://raw.githubusercontent.com/pypa/virtualenv/master/virtualenv.py --no-check-certificate
	python virtualenv.py --no-pip --no-setuptools "$PYTHON_VENV_HOME"
}


setup_pip(){
	wget https://bootstrap.pypa.io/get-pip.py --no-check-certificate
	$PYTHON_VENV_BIN_PATH get-pip.py
}

install_packages(){
	$PYTHON_VENV_PIP_PATH install --upgrade pip
	for py_module in $(cat requirements.txt)
            do
                $PYTHON_VENV_PIP_PATH install $py_module
            done
}

setup_venv
setup_pip
install_packages
