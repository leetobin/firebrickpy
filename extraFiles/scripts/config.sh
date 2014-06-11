#!/bin/sh

# Configuration parameters
# Added by DaveOR - 24/05/2014


# Use the IMAGING_TOOL_SUITE configuration parameter to select the imaging 
# suite used to create/verify images
#
# Valid values are:
#    ewfacqure : Use the ewfacquire tool to create an EnCase E01 file
#    dcfldd    : Use the dcfldd tool to create a dd file in multiple parts
#
export IMAGING_TOOL_SUITE=ewfacquire


# Use the INPUT_OUTPUT_LOCATION configuration parameter to select the output
# location for the prompts and output messages from the scripts
#
# Valid values are:
#    lcd       : Output messages to LCD
#    stdout    : Output messages to standard output
#    none      : Display no output
#
export INPUT_OUTPUT_LOCATION=stdout


# Use the EVIDENCE_PRESENTATION configuration parameter to select how the 
# evidence drive should be presented for access of captured images
#
# Valid values are:
#    iscsi     : Present the evidence drive over iSCSI
#
export EVIDENCE_PRESENTATION=iscsi


# Use the ISCSI_TARGET_WWN configuration parameter to set the iSCSI
# identity used to present the evidence drive target
#
# Valid values are valid iSCSI WWN
#
export ISCSI_TARGET_WWN=iqn.2003-01.org.linux-iscsi.x.x8664:sn.d3d8b0500fde


# Use the ISCSI_TARGET_PORT configuration parameter to set the TCP/IP
# port used to present the evidence drive target by iSCSI
#
export ISCSI_TARGET_PORT=5060


# Use the ISCSI_INITIATOR_WWN configuration parameter to set the iSCSI
# initiator (client) ID used to connect to the evidence drive target
#
# Valid values are valid iSCSI WWN
#
export ISCSI_INITIATOR_WWN=iqn.1993-08.org.debian:01:b571818de1e2

# Use the ZERO_STORAGE_DRIVE_ON_INITIALISE configuration parameter to set whether or not
# to fill the storage drive with zeros before initialising
#
# Valid values are:
#    true      : Fill the storage drive with zeros
#    false     : Do not fill the storage drive with zeros
#
export ZERO_STORAGE_DRIVE_ON_INITIALISE=false

