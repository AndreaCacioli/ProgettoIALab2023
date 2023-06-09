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
squadra(grizzlies).
squadra(bucks).
squadra(timberwolves).
squadra(pelicans).
squadra(knicks).
squadra(thunder).

giornata(1..38).


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
citta(grizzlies, memphis).
citta(bucks, milwaukee).
citta(timberwolves, minnesota).
citta(pelicans, new_orleans).
citta(knicks, new_york).
citta(thunder, oklahoma_city).

assegna(1, bulls, celtics).

% Le andate e i ritorni sono separati.
:- assegna(G1, Squadra1, Squadra2), assegna(G2, Squadra2, Squadra1), G1 < 19, G2 < 19.
:- assegna(G1, Squadra1, Squadra2), assegna(G2, Squadra2, Squadra1), G1 > 19, G2 > 19.

% Every match day has exactly 10 matches (NumeroSquadre / 2)
10 { assegna(G, Squadra1, Squadra2): partita(Squadra1,Squadra2) } 10 :- giornata(G).

% La distanza tra due partite di andata e di ritorno deve essere di almeno 10 giornate 
% Vincolo abbastanza pesante
% :- assegna(G1, Squadra1, Squadra2), assegna(G2, Squadra2, Squadra1), |G1 - G2| < 10.
