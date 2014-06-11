#!/bin/sh
#
# Firebrick 
# last edit 17/06/2013 - Lee Tobin
# 25/05/2014 DaveOR:
#	- Amended to invoke external script to create iSCSI target

#assemble drives

if [[ $storageDevice == "/dev/md0" ]] ; then
	mdadm --assemble /dev/md0 /dev/$storageDisk1 /dev/$storageDisk2
	fdisk -l
	sleep 3
	fdisk -l
fi

if [ "$EVIDENCE_PRESENTATION" = "iscsi" ]; then
	#invoke python script to create lio configuration
	iscsiStorageExport.py $storageDevice $ISCSI_TARGET_WWN $ISCSI_TARGET_PORT $ISCSI_INITIATOR_WWN
fi

clearDisplay
displayStrings "Storage exported" "Press any key" "to poweroff..."
stty raw; read -n 1 key; stty -raw
clearDisplay
poweroff
sleep 10
