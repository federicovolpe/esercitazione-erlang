- module(minimum).
- export([min_max/1,minimo/1,massimo/1]).

min_max(L) ->
    {minimo(L),massimo(L)}.

minimo([X]) -> X;
minimo([H|T]) ->
    Truth = H < minimo(T),
    if Truth -> 
    H ;
    true -> minimo(T)
    end.

massimo([X]) -> X;
massimo([H|T]) ->
    Truth = H > massimo(T),
    if Truth -> 
    H ;
    true -> massimo(T)
    end.