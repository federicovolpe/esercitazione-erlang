-module(fibonacci_server).
-export([start/0,servi/0,facto/1]).

start() ->
    spawn(fibonacci_server,servi,[]).%il server fa partire se stesso con la funzione servi

servi() ->%il server si mette in ascolto di quello che il client ha da dire
    receive
        {Client, N, fibo} -> Client ! {self(),fibo(N)};%una volta ricevuta la tupla risponde al client con il suo pid e il risultato
        {Client, N, facto} -> Client ! {self(),facto(N)}
    end,
servi().

fibo(0) -> 0;
fibo(1) -> 1;
fibo(N) ->
    fibo(N-1) + fibo(N-2).

facto(1) -> 1;
facto(N) -> N* facto(N-1).
    
