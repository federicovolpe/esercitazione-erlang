-module(es1).
-export([is_palindrome/1,is_an_anagram/2,is_prime/1,factors/2,is_perfect/1]).

is_palindrome(S) ->
    L = string:casefold
        (lists:filter(fun(X) -> 
                        not lists:member(X,[$.,$,,$;,$?,32]) 
                        end, S)),
    io:format("~p~n",[L]),
    string:equal(lists:reverse(L),L).



is_an_anagram(S, [H|T]) ->
    S1 = lists:sort(string:casefold (lists:filter(fun(X) -> 
                        not lists:member(X,[$.,$,,$;,$?,32]) end, S))),
    S2 = lists:sort(string:casefold (lists:filter(fun(X) -> 
                        not lists:member(X,[$.,$,,$;,$?,32]) end, H))),
    if(S1 == S2) -> true;
    true -> is_an_anagram(S, T)
    end;
is_an_anagram(_, []) ->
    false.

is_prime(X) ->
    is_prime(X,2).
is_prime(X, Div) ->
    if(Div * Div > X ) -> true;
    true -> 
        if((X rem Div) == 0) -> false;
        true -> is_prime(X, Div+1)
        end
    end.


%factors(X,2) -> factors(X,2);

factors(X,Div) ->
    if(Div > X) -> [];
    true -> if((X rem Div) == 0) -> [Div | factors(X/Div, Div)];
            true -> factors(X, Div + 1)
            end
    end.
componi(From, From) -> [];
componi(From, To) ->
        [From|componi(From+1, To)].
is_perfect(X) -> 
    %lista di interi che va da 1 a X
    Lista = componi(1,X),
    Divisori = lists:filter(fun(N) -> (X rem N) == 0 end, Lista),
io:format("è un numero primo? ~p~n ",[lists:sum(Divisori) == X]).