runShort:
	clingo -t 12 ./clingo/campionato.cl ./clingo/campionato_vincoli.cl > ./clingo/out.txt && say 'done' && osascript -e 'display notification "Clingo has found an answer" with title "Done"'

runShort:
	clingo -t 12 ./clingo/campionato_full.cl ./clingo/campionato_vincoli.cl > ./clingo/out.txt && say 'done' && osascript -e 'display notification "Clingo has found an answer" with title "Done"'
