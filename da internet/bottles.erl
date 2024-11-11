- module (bottles).
- export ([main/1]).

main(X) when X > 1 ->
    io:format("~p bottles of beer on the wall, ~p bottles of beer.
Take one down and pass it around, ~p bottles of beer on the wall.
~n",[X,X,X-1]),
main(X-1);
main(_) ->
    io:format("1 bottle of beer on the wall, 1 bottle of beer.
Take it down and pass it around, no more bottles of beer on the wall.

No more bottles of beer on the wall, no more bottles of beer.
Go to the store and buy some more, 99 bottles of beer on the wall.
~n").
