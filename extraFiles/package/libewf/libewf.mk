LIBEWF_VERSION=20130331
LIBEWF_SOURCE = libewf-experimental-20130331.tar.gz
LIBEWF_SITE = https://googledrive.com/host/0B3fBvzttpiiSMTdoaVExWWNsRjg/
LIBEWF_AUTORECONF = NO
LIBEWF_INSTALL_STAGING = NO
LIBEWF_INSTALL_TARGET = YES
LIBEWF_DEPENDENCIES = uclibc
$(eval $(autotools-package))
