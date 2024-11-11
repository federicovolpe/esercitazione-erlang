- module(generator).
- export([create_column/3]).

create_column(Index, Of, M) ->
    Base = lists:seq(1, M),
    Sequence = lists:flatten(lists:map(fun(B) -> string:copies([B], trunc(math:pow(M, Index))) end, Base)),
    Nsequences = trunc(math:pow(Of, M) / length(Sequence)),
    io:format("sending: ~p to ~p~n", [{Index, string:copies(Sequence, Nsequences)}, whereis(master)]),
    whereis(master) ! {Index, string:copies(Sequence, Nsequences)}.