-module(client).
-export([main/0]).

main() -> 
    %creo il mio server
    spawn(echo, start,[]),
    io:format("creato il processo~n"),
    server ! {ciao},
    server ! {"come stai oggi?"},
    %server ! stop.
    exit(kill).