-module(prova).
-export([main/0]).

main() ->
    find_factorial(4).

find_factorial(1) -> 1;
find_factorial(X) -> X * find_factorial(X-1).

  

