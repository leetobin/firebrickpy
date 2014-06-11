#!/bin/sh
#
# Firebrick 
#

newdate=''
newtime=''
while [ "$key" != "3" ]; do
	clearDisplay
	displayStrings "1. Set Date" "2. Set Time" "3. Back" "$(date +\(%H:%M\)%Y-%m-%d)"
	stty raw; read -n 1 key; stty -raw
	clearDisplay
	case "$key" in
		1)
			clearDisplay
			displayStrings "$(date +\"%Y-%m-%d\")" "Input date:" "YYYY-MM-DD" ""
			newdate=$(readString)
         date -s "$newdate $(date +%H:%M:%S)"
			;;
		2) 	
			clearDisplay
			displayStrings "$(date +\"%H:%M:%S\")" "Input time:" "HH:MM:SS" ""
			newtime=$(readString)
			date -s "$(date +%Y-%m-%d) $newtime"
			;;
		*)
			
	esac

done
