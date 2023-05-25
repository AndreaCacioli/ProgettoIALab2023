partita(A, B) :- squadra(A), squadra(B), A != B.

% Teams from the same city cannot have a home game contemporarily
:- assegna(G, Squadra1, _), assegna(G, Squadra2, _), citta(Squadra1, C), citta(Squadra2, C), Squadra1 != Squadra2.

1 { assegna(G, Squadra1, Squadra2): giornata(G)  } 1 :- partita(Squadra1,Squadra2).

% Cannot have more than 2 straight home games, same goes for away games
% Vincolo che velocizza il tempo di esecuzione 🤔
:- assegna(G, Squadra1, _), assegna(G+1, Squadra1, _), assegna(G+2, Squadra1, _).
:- assegna(G, _, Squadra1), assegna(G+1, _, Squadra1), assegna(G+2, _, Squadra1).


#show assegna/3.

:- assegna(G, Squadra1, Squadra2), assegna(G, Squadra1, Squadra3), Squadra2 != Squadra3.
:- assegna(G, Squadra2, Squadra1), assegna(G, Squadra3, Squadra1), Squadra2 != Squadra3.
:- assegna(G, Squadra2, Squadra1), assegna(G, Squadra1, Squadra3), Squadra2 != Squadra3.


%%%%%%% UNUSED CONSTRAINTS %%%%%%%%%

% gioca(G, A) :- assegna(G,A,_).
% gioca(G, A) :- assegna(G,_,A).
% :- squadra(A), giornata(G), not gioca(G,A).

% Vincolo alternativo ad aggregato
% :- assegna(G1, Squadra1, Squadra2), assegna(G2, Squadra1, Squadra2), G1 <> G2.

% :- assegna(G, Squadra1, Squadra2), assegna(G, Squadra2, Squadra1).
% :- assegna(G, Squadra1, Squadra2), assegna(G, Squadra3, Squadra1), Squadra2 != Squadra3.
