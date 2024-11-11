- module(equilatero).
- export([cheforma/3]).

cheforma(X,Y,Z) when (X == Y) and (Y == Z) and (Z == X) -> equilatero;
cheforma(X,Y,Z) when (X == Y) or (Y == Z) or (Z == X) -> isoscele;
cheforma(_,_,_) -> scaleno.