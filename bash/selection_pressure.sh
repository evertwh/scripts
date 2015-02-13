#!/bin/bash
#
# Calculate Fischer's exact test (FET) for likelihood of offspring vs fitness.
#
# Test requires 2x2 matrix. Classes we use: any offspring or none, above or below median
# fitness for a generation.
#

. ${HOME}/opt/lib/shflags

#define the command line options
DEFINE_boolean 'plotOnly' false "Don't regenerate data, just plot it"
DEFINE_string 'method' 'both' "Method to calculate selection pressure. One of 'fisher', 'spearman', both"

# Parse the flags
FLAGS "$@" || exit 1
eval set -- "${FLAGS_ARGV}"

do_fisher=${FLAGS_FALSE}
do_spearman=${FLAGS_FALSE}
if [ ${FLAGS_method} == 'fisher' ]
then
	do_fisher=${FLAGS_TRUE}
fi
if [ ${FLAGS_method} == 'spearman' ]
then
	do_spearman=${FLAGS_TRUE}
fi
if [ ${FLAGS_method} == 'both' ]
then
	do_spearman=${FLAGS_TRUE}
	do_fisher=${FLAGS_TRUE}
fi

BASEDIR=~/projects/workspace/SelectionPressure/output/

for experiment in $@
do
(
	if [ ${FLAGS_plotOnly} -eq ${FLAGS_FALSE} ]
	then
		if [ ${do_fisher} -eq ${FLAGS_TRUE} ]
		then
			echo "Fisher-based analysis of" $experiment
			tempfile=`mktemp FETXXXX`

			# Perform counts for Fischer's exact test
			# expected pressure-stats columns:
			# Time, Id, green puck count, red puck count, distance, offspring
			grep '^[0-9]*00 ' $experiment | gawk -f $BASEDIR/fishers_exact_test.awk  > $tempfile

			# Call R's Fisher's exact test for distance-based calcs
			rscript=`mktemp rscriptXXXX`

			echo 'theTest <- function(x) {' > $rscript
			echo '	result = fisher.test(matrix(c(x["A"],x["C"],x["B"],x["D"]),nrow=2))' >> $rscript
			echo '	cat(paste(x["time"], result["p.value"],"\n", sep=" "))' >> $rscript
			echo '}' >> $rscript
			echo "myData <- read.table(\"$tempfile\", sep=\" \", col.names=c(\"time\", \"A\", \"B\", \"C\", \"D\"))" >> $rscript
			echo 'apply(myData, 1, theTest)' >> $rscript

			R --no-save --slave < $rscript | sort -n > $experiment.FET.txt

			rm $tempfile
			rm $rscript
		fi

		if [ ${do_spearman} -eq ${FLAGS_TRUE} ]
		then
			echo "spearman-based analysis of" $experiment

			tempfile=`mktemp spearmanXXXX`
			grep '^[0-9]*00 ' $experiment > $tempfile

			rscript=`mktemp rscriptXXXX`

			echo 'names <- c("generation", "Id", "offspring", "fitness")' > $rscript
			echo "myData <- read.table(\"$tempfile\", sep=" ", col.names=names)" >> $rscript
			echo 'test <- function(x) { cor(x$offspring, x$fitness, method="spearman") }' >> $rscript
			echo 'coefs <- by(myData, myData$generation, test)' >> $rscript
			echo 'cat(paste(names(coefs), coefs), sep = "\n")' >> $rscript

			R --no-save --slave < $rscript > $experiment.spearman.txt

			rm $tempfile
			rm $rscript
		fi
	fi

	if [ ${do_fisher} -eq ${FLAGS_TRUE} ]
	then
		gnuplot -e "set term pngcairo; set output '$experiment.selective-pressure.fisher.png'; input='$experiment.FET.txt';set title '$experiment'" $BASEDIR/fisher.gpl
	fi

	if [ ${do_spearman} -eq ${FLAGS_TRUE} ]
	then
		gnuplot -e "set term pngcairo; set output '$experiment.selective-pressure.spearman.png'; input='$experiment.spearman.txt';set title '$experiment'" $BASEDIR/spearman.gpl
	fi
) &
done

wait

echo "Analysis complete"