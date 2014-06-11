#!/bin/sh
#
# Write/Blocking & Imaging - no return
# last edit 17/06/2013 - Lee Tobin

#export evidential drive

source ./config.sh
source ./evidenceImage.sh
if [ "$IMAGING_TOOL_SUITE" = "dcfldd" ]; then
	source ./dcflddEvidenceVerify.sh 
elif [ "$IMAGING_TOOL_SUITE" = "ewfacquire" ]; then
	source ./ewflibEvidenceVerify.sh
else
	echo "IMAGING_TOOL_SUITE configuration paramater is not set or has invalid value"
fi

if ls -la /sys/block | grep ata. | grep host0 | grep -qo sd.
then
	export evidenceDisk=$(ls -la /sys/block | grep ata. | grep host0 | grep -o sd. | tail -1)
	#Export the evidence drive
	#sh evidenceExport.sh
	#If there is storage then bring up the imaging menu, else just export over FW
	if [[ ${#storageDevice} -gt 2 ]] ; then
	
		#if RAID not assembled, RAID assemble!
		if [[ $storageDevice == "/dev/md0" ]] ; then
			mdadm --assemble /dev/md0 /dev/$storageDisk1 /dev/$storageDisk2
			fdisk -l
			sleep 3
			fdisk -l
		fi

		#mount the storage
		if [[ $storageDevice == "/dev/md0" ]] ; then
			#if RAID
			echo mounting "/dev/md0p1" on /firestor
			mount /dev/md0p1  /firestor
		else
			#mount single disk
			echo mounting "${storageDevice}1" on /firestor
			mount "${storageDevice}1"  /firestor
		fi
		
		sleep 1
		
		
		trap 'echo "ignoring"' INT

		clearDisplay

		#check there is enough space on storage for evidence
		#check that there is enough internal storage for image
		#storage drive
		storageSize=$(df | grep firestor | awk '{print$4}')
		let storageSize=$storageSize*1000
		#now the evidence drive
		evidenceSize=$(fdisk /dev/$evidenceDisk -l | head -2 | tail -1 | awk '{print$5}')
		#echo "Storage size:$storageSize Evidence size:$evidenceSize" #debug output
		#if storagesize > evidencesize
		if [ $storageSize -gt $evidenceSize ]
		then
		
			while [ 1 == 1 ]
			do
				freespace=$(df -h | grep firestor | tr -s " " | cut -d ' ' -f 4 | tr -d $"\n")
				displayStrings "1. Image & verify" "2. Power off" "" "Free:" "$freespace"

				stty raw; read -n 1 key ; stty -raw
				case $key in
				1)
					evidenceID=''
					#check that the ID is unique on storage disk
					while [ "$evidenceID" == "" ]
					do
						clearDisplay
						displayStrings "Enter Evidence ID:" ""
						evidenceID=$(readString | tr -d "?*/\\><|")
						destDir="/firestor/$evidenceID"      

						if test -d destDir 
						then
							clearDisplay
					  		displayStrings "Evidence ID Exists!"
					  		sleep 2
					  		evidenceID=''
						fi
					done

					mkdir $destDir

					exitCode=$(performEvidenceImage $evidenceDisk $destDir $evidenceID)
					if [[ "$exitCode" == "ERROR" ]]; then
						clearDisplay
						displayStrings "Imaging Failed" "Deleting image"
						rm -r $destDir/*
						rmdir $destDir
					else
							clearDisplay
							displayStrings "Verifying image"
							if [ "$IMAGING_TOOL_SUITE" = "ewfacquire" ]; then
								echo "Verification with ewfsuite disabled because "
								echo "1. ewfverify runs out of memory on FIREBrick, and"
								echo "2. EnCase will verify the image when it is added to a case"
							else 
								exitCode=$(verifyImage $destDir $evidenceID)
								echo "Verification exit code is -->$exitCode<--"
								if [[ "$exitCode" == "ERROR" ]]; then
									clearDisplay
									displayStrings "Verification falied" "Deleting image"
					   			rm -r $destDir/*
					   			rmdir $destDir
								else
									clearDisplay
					   			displayStrings "Verification Success"
					   			sleep 1
								fi    
							fi
					fi
					clearDisplay
					;;

				2)
					poweroff
					sleep 10
					;;
				s)
					clearDisplay
					exit
					;;
				*)
					;;
				esac
			done
		else
			clearDisplay
			displayStrings "Insufficient" "storage available" "Press any key" "to poweroff..."
			stty raw; read -n 1 key; stty -raw
			clearDisplay
			poweroff
			sleep 10
		fi
	else
		clearDisplay
		displayStrings "Evidence exported" "Press any key" "to poweroff..."
		stty raw; read -n 1 key; stty -raw
		clearDisplay
		poweroff
		sleep 10
	fi

else
	clearDisplay
	displayStrings "  Evidence drive" "  not found!!"
	sleep 2
fi
