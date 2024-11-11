- module (series).
- export ([serie/2]).

serie([H|T],X) ->
    Accettabile = string:length([H|T]) >= X,
    if Accettabile -> [blocco([H|T],X) | serie(T,X)];
        true -> []
    end.

%funzione che data una lista sufficientemente lunga ne estrae i primi N membri e ne restituisce la tupla
blocco(_,0) -> [];
blocco(L,N) ->
    [H|T] = L,
    [H| blocco(T,N-1)].
    %io:format("~p~n",[Lat]).

    