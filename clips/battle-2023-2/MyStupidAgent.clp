(defmodule AGENT (import MAIN ?ALL) (import ENV ?ALL) (export ?ALL))

(defrule stupidity (declare (salience 10))
	(status (step ?s)(currently running))
	(moves (fires 0) (guesses ?ng&:(> ?ng 0)))
=>
  (assert (exec (step ?s) (action guess) (x 3) (y 3)))
  (pop-focus)

)
