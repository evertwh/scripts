for run in {1..64}
do
	for problem in 0 1
	do
		for scheme in 0 1
		do
			for tournament in 2 5 10
			do
			(
				log=/Volumes/Slartibartfast/experiments/selection_pressure/results/$problem.$scheme.$tournament.$run
				../Debug/SelectionPressure --s $scheme --t $tournament --p $problem --l $log
				bash selection_pressure.sh $log
			)&
			done
		done

		(
		log=/Volumes/Slartibartfast/experiments/selection_pressure/results/$problem.2.0.$run
		../Debug/SelectionPressure --s 2 --p $problem --l $log
		bash selection_pressure.sh $log
		)&
	done

	wait
done
