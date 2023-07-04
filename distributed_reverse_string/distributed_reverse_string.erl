- module(distributed_reverse_string).
- export([main/0, start_master/0, loop_slave/0]).

main() -> 
    register(master , spawn(?MODULE, start_master, [])), % creazione del master
    io:format("creato il processo master ~p~n",[master]).

% processo che si occupa del setup di tutti gli schiavi del processo master
start_master() ->
    loop_master(create_slave(10)).

% funzione che si occupa della creazione di 10 slaves
create_slave(0) ->
    io:format("----------- fine della creazione dei processi slave -------- ~n");

create_slave(N) ->
    PidCreato = spawn(?MODULE, loop_slave, []),
    io:format("creato il processo ~p numero ~p ~n", 
    [PidCreato, N]),[PidCreato | create_slave(N-1)].

% loop del processo master
loop_master(Schiavi) ->
    receive
        {Messaggio} -> % se riceve un messaggio da fare decomporre lo invia a tutti i processi slave
                        smista(Messaggio, Schiavi, round(length(Messaggio) / 10)),
                        loop_soluzioni(Schiavi, []);

        stop -> unregister(master),
                io:format("mando il segnale di stop a tutti i processi schiavi ~n"),
                lists:map(fun(X) -> X ! stop end, Schiavi),
                exit(normal)
    end,
    loop_master(Schiavi).

% loop utilizzato per la recezione delle soluzioni 
loop_soluzioni(Schiavi, Soluzioni) ->
    if length(Soluzioni) == 10 -> % se ho ricevuto tutte e 10 le soluzioni le riordino 
                            io:format("ho ricevuto tutte le soluzioni : ~p~n",[Soluzioni]),
                            SortedList = lists:sort(fun({_, A}, {_, B}) -> A > B end, Soluzioni),
                            io:format("le soluzioni ordinate sono : ~p~n",[SortedList]),
                            StringheOrdinate = lists:concat(lists:map(fun({X, _}) -> X end, SortedList)),
                            io:format("le stringhe : ~p~n",[StringheOrdinate]);

        true -> receive
                    {Soluzione, Pid} -> io:format("ricevuta la soluzione [~p] dal processo [~p]~n",[Soluzione, Pid]),
                                        loop_soluzioni(Schiavi, [{Soluzione, Pid} | Soluzioni])
                end
    end.
    

smista([], _, _) ->
    io:format("finito di smistare i messaggi~n");

smista(Messaggio, [H | T] , Lunghezza) -> 
    %prende la prima sottostringa
    Sottostringa = string:sub_string(Messaggio, 1, min(Lunghezza, length(Messaggio))),
    io:format("creata la sottostringa [~p] affidata al processo ~p~n~n",[Sottostringa, H]),
    H ! {Sottostringa, self()},  % invio della sottostringa allo slave
    Avanzante = string:sub_string(Messaggio, Lunghezza +1, length(Messaggio)),
    smista(Avanzante, T, Lunghezza).
    

loop_slave() ->
    receive
        {Messaggio, Master} -> io:format("il processo ~p ha ricevuto il messaggio ~p da ~p e lo decompone ~n", [self(),Messaggio, Master]),
                                Master ! {lists:reverse(Messaggio), self()};

        stop -> io:format("il processo ~p sta terminando~n",[self()]),
                exit(normal)
    end,
    loop_slave().

%master ! {"1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"}.
% master ! {"Stringa01 Stringa02 Stringa03 Stringa04 Stringa05 Stringa06 Stringa07 Stringa08 Stringa09 Stringa10 "}.