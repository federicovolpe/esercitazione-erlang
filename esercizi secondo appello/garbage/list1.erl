-module(list1).
-export([main/0]).
min([H]) -> H;

min([H|T]) ->
    Verit = H < min(T),
    if(Verit) -> H;
    true -> min (T)
end.

max([H]) -> H;

max([H|T]) ->
    Verit = H > max(T),
    if(Verit) -> H;
    true -> max (T)
end.

min_max(List) ->
    {min(List),max(List)}.


main() ->
    List = [1,2,3,4,5,6,7,8],
    io:format("~p~n",[min(List)]),
    io:format("~p~n",[max(List)]),
    io:format("~p~n",[min_max(List)]).
    