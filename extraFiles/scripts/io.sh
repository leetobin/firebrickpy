#!/bin/sh

# Input/Output support functions
# 24/05/2014 DaveOR: Initial version of this file

clearDisplay() {
	if [ "$INPUT_OUTPUT_LOCATION" = "lcd" ]; then
		lcd c
	elif [ "$INPUT_OUTPUT_LOCATION" = "stdout" ]; then
		clear
	#else 
		# No (or invalid) input/output location specified
	fi
}

displayStrings() {
	
	i=0
	for oneString in "$@"
	do
		if [ "$INPUT_OUTPUT_LOCATION" = "lcd" ]; then
			lcd g 0 $i ; lcd p $oneString
		elif [ "$INPUT_OUTPUT_LOCATION" = "stdout" ]; then
			echo $oneString
		fi
		i=$((i+1))
	done
}

readString() {
	if [ "$INPUT_OUTPUT_LOCATION" = "lcd" ]; then
		echo $(lcd i)
	elif [ "$INPUT_OUTPUT_LOCATION" = "stdout" ]; then
		read line
		echo $line
	#else 
		# No (or invalid) input/output location specified
	fi
}

