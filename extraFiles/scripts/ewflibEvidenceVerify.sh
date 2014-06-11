#!/bin/sh
#
# verify <evidence dir> <evidence file no extension> <hash>
# last edit 17/06/2013 - Lee Tobin

function verifyImage() {
	ewfverify $1/$2.E01 > $1/$2.verify.log
	echo "COMPLETE"
}
