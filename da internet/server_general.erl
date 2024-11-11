- module(server_general).
- export([start/0]).

start() -> 
    spawn(server_general,loop(),[]).%modulo, funzione che gestisce il processo spawnato, argomenti passati alla funzione

loop() ->
    L = [],
    receive
        {plus, X, Y} -> L = [plus(X,Y)|L], plus(X,Y);
        {mul, X, Y}  -> L = [mul(X,Y)|L], mul(X,Y);
        {last, P}    -> P ! {result, list:last(L)};
        {sum, P}     -> P ! {result, list:foldl(fun(X,Sum) -> X + Sum end, 0 , L)}
    end,
loop(). 

plus(X,Y) -> X + Y. 
mul(X,Y) -> X * Y.