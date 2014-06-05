#!/bin/sh
#
# Firebrick Initialise Storage script
# last edit 17/06/2013 - Lee Tobin

# check if /dev/sda and /dev/sdb are present and the same size
if [[ ${#storageDisk1} -gt 2  &&  ${#storageDisk2} -gt 2 ]] ; then
	read sdaSize < "/sys/block/$storageDisk1/size"
	read sdbSize < "/sys/block/$storageDisk2/size"
	if [ "$sdaSize" == "$sdbSize" ] ; then

		# initialise it
		lcd c
		lcd g 0 0 ; lcd p "Are you sure?"
		lcd g 0 1 ; lcd p "Input YES"
		lcd g 0 2
		ans=$(lcd i)
		if [ "$ans" == "YES" ] ; then 

			lcd c
			lcd g 0 1; lcd p "Initialising RAID..." 
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
		lcd c
		lcd g 0 0; lcd p "  RAID Problem:"
		lcd g 0 1; lcd p "  drives are"
		lcd g 0 2; lcd p "  different sizes"      
		sleep 2
	fi 

#Single disk storage
elif [ ${#storageDisk1} -gt 2 ] ; then
	# initialise it
	lcd c
	lcd g 0 0 ; lcd p "Are you sure?"
	lcd g 0 1 ; lcd p "Input YES"
	lcd g 0 2
		ans=$(lcd i)
	if [ "$ans" == "YES" ] ; then 
			lcd c
		lcd g 0 1; lcd p "Initialising Storage..." 
		
		#create a new partition
		(echo o; echo n; echo p; echo 1; echo 1; echo; echo t; echo c; echo w) | fdisk /dev/$storageDisk1
		#make a FAT fs on first disk partition
		mkfs.vfat -n firestor "/dev/${storageDisk1}1"
	fi

#Single disk storage
elif [ ${#storageDisk2} -gt 2 ] ; then

	# initialise it
	lcd c
	lcd g 0 0 ; lcd p "Are you sure?"
	lcd g 0 1 ; lcd p "Input YES"
	lcd g 0 2
		ans=$(lcd i)
	if [ "$ans" == "YES" ] ; then 
			lcd c
		lcd g 0 1; lcd p "Initialising Storage..." 
		
		#create a new partition
		(echo o; echo n; echo p; echo 1; echo 1; echo; echo t; echo c; echo w) | fdisk /dev/$storageDisk2
		#make a FAT fs on first disk partition
		mkfs.vfat -n firestor "/dev/${storageDisk2}1"
	fi
fi
