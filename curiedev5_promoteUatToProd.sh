#!/bin/bash
# script: 'curiedev5_promoteUatToProd.sh'
# Metin Dagcilar - March 2018

# 5.1 - Creates the prod release link, and dists it
# 
# @param $1 - META
# @param $2	- PROJECT
function createProdRelease(){
	echo "efs create releaselink" $1 $2 $releaseName PROD
	#$(efs create releaselink" $1 $2 $releaseName PROD)	

	echo "efs dist releaselink" $1 $2 PROD
	#$(efs dist releaselink" $1 $2 PROD)
	echo "complete(prod releaselink)"	
	echo
}


###### main
source /home/ec2-user/bin/curiedev5_newDevRelease.sh $1 $2 # import functions from 'curiedev5_newDevRelease.sh'
releaseName=$(createReleaseName $1 $2) # test week1

if [[ $# -ne 2 ]]; then
	echo "Error - IncorrectNumberOfArguments: curiedev5_promoteUatToProd.sh takes two arguments as input e.g. 'META' 'PROJECT'"
	return 1
fi

######### END main