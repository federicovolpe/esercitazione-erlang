- module (listComp).
- export ([main/0]).
                    
main() ->           
    A = [1, 2, 12, "34", "ciso", 0, telegrafo],
    B = ["ciao", 6, "ciso", 0, 2, rimpianto],
    % data una lista di cose ritorna i numeri quadrati
    squared_int(A), 
    intersect(A, B),
    differenza_simmetrica(A, B).
                    
squared_int(L) -> % funzione che presa una lista ritorna la lista ma con solo i numeri quadrati
    square(filter_list(L)).
                    
square([]) -> % caso lista finita ritorno niente
    [];             
square([H| T]) -> [math:pow(H, 2) | square(T)]. %caso lista piena calcolo la potenza del primo
                    
filter_list(L) -> % funzione che filtra solo i numeri della lista
    lists:filter(fun(X) -> is_number(X) end, L).

intersect(A, B) -> % funzione che prese due liste ritorna l'intersezione delle due
    lists:filter(fun(X) -> lists:member(X, B) end, A).

differenza_simmetrica(A, B) ->
    lists:filter(fun(X) -> not lists:member(X, B) end, A) ++ 
    %tutte quelle contenute in b ma non in a
    lists:filter(fun(X) -> not lists:member(X, A) end, B).