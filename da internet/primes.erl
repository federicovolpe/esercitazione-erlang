- module(primes).
- export([primi/1]).

primi(N) when N > 1 -> [X || X <- lists:seq(2,N)], 
    (length([Y || Y <- lists:seq(2,trunc(math:sqrt(N))), ((N rem Y) == 0)] ==0));
primi(_) -> [].