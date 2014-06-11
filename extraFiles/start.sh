# This is what you run after you've clone the firebrick3 repo
THISDIR=`dirname $0`

cd $THISDIR/../

cp extraFiles/configs/buildroot.config buildroot/.config

PACKAGES=`ls extraFiles/package/`

for ONEPACKAGE in $PACKAGES; do
	if test -d extraFiles/package/${ONEPACKAGE}; then
		echo "Adding $ONEPACKAGE..."

		#Copy files
		cp -R extraFiles/package/${ONEPACKAGE} buildroot/package 

		#Add package config entry
		if grep -F "${ONEPACKAGE}" buildroot/package/Config.in ; then
			echo "${ONEPACKAGE} line present in Config.in not adding..."
		else
			sed -i "/^menu \"Target packages\"/a source \"package/${ONEPACKAGE}/Config.in\"" buildroot/package/Config.in
		fi

		if test -f "extraFiles/package/${ONEPACKAGE}/Config.in.host"; then
			if grep -F "${ONEPACKAGE}" buildroot/package/Config.in.host ; then
				echo "${ONEPACKAGE} line present in Config.in.host not adding..."
			else
				sed -i "/^menu \"Host utilities\"/a source \"package/${ONEPACKAGE}/Config.in.host\"" buildroot/package/Config.in.host
			fi
		fi
	else
		echo "$ONEPACKAGE is not a directory, skipping..."
	fi
done

echo "Adding additional host packages"

EXTRA_HOST_PACKAGES="python-configobj python-pyparsing python-netifaces"

for ONE_EXTRA_HOST_PACKAGE in $EXTRA_HOST_PACKAGES; do
   echo $ONE_EXTRA_HOST_PACKAGES
	if grep -F "host-python-package" buildroot/package/${ONE_EXTRA_HOST_PACKAGE}/${ONE_EXTRA_HOST_PACKAGE}.mk ; then
		echo "host-python-package already present in ${ONE_EXTRA_HOST_PACKAGE}.mk..."
	else
   	sed -i "/\$(eval \$(python-package))/a \$(eval \$(host-python-package))" buildroot/package/${ONE_EXTRA_HOST_PACKAGE}/${ONE_EXTRA_HOST_PACKAGE}.mk
	fi
	cp extraFiles/package/${ONE_EXTRA_HOST_PACKAGE}.config.in.host buildroot/package/${ONE_EXTRA_HOST_PACKAGE}/Config.in.host
	if grep -F "${ONE_EXTRA_HOST_PACKAGE}" buildroot/package/Config.in.host ; then
			echo "${ONE_EXTRA_HOST_PACKAGE} line present in Config.in.host not adding..."
		else
			sed -i "/^menu \"Host utilities\"/a source \"package/${ONE_EXTRA_HOST_PACKAGE}/Config.in.host\"" buildroot/package/Config.in.host
		fi

done

cd buildroot
#make
