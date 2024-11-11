-module(mathStuff).
-import(math, [sqrt/1, pi/0]).
-export([main/0]).



perimeter({square, Side}) ->
    Side *Side;

perimeter({circle, Radius}) ->
    Pi = 3.14,
    Radius * Radius * Pi;

perimeter({triangle, A, B, C}) ->
    S = (A + B + C) /2,
    sqrt(S*(S-A)*(S-B)*(S-C)).
main()->
    Quadrato = perimeter({square,4}),
    io:format("area del quadrato : ~p",[Quadrato]),
    
    Triangolo = [perimeter({triangle, 4,4,4})],
    io:format("~narea del triangolo : ~p",[Triangolo]),
    
    Cerchio = perimeter({circle, 4}),
    io:format("~narea del cerchio : ~p",[Cerchio]).
    