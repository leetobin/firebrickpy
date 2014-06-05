#!/bin/sh
# Firebrick build postbuild script
# last edit 01/02/2014 - Lee Tobin

#Add tty0 to secure shell access
if grep -F 'tty0' output/target/etc/securetty ; then
	echo 'tty0 line present not adding...'
else
	echo 'tty0 line NOT present adding...'
	echo 'tty0' >> output/target/etc/securetty 
fi

#Add fstab entries
if grep -F 'configfs' output/target/etc/fstab ; then
	echo 'configfs line present for configfs not adding...'
else
	echo 'configfs	/sys/kernel/config	configfs	defaults	0	0' >> output/target/etc/fstab 
fi

#Add profile tweaks
if test -f output/target/bin/loginLee.sh ; then
	echo 'autologin present not adding...'
else
	echo 'autologin not present!'
	echo "#!/bin/sh" >> output/target/bin/loginLee.sh
	echo "exec /bin/login -f root" >> output/target/bin/loginLee.sh
fi

chmod +x output/target/bin/loginLee.sh

#Update inittab (not doing it now)
/bin/sed -i -e '/# GENERIC_SERIAL$/s~^.*#~tty0::respawn:/sbin/getty -l /bin/loginLee.sh -n -L tty0 115200 vt100 # GENERIC_SERIAL#~' output/target/etc/inittab

#Add this dir to filesystem
if ! test -d output/target/firestor ; then mkdir output/target/firestor ; fi
if ! test -d output/target/scripts ; then 
mkdir output/target/scripts
fi


#Copy init scripts
cp -f ../extraFiles/init.d/* output/target/etc/init.d/
chmod +x output/target/etc/init.d/*

#Copy www files
if ! test -d output/target/var/www ; then mkdir output/target/var/www ; fi
cp -fr ../extraFiles/frontend/* output/target/var/www
chmod +x output/target/var/www/cgi-bin/*

cp -f ../extraFiles/scripts/* output/target/scripts/
cp -f ../extraFiles/.profile output/target/root/.profile

#DHCP config
cp -f ../extraFiles/interfaces output/target/etc/network
cp -f ../extraFiles/udhcpd.conf output/target/etc
cp -f ../extraFiles/httpd.conf output/target/etc

#rm -rf output/target/var/lib/dhcp
#mkdir -p output/target/var/lib/dhcp
#if ! test -f output/target/var/lib/dhcp/dhcpd.leases; then  touch output/target/var/lib/dhcp/dhcpd.leases; fi
#if ! test -f output/target/etc/dhcpd.conf; then  touch output/target/etc/dhcpd.conf; fi


#delete pci info file junk
if test -f output/target/usr/share/pci.ids; then rm -f output/target/usr/share/pci.ids ; fi
