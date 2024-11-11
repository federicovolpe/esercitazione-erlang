-module(mm).
-export([create/0, loop/0]).
create() ->
    io:format("Creazione avvenuta del middle man [~p]~n",[self()]),
    loop().

loop() ->
    io:format("processo [~p] pronto per ricevere ~n",[self()]),
    receive
    %riceve un messagigo e lo invia al sserver con il porprio pid
        {Mittente, S} ->
            io:format("il processo ~p ha ricevuto la stringa ~p~n",[self(), S]), 
            server ! {self(),S};
        stop -> 
            io:format("sto stoppando il middle man ~p~n",[self()]),
            server ! stop,
            exit(normal)
    end,
loop().