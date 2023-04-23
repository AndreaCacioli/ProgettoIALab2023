(defmodule AGENT (import MAIN ?ALL) (import ENV ?ALL) (export ?ALL))

(deftemplate guessed 
  (slot x)
  (slot y)
)

(deftemplate fired 
  (slot x)
  (slot y)
)

(deftemplate water
  (slot x)
  (slot y)
)

(deftemplate plausible-cell
  (slot x)
  (slot y)
)

;Very useful template used to spare some fires if we are lucky and immediately fire on a part of the boat
(deftemplate one-or-the-other
  (slot x1)
  (slot y1)

  (slot x2)
  (slot y2)
)

(deftemplate guess-queue
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
(defrule fire-plausible-cells (declare (salience -10))
  (moves (fires ?fires&:(> ?fires 0)))
  ?plausibleFact <- (plausible-cell (x ?x) (y ?y))
  (not (fired (x ?x) (y ?y)))
	(status (step ?s)(currently running))
=>
  (retract ?plausibleFact)
  (assert (exec (step ?s) (action fire) (x ?x) (y ?y)))
  (assert (fired (x ?x) (y ?y)))
  (printout t "Fired [" ?x ", " ?y "] as it was plausible" crlf)
  (pop-focus)
)

;Important rule to spare some fires
(defrule found-one-remove-the-other1 (declare (salience 15))
 (fired (x ?x) (y ?y)) 
 (k-cell (x ?x) (y ?y) (content ~water))
 ?noNeed <- (one-or-the-other (x1 ?x) (y1 ?y) (x2 ?x2) (y2 ?y2))
 ?notPlausible <- (plausible-cell (x ?x2) (y ?y2))
=>
  (retract ?notPlausible)
  (retract ?noNeed)
  (assert (water (x ?x2) (y ?y2)))
)

;Important rule to spare some fires
(defrule found-one-remove-the-other1 (declare (salience 15))
 (fired (x ?x) (y ?y)) 
 (k-cell (x ?x) (y ?y) (content ~water))
 ?noNeed <- (one-or-the-other (x1 ?x1) (y1 ?y1) (x2 ?x) (y2 ?y))
 ?notPlausible <- (plausible-cell (x ?x1) (y ?y1))
=>
  (retract ?notPlausible)
  (retract ?noNeed)
  (assert (water (x ?x1) (y ?y1)))
)

;Automatically dequeue guesses
(defrule guess-from-queue (declare (salience 50))
  (moves (guesses ?guesses&:(> ?guesses 0) ))
  ?guess <- (guess-queue (x ?x) (y ?y))
	(status (step ?s)(currently running))
  (not (guessed (x ?x) (y ?y)))
=>
  (retract ?guess)
  (assert (guessed (x ?x) (y ?y)))
  (assert (exec (step ?s) (action guess) (x ?x) (y ?y)))
  (pop-focus)
)

;If we already used information on a cell we do not use it again
(defrule information-already-used
  ?guess <- (guess-queue (x ?x) (y ?y))
  (guessed (x ?x) (y ?y))
=> 
  (retract ?guess)
	(printout t "Duplicate guess information [" ?x ", " ?y "] and popped from the queue." crlf)
)

;Automatically spawn water information when fire goes bad
(defrule spawn-water
  ?command <- (exec (action fire) (x ?x) (y ?y))
  (not (k-cell (x ?x) (y ?y)))
  (not (guessed (x ?x) (y ?y)))
=>
  (retract ?command)
  (assert (water (x ?x) (y ?y)))
	(printout t "Fire action produced a water element [" ?x ", " ?y "]" crlf)
)

;automatically remove water information if we asserted out of bounds
(defrule clean-water-x0
  ?waterfact <- (water (x ?x&:(< ?x 0)))
=>
  (retract ?waterfact)
)
(defrule clean-water-xrows
  (rows ?rows)
  ?waterfact <- (water (x ?x&:(> ?x ?rows)))
=>
  (retract ?waterfact)
)
(defrule clean-water-y0
  ?waterfact <- (water (y ?y&:(< ?y 0)))
=>
  (retract ?waterfact)
)
(defrule clean-water-ycols
  (columns ?cols)
  ?waterfact <- (water (y ?y&:(> ?y ?cols)))
=>
  (retract ?waterfact)
)

;automatically remove plausible information if we asserted out of bounds
(defrule clean-plausible-x0
  ?plausible <- (plausible-cell (x ?x&:(< ?x 0)))
=>
  (retract ?plausible)
)
(defrule clean-plausible-xrows
  (rows ?rows)
  ?plausible <- (plausible-cell (x ?x&:(> ?x ?rows)))
=>
  (retract ?plausible)
)
(defrule clean-plausible-y0
  ?plausible <- (plausible-cell (y ?y&:(< ?y 0)))
=>
  (retract ?plausible)
)
(defrule clean-plausible-ycols
  (columns ?cols)
  ?plausible <- (plausible-cell (y ?y&:(> ?y ?cols)))
=>
  (retract ?plausible)
)

(defrule clean-one-or-the-other-1 (declare (salience -5))
  ?one <- (one-or-the-other
    (x1 ?x1)
    (y1 ?y1)

    (x2 ?x2)
    (y2 ?y2)
  )
  (plausible-cell (x ?x1) (y ?y1))
  (not (plausible-cell (x ?x2) (y ?y2)))
=> 
  (retract ?one)
)

(defrule clean-one-or-the-other-2 (declare (salience -5))
  ?one <- (one-or-the-other
    (x1 ?x1)
    (y1 ?y1)

    (x2 ?x2)
    (y2 ?y2)
  )
  (plausible-cell (x ?x2) (y ?y2))
  (not (plausible-cell (x ?x1) (y ?y1)))
=> 
  (retract ?one)
)

;Do not fire on already fired cells
(defrule no-fire-on-fired
 (fired (x ?x) (y ?y))
 ?plausible <- (plausible-cell (x ?x) (y ?y))
=>
 (retract ?plausible)
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
  ;left side is water
  (assert (water (x ?x) (y (- ?y 1))))
  (assert (water (x (- ?x 1)) (y (- ?y 1))))
  (assert (water (x (+ ?x 1)) (y (- ?y 1))))
  ;we might have a 4 length so it is plausible to add either (x - 2) or (x + 2)
  (assert (plausible-cell (x (- ?x 2))(y ?y)))
  (assert (plausible-cell (x (+ ?x 2))(y ?y)))
  (assert (one-or-the-other 
    (x1 (- ?x 2)) (y1 ?y)
    (x2 (+ ?x 2)) (y2 ?y)
  ))
	(printout t "Added [" ?x ", " ?y "] to the GUESS queue and the one above and below" crlf)
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
  ;right side is water
  (assert (water (x ?x) (y 1)))
  (assert (water (x (- ?x 1)) (y 1)))
  (assert (water (x (+ ?x 1)) (y 1)))
  ;we might have a 4 length so it is plausible to add either (x - 2) or (x + 2)
  (assert (plausible-cell (x (- ?x 2))(y 0)))
  (assert (plausible-cell (x (+ ?x 2))(y 0)))
  (assert (one-or-the-other 
    (x1 (- ?x 2)) (y1 0)
    (x2 (+ ?x 2)) (y2 0)
  ))
	(printout t "Added [" ?x ", " 0 "] to the GUESS queue and the one above and below" crlf)
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
  ;below side is water
  (assert (water (x 1) (y (- ?y 1))))
  (assert (water (x 1) (y (+ ?y 1))))
  (assert (water (x 1) (y  ?y)))
  ;we might have a 4 length so it is plausible to add either (y - 2) or (y + 2)
  (assert (plausible-cell (x 0)(y (- ?y 2))))
  (assert (plausible-cell (x 0)(y (+ ?y 2))))
  (assert (one-or-the-other 
    (x1 0) (y1 (- ?y 2))
    (x2 0) (y2 (+ ?y 2))
  ))
	(printout t "Added [" 0 ", " ?y "] to the GUESS queue and the one left and right" crlf)
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
  ;above side is water
  (assert (water (x (- ?x 1)) (y (- ?y 1))))
  (assert (water (x (- ?x 1)) (y (+ ?y 1))))
  (assert (water (x (- ?x 1)) (y  ?y)))
  ;we might have a 4 length so it is plausible to add either (y - 2) or (y + 2)
  (assert (plausible-cell (x ?x)(y (- ?y 2))))
  (assert (plausible-cell (x ?x)(y (+ ?y 2))))
  (assert (one-or-the-other 
    (x1 ?x) (y1 (- ?y 2))
    (x2 ?x) (y2 (+ ?y 2))
  ))
	(printout t "Added [" ?x ", " ?y "] to the GUESS queue and the one left and right" crlf)
)

; MIDDLE PIECES IN THE MIDDLE OF THE MAP
(defrule middle-with-water-above 
	(status (step ?s)(currently running))
  ?info <- (k-cell (x ?x) (y ?y) (content middle))
  (water (x ?x1&:(= ?x1 (- ?x 1))) (y ?y))
=>
  ;Do the same as the middle piece on the top
  (retract ?info)
  (assert (guess-queue (x ?x) (y (- ?y 1))))
  (assert (guess-queue (x ?x) (y ?y)))
  (assert (guess-queue (x ?x) (y (+ ?y 1))))
  ;below side is water
  (assert (water (x (+ ?x 1)) (y (- ?y 1))))
  (assert (water (x (+ ?x 1)) (y (+ ?y 1))))
  (assert (water (x (+ ?x 1)) (y  ?y)))
  ;we might have a 4 length so it is plausible to add either (y - 2) or (y + 2)
  (assert (plausible-cell (x ?x)(y (- ?y 2))))
  (assert (plausible-cell (x ?x)(y (+ ?y 2))))
  (assert (one-or-the-other 
    (x1 ?x) (y1 (- ?y 2))
    (x2 ?x) (y2 (+ ?y 2))
  ))
	(printout t "Added [" 0 ", " ?y "] to the GUESS queue and the one left and right" crlf)
)

(defrule middle-with-water-below 
	(status (step ?s)(currently running))
  ?info <- (k-cell (x ?x) (y ?y) (content middle))
  (water (x ?x1&:(= ?x1 (+ ?x 1))) (y ?y))
=>
  ;Do the same as the middle piece on the bottom
  (retract ?info)
  (assert (guess-queue (x ?x) (y (- ?y 1))))
  (assert (guess-queue (x ?x) (y ?y)))
  (assert (guess-queue (x ?x) (y (+ ?y 1))))
  ;above side is water
  (assert (water (x (- ?x 1)) (y (- ?y 1))))
  (assert (water (x (- ?x 1)) (y (+ ?y 1))))
  (assert (water (x (- ?x 1)) (y  ?y)))
  ;we might have a 4 length so it is plausible to add either (y - 2) or (y + 2)
  (assert (plausible-cell (x ?x)(y (- ?y 2))))
  (assert (plausible-cell (x ?x)(y (+ ?y 2))))
  (assert (one-or-the-other 
    (x1 ?x) (y1 (- ?y 2))
    (x2 ?x) (y2 (+ ?y 2))
  ))
	(printout t "Added [" ?x ", " ?y "] to the GUESS queue and the one left and right" crlf)
)

(defrule middle-with-water-left 
	(status (step ?s)(currently running))
  ?info <- (k-cell (x ?x) (y ?y) (content middle))
  (water (x ?x) (y ?y1&:(= ?y1 (- ?y 1))))
=>
  ;Do the same as the middle piece on the left
  (retract ?info)
  (assert (guess-queue (x ?x) (y ?y)))
  (assert (guess-queue (x (- ?x 1)) (y ?y)))
  (assert (guess-queue (x (+ ?x 1)) (y ?y)))
  ;right side is water
  (assert (water (x ?x) (y (+ ?y 1))))
  (assert (water (x (- ?x 1)) (y (+ ?y 1))))
  (assert (water (x (+ ?x 1)) (y (+ ?y 1))))
  ;we might have a 4 length so it is plausible to add either (x - 2) or (x + 2)
  (assert (plausible-cell (x (- ?x 2))(y ?y)))
  (assert (plausible-cell (x (+ ?x 2))(y ?y)))
  (assert (one-or-the-other 
    (x1 (- ?x 2)) (y1 ?y)
    (x2 (+ ?x 2)) (y2 ?y)
  ))
	(printout t "Added [" ?x ", " 0 "] to the GUESS queue and the one above and below" crlf)
)

(defrule middle-with-water-right 
	(status (step ?s)(currently running))
  ?info <- (k-cell (x ?x) (y ?y) (content middle))
  (water (x ?x) (y ?y1&:(= ?y1 (+ ?y 1))))
=>
  ;Do the same as the middle piece on the right
  (retract ?info)
  (assert (guess-queue (x ?x) (y ?y)))
  (assert (guess-queue (x (- ?x 1)) (y ?y)))
  (assert (guess-queue (x (+ ?x 1)) (y ?y)))
  ;left side is water
  (assert (water (x ?x) (y (- ?y 1))))
  (assert (water (x (- ?x 1)) (y (- ?y 1))))
  (assert (water (x (+ ?x 1)) (y (- ?y 1))))
  ;we might have a 4 length so it is plausible to add either (x - 2) or (x + 2)
  (assert (plausible-cell (x (- ?x 2))(y ?y)))
  (assert (plausible-cell (x (+ ?x 2))(y ?y)))
  (assert (one-or-the-other 
    (x1 (- ?x 2)) (y1 ?y)
    (x2 (+ ?x 2)) (y2 ?y)
  ))
	(printout t "Added [" ?x ", " ?y "] to the GUESS queue and the one above and below" crlf)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; TOP PIECES ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Every top piece surely has one below
;To avoid missing a fire we fire the one we already guessed and see if the boat ends there or it goes on
(defrule top
	(status (step ?s)(currently running))
  ?info <- (k-cell (x ?x) (y ?y) (content top))
=> 
  (retract ?info)
  (assert (guess-queue (x ?x) (y ?y)))
  (assert (guess-queue (x (+ ?x 1)) (y ?y)))
  ;Water all around (No Corners)
  (assert (water (x ?x) (y (- ?y 1))))
  (assert (water (x ?x) (y (+ ?y 1))))
  (assert (water (x (- ?x 1)) (y ?y)))
  ;We already know that this is a fire-ok but we might find a middle there
  (assert (plausible-cell (x (+ ?x 1)) (y ?y)))
	(printout t "Added [" ?x ", " ?y "] to the GUESS queue and the one below" crlf)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; BOTTOM PIECES ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Every bottom piece surely has one above
(defrule bottom
	(status (step ?s)(currently running))
  ?info <- (k-cell (x ?x) (y ?y) (content bot))
=> 
  (retract ?info)
  (assert (guess-queue (x ?x) (y ?y)))
  (assert (guess-queue (x (- ?x 1)) (y ?y)))
  ;Water all around (No Corners)
  (assert (water (x ?x) (y (- ?y 1))))
  (assert (water (x ?x) (y (+ ?y 1))))
  (assert (water (x (+ ?x 1)) (y ?y)))
  ;We already know that this is a fire-ok but we might find a middle there
  (assert (plausible-cell (x (- ?x 1)) (y ?y)))
	(printout t "Added [" ?x ", " ?y "] to the GUESS queue and the one above" crlf)
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
  ;Water all around (No Corners)
  (assert (water (x (+ ?x 1)) (y ?y)))
  (assert (water (x (- ?x 1)) (y ?y)))
  (assert (water (x ?x) (y (- ?y 1))))
  ;We already know that this is a fire-ok but we might find a middle there
  (assert (plausible-cell (x ?x) (y (+ ?y 1))))
	(printout t "Added [" ?x ", " ?y "] to the GUESS queue and the one right" crlf)
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
  ;Water all around (No Corners)
  (assert (water (x (+ ?x 1)) (y ?y)))
  (assert (water (x (- ?x 1)) (y ?y)))
  (assert (water (x ?x) (y (+ ?y 1))))
  ;We already know that this is a fire-ok but we might find a middle there
  (assert (plausible-cell (x ?x) (y (- ?y 1))))
	(printout t "Added [" ?x ", " ?y "] to the GUESS queue and the one left" crlf)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; STOPPING RULES ;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule reached-max-duration
  (maxduration ?m)
  (status (step ?m) (currently running))
=>
  (assert (exec (step ?m) (action solve)))
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

