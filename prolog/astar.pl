:- load_files('azioni.pl').
:- load_files('heuristic.pl').

start :- prova(Cammino), write(Cammino).

prova(Cammino):-
  iniziale(S0),
  risolvi([[S0,[], 0]],[],CamminoAlContrario),
  inverti(CamminoAlContrario,Cammino).


risolvi([[S,PathToS, _]|_],_,PathToS):-finale(S),!.

risolvi([[S,PathToS, FValue]|Coda],Visitati,Cammino):-
  findall(Az,applicabile(Az,S),ListaAzioniApplicabili),
  generaStatiFigli(S,ListaAzioniApplicabili,Visitati,PathToS,FValue,ListaNuoviStati),
  append(Coda,ListaNuoviStati,CodaDisordinata),
  sort(CodaDisordinata, CodaOrdinata),
  risolvi(CodaOrdinata,[S|Visitati],Cammino).

generaStatiFigli(_,[],_,_,_,[]):-!.

generaStatiFigli(S,[Az|AltreAzioni],Visitati,PathToS,OldFValue,[[Snuovo,[Az|PathToS], FValue]|ListaStati]):-
  trasforma(Az,S,Snuovo),
  costo(Az, Costo),
  finale(F),
  h(S,F,OldHvalue),
  h(Snuovo, F, NewHValue),
  FValue is OldFValue - OldHvalue + Costo + NewHValue,
  \+member(Snuovo,Visitati),!,
  generaStatiFigli(S,AltreAzioni,Visitati,PathToS,OldFValue,ListaStati).

generaStatiFigli(S,[_|AltreAzioni],Visitati,PathToS,FValue,ListaRis):-
  generaStatiFigli(S,AltreAzioni,Visitati,PathToS,FValue,ListaRis).

inverti(L,InvL):-inver(L,[],InvL).
inver([],Temp,Temp).
inver([H|T],Temp,Ris):-inver(T,[H|Temp],Ris).
