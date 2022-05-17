#!/bin/bash
subDir=$1
mount=$2
workdir=$3
desiredPad=$4
numSubs=`expr 1` 
availableSpace=`df -hm | grep $2 | awk '{ print $4 }'`
spaceNeeded=`expr $numSubs \* 6500 + 3072 + $4`
echo "space available on mount $2 is "$availableSpace"MB and space needed is "$spaceNeeded"MB"
if [ -e ./disk_check_e.txt ] && [ $spaceNeeded -le $availableSpace ]
then
rm disk_check_e.txt
echo "There is sufficient space available to run the pipeline and leave "$4"MB open on the disk : $2" 
fi
if [ $spaceNeeded -ge $availableSpace ]
then
echo "not enough space available to run pipeline for $numSubs subject(s)"
exec > $3/disk_check_e.txt 2>&1
exit 1
fi 
if [ $spaceNeeded -le $availableSpace ]
then
echo "There is sufficient space available to run the pipeline for $numSubs subject(s)"
fi
echo "Beginning pipeline : "

