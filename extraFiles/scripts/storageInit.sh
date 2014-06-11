#!/bin/sh
#
# Firebrick Initialise Storage script
# last edit 17/06/2013 - Lee Tobin

initSingleDiskStorage() {
	storageDisk=$1	

	# initialise it
	clearDisplay
	displayStrings "Are you sure?" "Input YES" ""
	ans=$(readString)
	if [ "$ans" == "YES" ] ; then 
		clearDisplay
		if [ "$ZERO_STORAGE_DRIVE_ON_INITIALISE" == "true" ]; then
			displayStrings "Zeroing Storage... (This might take a long time)"
			dd if=/dev/zero of=${storageDisk} bs=1M
		fi		
		displayStrings "Initialising Storage..." 
		#create a new partition
		(echo o; echo n; echo p; echo 1; echo 1; echo; echo t; echo c; echo w) | fdisk ${storageDisk}
		#make a FAT fs on first disk partition
		mkfs.vfat -n firestor "${storageDisk}1"
	fi
}

# check if /dev/sda and /dev/sdb are present and the same size
if [[ ${#storageDisk1} -gt 2  &&  ${#storageDisk2} -gt 2 ]] ; then
	read sdaSize < "/sys/block/$storageDisk1/size"
	read sdbSize < "/sys/block/$storageDisk2/size"
	if [ "$sdaSize" == "$sdbSize" ] ; then

		# initialise it
		clearDisplay
		displayStrings	"Are you sure?" "Input YES" ""
		ans=$(readString)
		if [ "$ans" == "YES" ] ; then 

			clearDisplay
			displayStrings "Initialising RAID..." 
			yes | mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/$storageDisk1 /dev/$storageDisk2
			sleep 1 #todo: find a better workaround to address this issue
			#create a new partition
			(echo o; echo n; echo p; echo 1; echo 1; echo; echo t; echo c; echo w) | fdisk /dev/md0
			sleep 1
			#make a FAT fs on first RAID partition
			mkfs.vfat -n firestor /dev/md0p1
			sleep 1
		fi
	else
		clearDisplay
		displayStrings "  RAID Problem:" "  drives are" "  different sizes"      
		sleep 2
	fi 

#Single disk storage
elif [ ${#storageDisk1} -gt 2 ] ; then
	initSingleDiskStorage /dev/${storageDisk1}
elif [ ${#storageDisk2} -gt 2 ] ; then
	initSingleDiskStorage /dev/${storageDisk2}
fi
