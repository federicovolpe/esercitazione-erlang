-module(server).
-export([create/0]).

create() ->
    io:format("Creazione avvenuta del server [~p]~n",[self()]),
    loop().

loop() ->
    io:format("processo [~p] pronto per ricevere ~n",[self()]),
    receive
        {Mittente1 ,S1} -> 
            io:format("il server ha ricevuto la prima stringa ~p~n",[S]);
            receive
                {Mittente2, S2} ->
                    if(uguale(S1, S2)) -> io:format("le stringhe sono identiche~n");
                        true -> io:format("le stringhe NON sono identiche~n")
                    end end
        {stop} -> 
            io:format("sto stoppando il server [~p]~n",[self()]),
            exit(normal)
    end,
loop().

uguale(A,A) -> true;
uguale(A,B) -> false.