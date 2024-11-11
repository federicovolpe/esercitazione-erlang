-module(dueCerchi).
-export([start/2, createFirst/1, create/2, limbo/1]).

start(N, M)-> 
    %generazione del cerchio1
    First = spawn(?MODULE, createFirst, [N]),
    Second = spawn(?MODULE, createFirst, [N]),
    io:format("invio a ~p l'indirizzo di ~p~n",[First, Second]),
    First ! {Second, other},
    io:format("inizia il ciclo, invio a ~p 3 e fede~n",[First]),
    First ! {3, "fede"},
    M.

    
createFirst(X) -> %creates a circle of processes
    Next = create(X-1, self()),
    limbo(Next).

create(0, First) -> %initialize the last process
    io:format("C - process ~p of ~p up and running~n communicates with ~p~n",[self(), First, First]),
    loop(First);

create(N, First) -> % create the next process and initialize initialize
    Next = spawn(?MODULE, create, [N-1, First]),
    io:format("C - process ~p of ~p up and running~n communicates with ~p~n",[self(), First, Next]),
    loop(Next).

limbo(Next) -> % the first process waits for the address of the other circle
    io:format("process ~p is in limbo~n",[self()]),
    receive
        {Pid, other} -> %if it recieves the address the loop can begin

            io:format("il processo ~p is uppendrunning~n",[self()]),
            Pid ! {self(), other},
            loopFst(Pid, Next);
        X -> 
            io:format("didnt recieve what i wanted: ~p~n",[X])
    end,
    limbo(Next).

loopFst(Other, Next) ->
    receive
        {0, Msg} ->
            io:format("finito il gioco. invio all'altro~n");

        {Ngiri, Msg} -> 
            io:format("~p received the message ~p, passes to ~p~n", [self(), Msg, Next]),
            Next ! {msg, Ngiri-1, Msg};
        
        stop ->
            exit(normal);

        _ -> 
            io:format("terminates all the processes in the ring~n"),
            Next! stop

    end,
    loopFst(Other, Next).
    

loop(Next) ->
    receive
        {msg, Ngiri, Msg} ->
            io:format("~p received the message ~p, passes to ~p~n", [self(), Msg, Next]),
            Next ! {msg, Ngiri, Msg};

        stop -> 
            io:format("process ~p is terminating~n",[self()]),
            Next ! stop,
            exit(normal)
    end,
    loop(Next).
