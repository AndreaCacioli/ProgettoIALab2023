%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Campionato.cl is a file to calculate match days, with some given requirements %%%
%%% A team is represented by a number                                             %%%
%%% There are 20 teams                                                            %%%          
%%% The first team is considered the home team, while the second is the away team %%%
%%%                                                                               %%%
%%% Stats:                                                                        %%%
%%%     With 10 teams and 1 conflict  -  Execution time is around .01 seconds     %%%
%%%     With 12 teams and 1 conflict  -  Execution time is around 11 seconds      %%%
%%%     With 12 teams and 2 conflicts  -  Execution time is around 58 seconds     %%%
%%%     With 14 teams and 1 conflict  -  Execution time is around 2 min: 33 sec   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% OBBLIGATORIO 1

% 20 Teams
squadra(celtics).
squadra(nets).
squadra(seventysixers).
squadra(bulls).
squadra(cavaliers).
squadra(mavericks).
squadra(lakers).
squadra(pistons).
squadra(warriors).
squadra(clippers).
squadra(rockets).
squadra(pacers).

squadra(heat).
squadra(nuggets).

%  squadra(grizzlies).
%  squadra(bucks).
%  squadra(timberwolves).
%  squadra(pelicans).
%  squadra(knicks).
%  squadra(thunder).



% OBBLIGATORIO 2

% 38 matches ( (NumeroSquadre - 1) * 2)
giornata(1..26).



% OBBLIGATORIO 3

citta(celtics, boston).
citta(nets, brooklyn).
citta(seventysixers, philadelphia).
citta(bulls, chicago).
citta(cavaliers, cleveland).
citta(mavericks, dallas).
citta(lakers, los_angeles).
citta(pistons, detroit).
citta(warriors, san_francisco).
citta(clippers, los_angeles).
citta(rockets, huston).
citta(pacers, indiana).
citta(heat, miami).
citta(nuggets, denver).



% OBBLIGATORIO 4

partita(A, B) :- squadra(A), squadra(B), A != B.

% Every match day has exactly 10 matches (NumeroSquadre / 2)
7 { assegna(G, Squadra1, Squadra2): partita(Squadra1,Squadra2) } 7 :- giornata(G).

% Every match is played only once
1 { assegna(G, Squadra1, Squadra2): giornata(G)  } 1 :- partita(Squadra1,Squadra2).

% Can't have the same team play two different games (against different teams) on the same day
:- assegna(G, Squadra1, Squadra2), assegna(G, Squadra2, Squadra1).
:- assegna(G, Squadra1, Squadra2), assegna(G, Squadra1, Squadra3), Squadra2 != Squadra3.
:- assegna(G, Squadra2, Squadra1), assegna(G, Squadra3, Squadra1), Squadra2 != Squadra3.
:- assegna(G, Squadra2, Squadra1), assegna(G, Squadra1, Squadra3), Squadra2 != Squadra3.
:- assegna(G, Squadra1, Squadra2), assegna(G, Squadra3, Squadra1), Squadra2 != Squadra3.

%  This one looks like the slower one ( about 30 times compared to the previous)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   quantePartiteH(G, S, Cont) :-
%     giornata(G), squadra(S), Cont = #count{AltraS: assegna(G, S, AltraS)}.
%   
%   quantePartiteA(G, S, Cont) :-
%     giornata(G), squadra(S), Cont = #count{AltraS: assegna(G, AltraS, S)}.
%   
%   quantePartite(G, S, Cont) :-
%     quantePartiteA(G, S, A), quantePartiteH(G,S,B), Cont = A + B.
%   
%   :- quantePartite(G,S, Cont), Cont != 1.
%   
%   #show quantePartite/3.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%OBBLIGATORIO 5

% Teams from the same city cannot have a home game contemporarily
% :- assegna(G, clippers, _), assegna(G, lakers, _).
:- assegna(G, Squadra1, _), assegna(G, Squadra2, _), citta(Squadra1, C), citta(Squadra2, C), Squadra1 != Squadra2.



% FACOLTATIVO 1 

% Cannot have more than 2 straight home games, same goes for away games
:- giornata(G), assegna(G, Squadra1, _), assegna(G+1, Squadra1, _), assegna(G+2, Squadra1, _).
:- giornata(G), assegna(G, _, Squadra1), assegna(G+1, _, Squadra1), assegna(G+2, _, Squadra1).



% FACOLTATIVO 2

% La distanza tra due partite di andata e di ritorno deve essere di almeno 10 giornate (0.25 * numeroGiornate : parte intera)
:- assegna(G1, Squadra1, Squadra2), assegna(G2, Squadra2, Squadra1), |G1 - G2| < 6.

#show assegna/3.
