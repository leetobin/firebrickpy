#!/usr/bin/python

# Adapted from http://linux-iscsi.org/wiki/ISCSI#Scripting_with_RTSlib
# Dave O'Reilly

import sys
from rtslib import *
from netifaces import interfaces, ifaddresses, AF_INET

if len(sys.argv) != 5:
	print "Incorrect number of parameters specified."
	print "Usage:"
	print "\t" + sys.argv[0] + " <Evidence drive device> <Target WWN> <Target Port> <Initiator WWN>"
	sys.exit(-1)
else:
	evidenceDriveDevice=sys.argv[1]
	targetWWN=sys.argv[2]
	targetPort=sys.argv[3]
	initiatorWWN=sys.argv[4]

	#setup IBLOCK backstore
	backstore = IBlockBackstore(3, mode='create')
	try:
		so = IBlockStorageObject(backstore, "evidenceDrive", evidenceDriveDevice, gen_wwn=True)
	except:
		backstore.delete()
		raise

	#Create an iSCSI target endpoing using an iSCSI IQN
	fabric = FabricModule('iscsi')
	target = Target(fabric, targetWWN)
	tpg = TPG(target, 1)

	#Set up network portal in the iSCSI TPG
	myIp="ERROR"
	for ifaceName in interfaces():
		if ifaceName == 'eth0':
			addresses = [i['addr'] for i in ifaddresses(ifaceName).setdefault(AF_INET, [{'addr':'No IP addr'}] )]
			myIp=addresses[0]

	if myIp != "ERROR":
		portal = NetworkPortal(tpg, myIp, targetPort)

		#Export LUN 0 via the 'so' StorageObject class
		lun0 = tpg.lun(0, so, "evidenceDrive")

		node_acl = tpg.node_acl(initiatorWWN)

		#True = read only
		mapped_lun = node_acl.mapped_lun(0, 0, True) 
			
		tpg.set_attribute("authentication", "0");
		tpg.enable = True
