- module(es1).
- export([main/0,from/1,first/1,is_prime/1,primes/0]).

main() ->
    is_palindrome("Do geese see god?"),
    Lista = ["ciao","baby","come","stai","gatto","topo", "cane"],
    is_an_anagram("ybab",Lista).
%    is_proper(2).

is_palindrome(X) ->
    Y = string:lowercase(lists:filter(fun(Y) -> not lists:member( Y, [$.,$,,$;,$?,$!,32])end, X)),
    string:equal(Y ,lists:reverse(Y)).

is_an_anagram(X,[H|T] ) ->
    Y = anagrams(X,H),
    if 
    Y -> true;
    true -> is_an_anagram(X,T)
end;
is_an_anagram(_,[]) ->
    false.

anagrams(X,Y) ->
    string:equal(lists:subtract(X,Y) , []) and string:equal(lists:subtract(Y,X) , []). 


    
%is_proper(X) ->
  %  1) trovare i divisori di un numero
    %2) metterli in una Lista
   % 3) sommarli
    %4) vedere se sommati danno il numero di origine
%factors(X) ->

from(K) -> [K|fun () -> from(K+1) end].

%nel caso la lista fosse vuota ritorno una lista vuota
filter(_,[]) -> [];
%filtro gli elementi che non verificano il Predicato 
filter(Pred, [H|T]) ->
    case Pred(H) of
        %creo la struttura del thunk
        true -> [H|fun()-> filter(Pred,T()) end];
        false -> filter(Pred,T)
    end.

sift(P,L) ->
 filter(fun(N) -> N rem P /= 0 end, L).
sieve([H|T]) -> [H|fun () -> sieve(sift(H,T))end].

%genero una catena di primi
primes() -> sieve(from(2)).

is_prime(N) -> is_prime(N,primes()).
is_prime(N,[N|_]) -> true;
is_prime(N,[M|T]) when M < N -> is_prime(N,T());
is_prime(_,_) -> false.

first(N) -> first(N,primes()).
first(0,_) -> [];
first(N,[X|P]) -> [X|first(N-1,P())].