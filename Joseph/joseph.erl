- module(joseph).
- export([joseph/2]).

joseph(N, Freq) ->
    register(master, self()),
    register(first, spawn(fun() -> hebrew:create(1, N, Freq) end)),
    io:format("first is: ~p~n", [whereis(first)]),
    whereis(first) ! {1},
    receive
        {solution, Solution} ->
            io:format("In a circle of ~p people, killing number ~p~n",[N, Freq]),
            io:format("Joseph is the Hebrew in position ~p~n", [Solution]);

        Other ->
            io:format("received junk: ~p~n", [Other])
    end.
    