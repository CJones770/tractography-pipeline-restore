#!/bin/bash
SubjectDirectory=$1
zi=$2
echo "Clearing pipeline of temporarily stored values..."
rm -r /opt/Pipeline/Pipeline/Pipeline/ACQP/sub_$zi/*
rmdir /opt/Pipeline/Pipeline/Pipeline/ACQP/sub_$zi/
echo "Values removed for subject $zi: Pipeline ready for next subject/cohort."
