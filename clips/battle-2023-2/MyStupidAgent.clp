(defmodule AGENT (import MAIN ?ALL) (import ENV ?ALL) (export ?ALL))

;; TODO probably remove focus MAIN or focus ENV and replace with pop focus

(deftemplate guessed 
  (slot x)
  (slot y)
)

(deffacts board-size
  (rows 9)
  (columns 9)
)

(defrule print-what-i-know-since-the-beginning (declare(salience 10))
	(k-cell (x ?x) (y ?y) (content ?t) )
=>
	(printout t "I know that cell [" ?x ", " ?y "] contains " ?t "." crlf)
)

;boat with a middle piece on the right side
(defrule rm 
	(status (step ?s)(currently running))
  (columns ?y)
  ?info <- (k-cell (x ?x) (y ?y) (content middle))

=>

  (retract ?info)
  (assert (guessed (x ?x) (y ?y)))
  (assert (guessed (x (- ?x 1)) (y ?y)))
  (assert (guessed (x (+ ?x 1)) (y ?y)))
  (assert (exec (step ?s) (action guess) (x (- ?x 1)) (y ?y)))
  (assert (exec (step (+ ?s 1)) (action guess) (x (+ ?x 1)) (y ?y)))
  (assert (exec (step (+ ?s 2)) (action guess) (x  ?x) (y ?y)))
	(printout t "guessed [" ?x ", " ?y "] and the one above and below " crlf)
  (focus MAIN)
)

;boat with a middle piece on the left side
(defrule lm 
	(status (step ?s)(currently running))
  ?info <- (k-cell (x ?x) (y 0) (content middle))

=>

  (retract ?info)
  (assert (guessed (x ?x) (y 0)))
  (assert (guessed (x (- ?x 1)) (y 0)))
  (assert (guessed (x (+ ?x 1)) (y 0)))
  (assert (exec (step ?s) (action guess) (x (- ?x 1)) (y 0)))
  (assert (exec (step (+ ?s 1)) (action guess) (x (+ ?x 1)) (y 0)))
  (assert (exec (step (+ ?s 2)) (action guess) (x  ?x) (y 0)))
	(printout t "guessed [" ?x ", " 0 "] and the one above and below " crlf)
  (focus MAIN)
)

(defrule reached-max-duration
  (maxduration ?m)
  (status (step ?m) (currently running))

=>
  (assert (exec (step ?m) (action solve)))
  (focus ENV)
)
