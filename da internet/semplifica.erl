- module (semplifica).
- export ([moltiplica_uno/1,moltiplica_zero/1,somma_zero/1]).

moltiplica_zero ({mul,_,{num,0}}) ->
    {num,0};
moltiplica_zero({mul,{num,0},_}) ->
    {num,0};
moltiplica_zero(Exp) ->
    {Exp}.

somma_zero({sum,Exp,{num,0}}) ->
    {Exp};
somma_zero({sum,{num,0},Exp}) ->
    {Exp};
somma_zero(Exp) ->
    {Exp}.

moltiplica_uno({mul,Exp,{num,1}}) ->
    Exp;
moltiplica_uno({mul,{num,1}, Exp}) ->
    Exp;
moltiplica_uno(Exp) ->
    Exp.