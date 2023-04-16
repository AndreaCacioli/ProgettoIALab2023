%%%%%%%%%%%%%%  APPLICABILE  %%%%%%%%%%%%%%%%%

applicabile(nord, pos(Riga, Colonna)) :- 
  Riga > 1,
  RigaSopra is Riga - 1,
  \+occupata(pos(RigaSopra,Colonna)).

applicabile(ovest, pos(Riga, Colonna)) :- 
  Colonna > 1,
  ColonnaSinistra is Colonna - 1,
  \+occupata(pos(Riga,ColonnaSinistra)).

applicabile(sud, pos(Riga, Colonna)) :- 
  num_righe(X),
  Riga < X,
  RigaSotto is Riga + 1,
  \+occupata(pos(RigaSotto,Colonna)).

applicabile(est, pos(Riga, Colonna)) :- 
  num_colonne(X),
  Colonna < X,
  ColonnaDestra is Colonna + 1,
  \+occupata(pos(Riga,ColonnaDestra)).

%%%%%%%%%%%%%%  TRASFORMAZIONI  %%%%%%%%%%%%%%%%%

trasforma(nord, pos(Riga, Colonna), pos(RigaSopra, Colonna)) :-
  RigaSopra is Riga - 1 .

trasforma(sud, pos(Riga, Colonna), pos(RigaSotto, Colonna)) :-
  RigaSotto is Riga + 1 .

trasforma(est, pos(Riga, Colonna), pos(Riga, ColonnaDestra)) :-
  ColonnaDestra is Colonna + 1 .

trasforma(ovest, pos(Riga, Colonna), pos(Riga, ColonnaSinistra)) :-
  ColonnaSinistra is Colonna - 1 .

%%%%%%%%%%%%%%  COSTI  %%%%%%%%%%%%%%%%%

costo(nord, 1).
costo(est, 1).
costo(ovest, 1).
costo(sud, 1).
