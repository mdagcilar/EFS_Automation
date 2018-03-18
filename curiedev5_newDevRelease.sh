#!/bin/bash        
# script: 'curiedev5_newDevRelease.sh'
# Metin Dagcilar - March 2018


# Increments the version name of a string "version_1" -> "version_2"
#
# @param $1 - versionName
function incrementVersion(){
	if [[ $# -ne 1 ]]; then
		echo "Error - IncorrectNumberOfArguments: incrementVersion() should take a single argument as input e.g. 'curiedev5_version_2'"
		return 1
	fi

	# split the input parameter by '_' and extracts the last column
	currentVersionNum=$(echo $1 | awk -F "_" '{print $NF}')		#NF (number of fields)

	increment=$(($currentVersionNum+1))
 
	# replace version numbers
	newVersion=$(echo $1 | sed "s/\(.*\)$currentVersionNum/\1$increment/")


	# if there is no version number, then append "_1" to the input string "version" -> "version_1"
	if ! [[ $currentVersionNum =~ ^[0-9]+$ ]]; then
		nVersion=$1_1
		echo $nVersion
		return 0
	fi

	echo $newVersion
	return 0
}


# Creates a new release name based on the current user running the script and 
# their previous releases inside the directory -> /efs/dev/$1/$2/
#
# @param $1 - META
# @param $2	- PROJECT
function createReleaseName(){
	if [[ $# -ne 2 ]]; then
		echo "Error - IncorrectNumberOfArguments: createReleaseName() takes two arguments as input e.g. \$META \$PROJECT"
		return 1
	fi

	# search for releases that match the user in /efs/dev/$1/$2/
	userReleases=$(ls /home/$USER/$1/$2/ | grep $USER) #final version change ('$USER' to 'dev' )

	# find the latest release associated with the user
	arrayUserReleases=($(echo $userReleases | tr " " "\n")) # Split current user releases into an array

	arrLength=${#arrayUserReleases[@]}

	mostRecentVersion=${arrayUserReleases[0]}
	max=$(echo ${arrayUserReleases[0]} | awk -F "_" '{print $NF}') # initiase max - first element

	# loop through releases, find the max version
	for (( i = 1; i < arrLength; i++ )); do
		current=$(echo ${arrayUserReleases[i]} | awk -F "_" '{print $NF}')

		if [[ "$current" -gt "$max" ]]; then
			max=$current 		# new max found
			mostRecentVersion=${arrayUserReleases[i]}
		fi
	done

	echo $mostRecentVersion			 
}

# Creates a new efs release for the $user
function createEfsLink(){
	releaseName=$(createReleaseName $1 $2) # test week1
	nextReleaseName=$(incrementVersion $releaseName)
	
	# 2.2 create link (run efs command)
	echo "efs create release" $1 $2 $nextReleaseName
	#$(efs create release $1 $2 $nextReleaseName)
	echo "complete(release) - $releaseName -> $nextReleaseName"
	echo

	copyFilesToSrc $nextReleaseName
}

# Copies the first file found in /home/$USER/ - inside src folder
#
# @param $1 - release name to copy files to
function copyFilesToSrc(){

	# finds files, non-recursively, excluding hidden files.
	arrayFiles=$(find /home/$USER/ -maxdepth 1 -type f -not -path '*/\.*')

	if ! [[ -z "$arrayFiles" ]]; then
		firstFile=$(echo ${arrayFiles[0]} | awk -F " " '{print $1}')

		# copy file
		$(cp $firstFile /home/$USER/efs_release_links/curiedev5_1/src/)
		echo "File:'"$firstFile"' - copied to '/home/$USER/efs_release_links/curiedev5_1/src/'"

		# TODO: uncomment these two versions for final version. - changes fixed 'curiedev5_1' to the new releasename
		# $(cp $firstFile /home/$USER/$1/$2/$releaseName/src/)
		# echo "File:'"$firstFile"' - copied to '/home/$USER/$1/$2/$releaseName/src/'"
	else
		echo "Error - copyFilesToSrc(): No files found to copy in /home/$USER/"
	fi
}

function curiedev5_newDevReleaseMain(){
	if [[ $# -ne 2 ]]; then
		echo "Error - IncorrectNumberOfArguments: curiedev5_newDevRelease.sh takes two arguments as input e.g. 'META' 'PROJECT'"
		return 1
	fi

	createEfsLink $1 $2 	# META PROJECT
}

