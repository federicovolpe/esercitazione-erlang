-module(cl).
-export([convert/5]).

convert(from, From, to, To, Temp) ->
    io:format("asking solution from ~p to ~p~n",[self(), list_to_atom("from" ++ atom_to_list(From))]),
    list_to_atom("from" ++ atom_to_list(From)) ! {toConvert, self(), To, Temp},
    sol(To, Temp).

sol(ScaleFrom, S) ->
    receive
        {converted, ScaleD, T} ->
            io:format("------ ~p °~p are equivalent to ~p °~p~n", [S, ScaleFrom, T, ScaleD]);

        Other -> io:format("garbage: ~p~n",[Other])
    end.