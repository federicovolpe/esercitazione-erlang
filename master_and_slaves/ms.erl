- module(ms).
- export([start/1,loop_master/0,loop_slave/1,to_slave/2]).

% funzione che inizia il processo master e dice di far partire N processi figli
% registra il processo master come master
start(N) ->
    register(master, spawn(?MODULE, loop_master, [])),
    registra(N),
    loop_master().

% funzione che inizializza tutti i processi figli e memorizza il loro Pid nella lista
registra(0) ->
    [];
registra(N) -> 
    Pid = register(N, spawn(?MODULE, loop_slave, [master])),
    io:format("regstrato il processo ~p ~n",[Pid]),
    registra(N-1).

loop_master() ->
    receive
        {termina, Pid} ->  %il processo N è terminato, ne genero uno nuovo con lo stesso nome
                        io:format("registrazione del processo sostitutivo ~p ~n",[Pid]),
                        register(Pid, spawn(?MODULE, loop_slave, [master]));

        {die, N, _} -> io:format("dico al processo ~p di terminare ~n",[N]),
                    N ! die;

        %se ricevo un messaggio normale lo rigiro al destinatario
        {Messaggio, N, Mittente} -> N ! {Messaggio, Mittente}
    end,
loop_master().

% con questa funzione un processo figlio si rivolge al master dicendogli di inviare
% il messaggio al figlio numero N
% se il messaggio è die allora il N deve essere ucciso e riavviato dal master
to_slave(Messaggio, N) ->
    master ! {Messaggio, N}.

% loop di un processo slave prevede la recezione di un messaggio
loop_slave(Master) ->
    receive
        die -> % invio del messaggio di terminazione al master
                Master ! {termina, self()},
                io:format("il processo ~p è stato terminato ~n",[self()]),
                exit(normal);

        {Messaggio, Mittente} -> io:format("ricevuto il messaggio: ~p dal processo ~p ~n",[Messaggio, Mittente])
    end,
loop_slave(Master).