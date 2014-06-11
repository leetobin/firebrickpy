#!/bin/sh
#
# verify <evidence dir> <evidence file no extension> <hash>
# last edit 17/06/2013 - Lee Tobin

function evidenceVerifyFeed() {
	totlen=$(du -c $1.* | tail -n 1 | grep -o "[0-9]*")
	runlen=0

	for inp in $1.*
	do
	#  flen=$(du $inp | grep -o "[0-9]*" | head -n 1)
  	#runlen=$(($flen + $runlen))
  	#displayStrings "" "" "$(( $runlen / ( $totlen / 100 ) ))%"
  		cat $inp
	done
}

function verifyImage() {
	stty intr '^['
	trap 'echo "Trapped"; stty intr "" ;exit 1' INT

	evidenceVerifyFeed $1/$2 | md5sum > verify.res
	read hash <verify.res
	if [ "$hash"="$3" ] ; then
   	stty intr ''
   	echo "COMPLETE"
   	exit 0
	else
   	stty intr ''
   	echo "ERROR"
   	exit 1;
	fi
}
