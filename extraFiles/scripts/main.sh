#!/bin/sh
#
# Firebrick Main menu
# last edit 17/06/2013 - Lee Tobin

while [ "$key" != "4" ]; do
	clearDisplay
	displayStrings "1. Set Date/Time" "2. Storage" "3. Imaging/Writeblock" "4. Power Down" 
	stty raw; read -n 1 key; stty -raw
	clearDisplay
	case "$key" in
		1)
			source ./datetime.sh 
			;;
		2) 	
			source ./storage.sh 
			;;
		3)
			source ./evidence.sh 
			;;
		4)
			clearDisplay
			poweroff
			sleep 10
			;;
		s)
			exit 0;
			;;
		*)
	esac
done
