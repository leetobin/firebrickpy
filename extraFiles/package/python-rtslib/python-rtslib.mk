################################################################################
#
# python-rtslib
#
################################################################################

#PYTHON_RTSLIB_VERSION = 0546cad8980783c39f96db717005a550059b730f
#PYTHON_RTSLIB_SITE = $(call github,Datera,rtslib,$(PYTHON_RTSLIB_VERSION))
PYTHON_RTSLIB_VERSION = 0.7
PYTHON_RTSLIB_SOURCE  = master.tar.gz
PYTHON_RTSLIB_SITE    = https://github.com/Datera/rtslib/archive
PYTHON_RTSLIB_LICENSE = apache
PYTHON_RTSLIB_SETUP_TYPE = distutils
PYTHON_RTSLIB_DEPENDENCIES = python-ipaddr python-netifaces python-configobj python-epydoc python-pyparsing
HOST_PYTHON_RTSLIB_DEPENDENCIES = host-python-ipaddr host-python-netifaces host-python-configobj host-python-epydoc host-python-pyparsing

$(eval $(python-package))
