partita(A, B) :- squadra(A), squadra(B), A != B.

gioca(G, A) :- giornata(G), assegna(G,A,_).
gioca(G, A) :- giornata(G), assegna(G,_,A).

:- squadra(A), giornata(G), not gioca(G,A).

% Teams from the same city cannot have a home game contemporarily
:- assegna(G, Squadra1, _), assegna(G, Squadra2, _), citta(Squadra1, C), citta(Squadra2, C), Squadra1 != Squadra2.


% Cannot have more than 2 straight home games, same goes for away games
% Vincolo che velocizza il tempo di esecuzione 🤔
:- giornata(G), assegna(G, Squadra1, _), assegna(G+1, Squadra1, _), assegna(G+2, Squadra1, _).
:- giornata(G), assegna(G, _, Squadra1), assegna(G+1, _, Squadra1), assegna(G+2, _, Squadra1).


#show assegna/3.
