#!/bin/bash
# script: 'curiedev5_newDevReleaseAdvacnced.sh'
# Metin Dagcilar - March 2018

# calls 'curiedev5_newDevRelease.sh' script to determine:
# 1 - next release name
# 2 - create a new efs release 
# 3 - copy some files across from /home/ to the src folder of the new release
source /home/ec2-user/bin/curiedev5_newDevRelease.sh $1 $2	# import functions from 'curiedev5_newDevRelease.sh'
echo "$(curiedev5_newDevReleaseMain $1 $2)"

releaseName=$(createReleaseName $1 $2) # e.g. META PROJECT


# 3.3 - Create install/common
#
# @param $1 - META
# @param $2	- PROJECT
function createCommon(){
	echo "efs create install" $1 $2 $releaseName common
	#$(efs create install" $1 $2 $releaseName common)
	echo "complete(install/common)"
	echo
}

# Copy src contents -> install/common
function copySrcToCommon(){
	
	$(cp -r /home/$USER/efs_release_links/curiedev5_1/src/ /home/$USER/efs_release_links/curiedev5_1/install/common/)
	echo "Copied:'/home/$USER/efs_release_links/curiedev5_1/src/' contents to '/home/$USER/efs_release_links/install/common/'"

	# TODO: uncomment these two lines for final version. - changes fixed 'curiedev5_1' to the new releasename
	# $(cp -r /home/$USER/$1/$2/$releaseName/src/ /home/$USER/$1/$2/$releaseName/install/common/)
	# echo "Copied:'/home/$USER/$1/$2/$releaseName/src/' contents to '/home/$USER/$1/$2/$releaseName/install/common/'"
	echo "HEREEEEEEEEEEEEEEE copySrcToCommon" $releaseName
}

# 3.6 - Create DEV releaselink to point at the new release
#
# @param $1 - META
# @param $2	- PROJECT
function createDevReleaseLink(){
	echo "efs create releaselink" $1 $2 $releaseName DEV
	#$(efs create releaselink" $1 $2 $releaseName DEV)
	echo "complete(DEV releaselink)"
	echo
}


###### main
if [[ $# -ne 2 ]]; then
	echo "Error - IncorrectNumberOfArguments: curiedev_5newDevReleaseAdvacnced.sh takes two arguments as input e.g. 'META' 'PROJECT'"
	return 1
fi

createCommon $1 $2
copySrcToCommon $1 $2
createDevReleaseLink $1 $2

###### END main