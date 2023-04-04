run14:
	-clingo -t 12 ./clingo/campionato14.cl ./clingo/campionato_vincoli.cl > ./clingo/out.txt 
	say 'done' 
	osascript -e 'display notification "Clingo has found an answer" with title "Done"'

run16:
	-clingo -t 12 ./clingo/campionato16.cl ./clingo/campionato_vincoli.cl > ./clingo/out.txt 
	say 'done' 
	osascript -e 'display notification "Clingo has found an answer" with title "Done"'

run18:
	-clingo -t 12 ./clingo/campionato18.cl ./clingo/campionato_vincoli.cl > ./clingo/out.txt 
	say 'done' 
	osascript -e 'display notification "Clingo has found an answer" with title "Done"'

run20:
	-clingo -t 12 ./clingo/campionato20.cl ./clingo/campionato_vincoli.cl > ./clingo/out.txt 
	say 'done' 
	osascript -e 'display notification "Clingo has found an answer" with title "Done"'
