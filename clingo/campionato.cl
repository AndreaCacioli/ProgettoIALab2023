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


% 38 matches ( (NumeroSquadre - 1) * 2)
giornata(1..26).


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


assegna(1,bulls,celtics).


% Every match day has exactly 10 matches (NumeroSquadre / 2)
7 { assegna(G, Squadra1, Squadra2): partita(Squadra1,Squadra2) } 7 :- giornata(G).

% La distanza tra due partite di andata e di ritorno deve essere di almeno 10 giornate 
% Vincolo abbastanza pesante
% :- assegna(G1, Squadra1, Squadra2), assegna(G2, Squadra2, Squadra1), |G1 - G2| < 6.
