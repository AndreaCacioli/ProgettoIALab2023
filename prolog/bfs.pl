:- load_files('azioni.pl').

start :- prova(Cammino), write(Cammino).

prova(Cammino):-
   iniziale(S0),
   risolvi([[S0,[]]],[],CamminoAlContrario),
   inverti(CamminoAlContrario,Cammino).

% risolvi([[S,PathToS]|Coda],Visitati,Cammino):-

risolvi([[S,PathToS]|_],_,PathToS):-finale(S),!.
risolvi([[S,PathToS]|Coda],Visitati,Cammino):-
    findall(Az,applicabile(Az,S),ListaAzioniApplicabili),
    generaStatiFigli(S,ListaAzioniApplicabili,Visitati,PathToS,ListaNuoviStati),
    append(Coda,ListaNuoviStati,NuovaCoda),
    risolvi(NuovaCoda,[S|Visitati],Cammino).

generaStatiFigli(_,[],_,_,[]):-!.
generaStatiFigli(S,[Az|AltreAzioni],Visitati,PathToS,[[Snuovo,[Az|PathToS]]|ListaStati]):-
    trasforma(Az,S,Snuovo),
    \+member(Snuovo,Visitati),!,
    generaStatiFigli(S,AltreAzioni,Visitati,PathToS,ListaStati).
generaStatiFigli(S,[_|AltreAzioni],Visitati,PathToS,ListaRis):-
    generaStatiFigli(S,AltreAzioni,Visitati,PathToS,ListaRis).

%inverti([],[]).
%inverti([H|T],Res):-inverti(T,InvT),append(InvT,[H],Res).
inverti(L,InvL):-inver(L,[],InvL).
inver([],Temp,Temp).
inver([H|T],Temp,Ris):-inver(T,[H|Temp],Ris).

