#!/bin/bash
# random-between.sh
# Random number between two specified values. 
# Script by Bill Gradwohl, with minor modifications by the document author.
# Used with permission.


randomBetween() {
   #  Generates a positive or negative random number
   #+ between $min and $max
   #+ and divisible by $divisibleBy.
   #  Gives a "reasonably random" distribution of return values.
   #
   #  Bill Gradwohl - Oct 1, 2003

   syntax() {
   # Function embedded within function.
      echo
      echo    "Syntax: randomBetween [min] [max] [multiple]"
      echo
      echo -n "Expects up to 3 passed parameters, "
      echo    "but all are completely optional."
      echo    "min is the minimum value"
      echo    "max is the maximum value"
      echo -n "multiple specifies that the answer must be "
      echo     "a multiple of this value."
      echo    "    i.e. answer must be evenly divisible by this number."
      echo    
      echo    "If any value is missing, defaults area supplied as: 0 32767 1"
      echo -n "Successful completion returns 0, "
      echo     "unsuccessful completion returns"
      echo    "function syntax and 1."
      echo -n "The answer is returned in the global variable "
      echo    "randomBetweenAnswer"
      echo -n "Negative values for any passed parameter are "
      echo    "handled correctly."
   }

   local min=${1:-0}
   local max=${2:-32767}
   local divisibleBy=${3:-1}
   # Default values assigned, in case parameters not passed to function.

   local x
   local spread

   # Let's make sure the divisibleBy value is positive.
   [ ${divisibleBy} -lt 0 ] && divisibleBy=$((0-divisibleBy))

   # Sanity check.
   if [ $# -gt 3 -o ${divisibleBy} -eq 0 -o  ${min} -eq ${max} ]; then 
      syntax
      return 1
   fi

   # See if the min and max are reversed.
   if [ ${min} -gt ${max} ]; then
      # Swap them.
      x=${min}
      min=${max}
      max=${x}
   fi

   #  If min is itself not evenly divisible by $divisibleBy,
   #+ then fix the min to be within range.
   if [ $((min/divisibleBy*divisibleBy)) -ne ${min} ]; then 
      if [ ${min} -lt 0 ]; then
         min=$((min/divisibleBy*divisibleBy))
      else
         min=$((((min/divisibleBy)+1)*divisibleBy))
      fi
   fi

   #  If max is itself not evenly divisible by $divisibleBy,
   #+ then fix the max to be within range.
   if [ $((max/divisibleBy*divisibleBy)) -ne ${max} ]; then 
      if [ ${max} -lt 0 ]; then
         max=$((((max/divisibleBy)-1)*divisibleBy))
      else
         max=$((max/divisibleBy*divisibleBy))
      fi
   fi

   #  ---------------------------------------------------------------------
   #  Now, to do the real work.

   #  Note that to get a proper distribution for the end points,
   #+ the range of random values has to be allowed to go between
   #+ 0 and abs(max-min)+divisibleBy, not just abs(max-min)+1.

   #  The slight increase will produce the proper distribution for the
   #+ end points.

   #  Changing the formula to use abs(max-min)+1 will still produce
   #+ correct answers, but the randomness of those answers is faulty in
   #+ that the number of times the end points ($min and $max) are returned
   #+ is considerably lower than when the correct formula is used.
   #  ---------------------------------------------------------------------

   spread=$((max-min))
   #  Omair Eshkenazi points out that this test is unnecessary,
   #+ since max and min have already been switched around.
   [ ${spread} -lt 0 ] && spread=$((0-spread))
   let spread+=divisibleBy
   randomBetweenAnswer=$(((RANDOM%spread)/divisibleBy*divisibleBy+min))   

   return 0

   #  However, Paulo Marcel Coelho Aragao points out that
   #+ when $max and $min are not divisible by $divisibleBy,
   #+ the formula fails.
   #
   #  He suggests instead the following formula:
   #    rnumber = $(((RANDOM%(max-min+1)+min)/divisibleBy*divisibleBy))
}

# Let's test the function.
min=-150
max=150
divisibleBy=1

# Now loop a large number of times to see what we get.
loopIt=1000   #  The script author suggests 100000,
              #+ but that takes a good long while.

for ((i=0; i<${loopIt}; ++i)); do
   randomBetween 150 -150
   coordinate=`echo "scale=2; $randomBetweenAnswer / 100.0" | bc -q`
   echo $coordinate
done

exit 0