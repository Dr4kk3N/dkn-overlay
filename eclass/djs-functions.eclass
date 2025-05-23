# Just my common functions

EXPORT_FUNCTIONS makeSymlink makeSymlinks patchPackage

# TODO: More complex (repair some hardcoded values)

djs-functions_makeSymlink() {
	local sourceZip="${1}.zip"
	local destinationPath="$2"
	local parentSourceDir=$(unzip -l "${sourceZip}" | awk '{print $4}' | grep '/$' | awk -F/ '{print $1}' | sort -u)

	if [[ -d "${destinationPath}" ]]; then
		rm -rf "${destinationPath}"
	fi

	ln -s "${WORKDIR}/${parentSourceDir}" "${destinationPath}"
}


djs-functions_makeSymlinks() {
# get paths
	local sourceDir="${1}"
	local targetDir="${2}"
	shift 2

	# Get array of subpaths
	local arrayOfDirectories=("$@")

	# Do the symlink looping
	local dir
	for dir in ${arrayOfDirectories[@]}; do
		makeSymlink "${sourceDir}${dir}" "${targetDir}${dir}"
	done
}

djs-functions_patchPackage() {
	# Get parameters
	local filesDir="${1}"
	local packageName="${2}"
	local packageVersion="${3}"

	# Generic patching - always will be patched
	_patch "${filesDir}/${packageName}-generic*.patch"

	# Experimental or normal is done by packageversion
	_patch "${filesDir}/${packageName}-${packageVersion}*.patch"
}

_patch() {
	local scanPath="${1}"

	# Prepare work
	local patch
	local patches

	# Generic patches
	patches=( $scanPath )

	# Nothing to do, no patching
	[[ -z "${patches}" ]] && return 0

	# Process
	for patch in ${patches[@]}; do
		[[ -e "${patch}" ]] || continue

		eapply "${patch}"
	done

}
