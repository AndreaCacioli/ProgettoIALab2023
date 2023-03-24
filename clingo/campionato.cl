%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Campionato.cl is a file to calculate match days, with some given requirements %%%
%%% A team is represented by a number                                             %%%
%%% There are 20 teams                                                            %%%          
%%% The first team is considered the home team, while the second is the away team %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% 20 Teams
squadra(celtics).
squadra(nets).
squadra(seventysixers).
squadra(bulls).
squadra(cavaliers).
squadra(mavericks).
squadra(nuggets).
squadra(pistons).
squadra(warriors).
squadra(rockets).
squadra(pacers).
squadra(clippers).
squadra(lakers).
squadra(heat).
squadra(grizzlies).
squadra(bucks).
squadra(timberwolves).
squadra(pelicans).
squadra(knicks).
squadra(thunder).

% 38 matches
giornata(1..38).

partita(A, B) :- squadra(A), squadra(B), A != B.

% Every match day has exactly 10 matches
10 { assegna(G, Squadra1, Squadra2): partita(Squadra1,Squadra2) } 10 :- giornata(G).

% Every match is played only once
1 { assegna(G, Squadra1, Squadra2): giornata(G)  } 1 :- partita(Squadra1,Squadra2).


% With this it takes forever while without only a minute.
%:- assegna(G, Squadra1, Squadra2), assegna(G, Squadra2, Squadra1).
:- assegna(G, Squadra1, Squadra2), assegna(G, Squadra1, Squadra3), Squadra2 != Squadra3.
:- assegna(G, Squadra2, Squadra1), assegna(G, Squadra3, Squadra1), Squadra2 != Squadra3.
:- assegna(G, Squadra2, Squadra1), assegna(G, Squadra1, Squadra3), Squadra2 != Squadra3.
:- assegna(G, Squadra1, Squadra2), assegna(G, Squadra3, Squadra1), Squadra2 != Squadra3.



% Can't have the same team play two different games (against different teams) on the same day
% Cannot have more than 2 straight home games, nor away games.
:- giornata(G), assegna(G, Squadra1, _), assegna(G+1, Squadra1, _), assegna(G+2, Squadra1, _).
:- giornata(G), assegna(G, _, Squadra1), assegna(G+1, _, Squadra1), assegna(G+2, _, Squadra1).


#show assegna/3.
