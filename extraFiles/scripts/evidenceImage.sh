#!/bin/sh
#
# image <source> <evidence dir> <evidence file no extension>
# last edit 17/06/2013 - Lee Tobin

function performEvidenceImage() {
	evidenceDisk=$1
	checkDest=$(mount | grep firestor)
	if [ "$checkDest" == "" ] 
	then
		echo "ERROR: Storate not initialised"
		return
	fi

	stty intr '^['
	trap 'echo "Grapped"; stty intr "" ; exit 1' INT

	evidenceDisk=$1

	#dcfldd if=/dev/$evidenceDisk conv=noerror statusinterval=2048 hash=md5 split=256M of="$2/$3" hashlog="$2/hashlog.log" 2>&1 | tr -d "()ocwriten." | lcd j 0 3

	if [ "$IMAGING_TOOL_SUITE" = "dcfldd" ]; then
		dcfldd if=/dev/$evidenceDisk conv=noerror statusinterval=2048 hash=md5 split=256M of="$2/$3" hashlog="$2/hashlog.log" 2>&1 | tr -d "()ocwriten."
		imghash=$(tail -n 1 "$2/hashlog.log" | grep -o "[0-9a-f]*" | tail -n 1)
	elif [ "$IMAGING_TOOL_SUITE" = "ewfacquire" ]; then
		ewfacquire -t "$2/$3" -u -S 640MiB /dev/$evidenceDisk > $2/$3.log
	else
		echo "ERROR: IMAGING_TOOL_SUITE configuration paramater is not set or has invalid value"
		return 
	fi

	stty intr ''
	echo "COMPLETE"
}

