- module (area_client).
- export ([inizio/0]).

inizio() ->
    Pid2 = spawn(area, area, []),
    io:format("spawnato il processo ~p~n",[Pid2]),
    Pid2 ! {self(), {rectangle, 3, 14}},
    receive
        {Pid2,X} -> 
            io:format("il client (~p) ha ricevuto ~p dal processo ~p ~n",[self(),X,Pid2])
    end.
    %inizio().