- module(combinator).
- export([start/2]).

start(N, M) ->  
    register(master, self()), 
    [spawn(generator, create_column, [X, N, M]) || X <- lists:seq(0, N-1)],
    wait_answers(N-1).

wait_answers(N) ->
    io:format("waiting for ~p~n",[N]),
    receive
        {N, Column} when N == 0 ->
            io:format("received final column~n"),
            [Column];
           
        {N, Column} -> 
            io:format("received column ~p~n",[N]),
            lists:zip(Column, wait_answers(N-1))
    end.

display([[]| _]) ->
    ok;
display([H|T]) ->
    lists:map(fun(L) -> hd(L) end, List