#!/bin/sh
#
# Firebrick 
# last edit 17/06/2013 - Lee Tobin

if [[ ${#storageDevice} -gt 2 ]] ; then

	clearDisplay
	displayStrings "1. Export" "2. Initialise" "3. Back" 
	stty raw; read -n 1 key; stty -raw
	clearDisplay
	case "$key" in
		1)
			source ./storageExport.sh 
			;;
		2) 	
			source ./storageInit.sh 
			;;
		*)
			
	esac
else 
	clearDisplay
	displayStrings "  Storage" "  not found!!"
	sleep 2
fi
