%intestazione
- module(sequential_Erlang).
- export([main/0]).

%main
main() ->
    is_palindrome("Do geese see god?").

%funzione che controlla se una lista è palindroma
is_palindrome(S) -> 
    %tolgo dalla stringa i caratteri speciali
    R = lists:filter(fun(X) -> not lists:member(X, [$.,$?,32,$,,$!])end,S),
    
    % rendo la stringa minuscola
    Ritorno = string:lowercase(R),
    
    %controllo che la stringa generata si a uguale a se stessa invertita
    string:equal(R,lists:reverse(Ritorno)).

%funzione che controlla se una stringa è un anagramma di una parola in una lista
is_an_anagram(S1, [H|T]) ->
    %nel caso di due stringhe controllo soltanto che non siano anagrammi fra di loro
    if
        anagrams(S1,T) -> true;
        true -> is_an_anagram(S1,T)
    end;

%nel caso che la lista sia finita ritorno false
is_an_anagram(_,[]) ->
    false.

%funzione che controlla se due stringhe sono anagrammi
anagrmas([H1|T1],[H2|T2]) ->
    if
        H1 == H2 -> anagrams(T1,T2);
        true -> false
    end;

%nel caso una delle due stringhe sia vuota ritorno false
