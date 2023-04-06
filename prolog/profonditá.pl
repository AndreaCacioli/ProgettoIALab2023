ini :- 
  retractall(maxProf(_)),
  assert(maxProf(0)),
  maxProf(X),
  write("Starting at maxDepth = "), write(X), write("\n").

inc :-
  maxProf(X),
  retractall(maxProf(_)),
  Y is X + 1,
  assert(maxProf(Y)),
  write("Now maxDepth = "), write(Y), write("\n").

start :-
  ini,
  prova(Cammino),
  write(Cammino).

prova(Cammino) :-
  iniziale(S),
  risolvi(S,Cammino,[])
  .

prova(Cammino) :-
  inc,
  prova(Cammino).

risolvi(S,[], _) :- finale(S), write("solution found\n").

risolvi(S,[ Azione | ListaNuova ], Visitati) :- 
  applicabile(Azione, S), 
  trasforma(Azione, S, Snuovo),
  \+member(Snuovo,Visitati),
  length(Visitati, Prof),
  write("Visitati: "), write(Visitati), write("\n"),
  maxProf(X),
  Prof < X,
  write("Current Depth: "), write(Prof), write("\n"),
  write("Current Max Depth: "), write(X), write("\n"),
  risolvi(Snuovo, ListaNuova, [S | Visitati]).
