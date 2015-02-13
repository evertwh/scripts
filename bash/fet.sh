				# Generate script to call R's Fisher's exact test for calculation
				rscript=`mktemp rscriptXXXX`

#FIXME: somehow, the code below adds 'NULL' as first line in some cases, e.g. with run 0.1.5.63
				echo 'theTest <- function(x) {' > $rscript
				echo '	result = fisher.test(matrix(c(x["A"],x["C"],x["B"],x["D"]),nrow=2))' >> $rscript
				echo '	cat(paste(x["time"], result["p.value"],"\n", sep=" "))' >> $rscript
				echo '}' >> $rscript
				echo "myData <- read.table(\"$1\", sep=\" \", col.names=c(\"time\", \"A\", \"B\", \"C\", \"D\"))" >> $rscript
				echo 'apply(myData, 1, theTest)' >> $rscript

				R --no-save --slave < $rscript | sort -n
