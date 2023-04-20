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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; HANDLING QUEUES ;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate guess-queue
  (slot x)
  (slot y)
)

;Automatically dequeue guesses
(defrule guess-from-queue (declare (salience 50))
  ?guess <- (guess-queue (x ?x) (y ?y))
	(status (step ?s)(currently running))
  (not (guessed (x ?x) (y ?y)))
=>
  (retract ?guess)
  (assert (guessed (x ?x) (y ?y)))
  (assert (exec (step ?s) (action guess) (x ?x) (y ?y)))
  (pop-focus)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; MIDDLE PIECES ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;boat with a middle piece on the right side
(defrule rm 
	(status (step ?s)(currently running))
  (columns ?y)
  ?info <- (k-cell (x ?x) (y ?y) (content middle))
=>
  (retract ?info)
  (assert (guess-queue (x ?x) (y ?y)))
  (assert (guess-queue (x (- ?x 1)) (y ?y)))
  (assert (guess-queue (x (+ ?x 1)) (y ?y)))
	(printout t "Added [" ?x ", " ?y "] to the queue and the one above and below" crlf)
)

;boat with a middle piece on the left side
(defrule lm 
	(status (step ?s)(currently running))
  ?info <- (k-cell (x ?x) (y 0) (content middle))
=>
  (retract ?info)
  (assert (guess-queue (x ?x) (y 0)))
  (assert (guess-queue (x (- ?x 1)) (y 0)))
  (assert (guess-queue (x (+ ?x 1)) (y 0)))
	(printout t "Added [" ?x ", " 0 "] to the queue and the one above and below" crlf)
)

;boat with a middle piece on the top
(defrule tm
	(status (step ?s)(currently running))
  ?info <- (k-cell (x 0) (y ?y) (content middle))
=>
  (retract ?info)
  (assert (guess-queue (x 0) (y (- ?y 1))))
  (assert (guess-queue (x 0) (y ?y)))
  (assert (guess-queue (x 0) (y (+ ?y 1))))
	(printout t "Added [" 0 ", " ?y "] to the queue and the one left and right" crlf)
)


;boat with a middle piece on the bottom
(defrule bm
	(status (step ?s)(currently running))
  (rows ?x)
  ?info <- (k-cell (x ?x) (y ?y) (content middle))
=>
  (retract ?info)
  (assert (guess-queue (x ?x) (y (- ?y 1))))
  (assert (guess-queue (x ?x) (y ?y)))
  (assert (guess-queue (x ?x) (y (+ ?y 1))))
	(printout t "Added [" ?x ", " ?y "] to the queue and the one left and right" crlf)
)

;TODO reason about a middle piece in the middle of the board

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; TOP PIECES ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Every top piece surely has one below
;TODO It could have two or three
(defrule top
	(status (step ?s)(currently running))
  ?info <- (k-cell (x ?x) (y ?y) (content top))
=> 
  (retract ?info)
  (assert (guess-queue (x ?x) (y ?y)))
  (assert (guess-queue (x (+ ?x 1)) (y ?y)))
	(printout t "Added [" ?x ", " ?y "] to the queue and the one below" crlf)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; BOTTOM PIECES ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Every bottom piece surely has one above
;TODO It could have two or three
(defrule bottom
	(status (step ?s)(currently running))
  ?info <- (k-cell (x ?x) (y ?y) (content bot))
=> 
  (retract ?info)
  (assert (guess-queue (x ?x) (y ?y)))
  (assert (guess-queue (x (- ?x 1)) (y ?y)))
	(printout t "Added [" ?x ", " ?y "] to the queue and the one above" crlf)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; LEFT PIECES ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Every bottom piece surely has one above
;TODO It could have two or three
(defrule left
	(status (step ?s)(currently running))
  ?info <- (k-cell (x ?x) (y ?y) (content left))
=> 
  (retract ?info)
  (assert (guess-queue (x ?x) (y ?y)))
  (assert (guess-queue (x ?x) (y (+ ?y 1))))
	(printout t "Added [" ?x ", " ?y "] to the queue and the one right" crlf)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; RIGHT PIECES ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Every bottom piece surely has one above
;TODO It could have two or three
(defrule right
	(status (step ?s)(currently running))
  ?info <- (k-cell (x ?x) (y ?y) (content right))
=> 
  (retract ?info)
  (assert (guess-queue (x ?x) (y ?y)))
  (assert (guess-queue (x ?x) (y (- ?y 1))))
	(printout t "Added [" ?x ", " ?y "] to the queue and the one left" crlf)
)







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; STOPPING RULES ;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule reached-max-duration
  (maxduration ?m)
  (status (step ?m) (currently running))
=>
  (assert (exec (step ?m) (action solve)))
  (pop-focus)
)

(defrule finished-moves
  (moves (fires 0) (guesses 0))
  (status (step ?m) (currently running))
=>
  (assert (exec (step ?m) (action solve)))
  (pop-focus)
)

(defrule nothing-else-to-do (declare (salience -500))
  (status (step ?m) (currently running))
=>
  (printout t "Quitting because nothing else to do" crlf)
  (assert (exec (step ?m) (action solve)))
  (pop-focus)
)

