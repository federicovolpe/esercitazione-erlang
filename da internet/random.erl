-module(random).
-export([main/0]).

main() ->
    scambia("scambia").

scambia([H | T]) ->
    string:concat(ultimo(T), scambia(T, H)).
%funzione che scambia il primo e ultimo carattere della stringa
scambia([_], First) ->
    First;

scambia([H | T], First) -> 
    string:concat(H, scambia(T, First)). 

%funsione che prende l'ultimoelemento di una lista
ultimo([H]) -> 
    H;

ultimo([_ | T]) ->
    ultimo(T).
