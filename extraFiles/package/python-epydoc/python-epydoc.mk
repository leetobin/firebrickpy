################################################################################
#
# python-epydoc
#
################################################################################

PYTHON_EPYDOC_VERSION = 3.0.1
PYTHON_EPYDOC_SOURCE = epydoc-$(PYTHON_EPYDOC_VERSION).tar.gz
PYTHON_EPYDOC_SITE = http://pypi.python.org/packages/source/e/epydoc
PYTHON_EPYDOC_SETUP_TYPE = distutils

$(eval $(python-package))
$(eval $(host-python-package))
