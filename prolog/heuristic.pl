h(pos(X,Y), pos(X1,Y1), Z) :- 
  abs(X - X1, Diff1),
  abs(Y - Y1, Diff2),
  Z is Diff1 + Diff2.

%   f(Iniziale, Finale, Valore) :- 
%     h(Iniziale, Finale, V1),
%     g(Iniziale, V2),
%     Valore is V1 + V2.
