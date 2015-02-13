#!/bin/bash
# Functions and parameters

###############################################################################
#
# Command line parsing
#
###############################################################################
usage()
{
cat << EOF
usage: $0 options

Run ${task} experiments
OPTIONS:
   -h	Show this message
   -s n	Skip n repeats
EOF
}

skip="-1"

while getopts “hs:” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         s)
             skip=$OPTARG
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

echo "skip is " ${skip}
###############################################################################


func2 () {
   if [ -z "$1" ]                           # Is parameter #1 zero length?
   then
     echo "-Parameter #1 is zero length.-"  # Or no parameter passed.
   else
     echo "-Param #1 is \"$1\".-"
   fi

   variable=${1-$DEFAULT}                   #  What does
   echo "variable = $variable"              #+ parameter substitution show?
                                            #  ---------------------------
                                            #  It distinguishes between
                                            #+ no param and a null param.

   if [ "$2" ]
   then
     echo "-Parameter #2 is \"$2\".-"
   fi

   return 0
}

DEFAULT=default                             # Default param value.

func2

func2 foo