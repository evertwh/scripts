filter_comments () {
	grep -v "^#" $1
}

. ${HOME}/lib/shflags

#define the flags
DEFINE_boolean 'birthdate' false 'Output time at birth rather than time of death' 'b'

# Parse the flags
FLAGS "$@" || exit 1
eval set -- "${FLAGS_ARGV}"


echo "Birthdate: " $FLAGS_birthdate

#filter_comments $2