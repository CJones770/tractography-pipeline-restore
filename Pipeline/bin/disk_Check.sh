#!/bin/bash
subDir=$1
mount=$2
workdir=$3
numSubs=`ls $1 | wc -l`
availableSpace=`df -hm | grep $2 | awk '{ print $4 }'`
spaceNeeded=`expr $numSubs \* 9500 + 150000`
echo "space available on mount $2 is "$availableSpace"MB and space needed is "$spaceNeeded"MB"
if [ $spaceNeeded -ge $availableSpace ]
then
echo "not enough space available to run pipeline for $numSubs subjects"
exec > $3/disk_check_e.txt 2>&1
exit 1
fi 
if [ $spaceNeeded -le $availableSpace ]
then
echo "There is sufficient space available to run the pipeline for $numSubs subjects"
fi
echo "Beginning pipeline : "

