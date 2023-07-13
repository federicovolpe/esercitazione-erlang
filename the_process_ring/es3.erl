- module (es3).
- export ([start/2]).
% 1 spawnare N processi
% 2 inviare un messaggio e farlo passare fra i tre 
             
%funzione master che gestisce tutto
start(N,Messaggio) ->
    io:format("inizio~n"),
    L = crea_processi(N,[]),
    [H|T] = L,
    io:format("~ninvio il messaggio al primo[~p]~n",[H]),
    H ! {ciao}.
    %H ! {1 ,Messaggio, T}.

%funzione che crea n processi
crea_processi(0,L) ->
    L;
crea_processi(N,L) ->
    Pid = spawn(es3,loop,[]),
    New = [Pid | L],
    io:format("~n aggiungo [~p] a ",[Pid]),
    stampalista(New),
    io:format(""),
    crea_processi(N-1,New).

loop() ->
    receive
        {Mittente, Messaggio, L} -> 
            io:format("il processo [~p] ha ricevuto il messaggio da [~p]~n",[self(), Mittente]),
            [Prox|Rest] = L;
        Other ->
            io:format("nottrovato ncazzo")
            %Successivo ! {self(), Messaggio},
            %loop();
        %{Mittente, termina} ->
         %   io:format("termino il processo [~p]~n e passo al prossimo~n",[self()])         
    end.


index_of(_, [], _)  -> not_found;
index_of(Item, [Item|_], Index) -> Index;
index_of(Item, [_|Tl], Index) -> index_of(Item, Tl, Index+1).

stampalista([]) ->
    [];
stampalista([H|T]) ->
    io:format(" ~p ",[H]),
    stampalista(T).