-module(es2).
-export([main/0]).

main() ->
    Exp = "((2*3)+(3*4))",
    [H|_] = parsing:parse([], Exp),
    io:format("risultato dell'espressione: ~p~n",[H-48]).