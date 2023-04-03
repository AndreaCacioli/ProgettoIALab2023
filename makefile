run:
	clingo -t 8 ./clingo/campionato.cl > ./clingo/out.txt &&  osascript -e 'display notification "Clingo has found an answer" with title "Done"'
