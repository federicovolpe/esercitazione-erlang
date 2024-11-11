- module (hebrew).
- export ([create/3]).

create(Of, Of, Freq) ->
    io:format("hebrew ~p|~p connected to ~p~n", [Of, self(), whereis(first)]),
    loop(Of, whereis(first), Freq);
create(N, Of, Freq) ->
    Next = spawn(fun() -> create(N+1, Of, Freq) end),
    io:format("hebrew ~p|~p connected to ~p~n", [N, self(), Next]),
    loop(N, Next, Freq).

loop(Id, Next, Freq) ->
    receive
        {newNext, Pid} ->
            if(Pid == self()) ->
                master ! {solution, Id};
            true ->
                Pid ! {1},
                loop(Id, Pid, Freq)
            end;

        {kill, Prec} -> %sending to the previous this next
            io:format("---- killing ~p~n", [Id]),
            Prec ! {newNext, Next};

        {N} when N == (Freq-1) -> %killing the next
            Next ! {kill, self()},
            loop(Id, Next, Freq);

        {N} ->
            io:format("~p received, ~p~n",[Id, N]),
            Next ! {N+1},
            loop(Id, Next, Freq);

        Other -> 
            io:format("~p received garbage, ~p~n",[Id, Other])
    end.