%intestazione
- module(sequential_Erlang).
- export([main/0,primo/1,iPrimi/1,fattori/1]).

%main
main() ->
    io:format("~p ~n" , [is_palindrome("Do geese see god?")]),
    is_an_anagram("oca", ["looca","posca","roca","caio"]),
    fattori([1,12,123,1234,0]).

%funzione che controlla se una lista è palindroma
is_palindrome(S) -> 
    %tolgo dalla stringa i caratteri speciali
    R = lists:filter(fun(X) -> not lists:member(X, [$.,$?,32,$,,$!])end,S),
    
    % rendo la stringa minuscola
    Ritorno = string:lowercase(R),
    
    %controllo che la stringa generata si a uguale a se stessa invertita
    string:equal(Ritorno,lists:reverse(Ritorno)).


%funzione che controlla se una stringa è un anagramma di una parola in una lista
is_an_anagram(S1, [H|T]) ->
    %nel caso di due stringhe controllo soltanto che non siano anagrammi fra di loro
    A = anagrams(S1, H),
    if
        A  -> true;
        true -> is_an_anagram(S1,T)
    end;

%nel caso che la lista sia finita ritorno false
is_an_anagram(_,[]) ->
    io:format("le parole da comparare sono finite ~n"),
    false.

%funzione che controlla se due stringhe sono anagrammi


%nel caso una delle due stringhe sia vuota ritorno false
anagrams(S1, S2) ->
    string:equal(lists:subtract(S1,S2), lists:subtract(S2,S1)).
        

%funzione che calcola tutti i fattori primi di un numero x
%funzione che genera una lista di numeri interi in que3sto caso a partire da 2
lista(X) -> [X| fun() -> lista(X+1) end].
        
%funzione di filtro che serve a filtrare quali elementi di una lista verificano una proprietà
        
% nel caso di una lista vuota allora ritorno la lista vuota
filtro(_,[]) -> [];
filtro(Proprieta, [H|T]) ->
    case Proprieta(H) of
        % ritorno una lista con in testa l'elemento H
        true -> [H|fun() -> filtro(Proprieta, T) end];
        
        % ritorno una lista creata con T 
        false -> [fun() -> filtro(Proprieta, T) end]
    end.
        
        
% funzione che restituisce tutti i fattori di un numero
fattori(N) -> fattori(N, [], primi()).
fattori(N, R, _) when N =< 1 -> lists:reverse(R);
fattori(N, R, [N | _]) -> lists:regerse([N | R]);
fattori(N, R, [H | _] = P) when N rem H == 0 -> fattori(N div H, [H | R], P);
fattori(N, R, [_| T]) -> fattori(N, R, T()). 

% funzione che dato una lista e un numero filtra la lista 
% selezionando i numeri che non sono divisibili per quello selezionato
filtraDivisibili(D,L) ->
    filtro(fun(N) -> N rem D /= 0 end, L).

% funzione che presa una lista la filtra togliendo tutti inumeri
% che sono divisibili per il primo e facendo così per i restanti numeri
listaPrimi([H|T]) -> [H| fun() -> listaPrimi(filtraDivisibili(H, T)) end].

% funzione che crea la lista di primi a partire dal 2
primi() -> listaPrimi(lista(2)).
                        
% funzione che determina se un nuemro X è primo o meno
primo(N) -> primo(N, primi()).
                        
primo(_, []) -> false;  
primo(N, [N|_]) -> true;
primo(N, [_|T]) -> primo(N, T).
                        
% funzione che ritorna i primi n numeri primi
iPrimi(N) -> iPrimi(N,primi()).
                        
iPrimi(N, [X| P]) -> [X| iPrimi(N - 1, P())];
iPrimi(0, _) -> [].     