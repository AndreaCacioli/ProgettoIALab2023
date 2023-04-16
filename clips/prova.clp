;; Base Case

(defrule factorial
  (fact_run ?x)
  =>
  (assert 
    (fact ?x 1)
  )
)

(defrule fact_helper
  ?factnumber <- (fact ?x ?y)
  (test (> ?x 0))
=>
  (retract ?factnumber)
  (assert 
    (fact (- ?x 1) (* ?x ?y ))
  )
)

(defrule fact_print
  (fact 0 ?y)
  (fact_run ?x)
=>
  (printout t "The factorial of " ?x " is " ?y crlf)
)


