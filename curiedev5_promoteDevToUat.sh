#!/bin/bash
# script: 'curiedev5_promoteDevToUat.sh'
# Metin Dagcilar - March 2018



# 4.1 - Create checkpoint 
#
# @param $1 - META
# @param $2	- PROJECT
function checkpoint(){
	echo "efs checkpoint" $1 $2 $releaseName
	#$(efs checkpoint" $1 $2 $releaseName)	
	echo "complete(checkpoint)"
	echo
}

# 4.2 - Create dist
#
# @param $1 - META
# @param $2	- PROJECT
function dist(){
	echo "efs dist release" $1 $2 $releaseName
	#$(efs dist release" $1 $2 $releaseName)	

	echo "efs dist releaselink" $1 $2 DEV
	#$(efs dist releaselink" $1 $2 DEV)	
	echo "complete(dists)"
	echo
}

# 4.3 - Creates release link for UAT, and dists it
#
# @param $1 - META
# @param $2	- PROJECT
function releaseUAT(){
	echo "efs create releaselink" $1 $2 $releaseName UAT
	#$(efs create releaselink" $1 $2 $releaseName UAT)	

	echo "efs dist releaselink" $1 $2 UAT
	#$(efs dist releaselink" $1 $2 UAT)	
	echo "complete(releaselink for UAT)"
}

###### main
source /home/ec2-user/bin/curiedev5_newDevRelease.sh $1 $2 # import functions from 'curiedev5_newDevRelease.sh'
releaseName=$(createReleaseName $1 $2) # test week1

if [[ $# -ne 2 ]]; then
	echo "Error - IncorrectNumberOfArguments: curiedev5_promoteDevToUat.sh takes two arguments as input e.g. 'META' 'PROJECT'"
	return 1
fi

checkpoint $1 $2
dist $1 $2
releaseUAT $1 $2

# END main