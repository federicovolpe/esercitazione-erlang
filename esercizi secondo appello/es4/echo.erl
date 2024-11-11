-module(echo).
-export([start/0, loop/0, print/1, stop/0]).

start() ->
    register(server, spawn(?MODULE, loop,[])),
    server.

loop() ->
    receive
        stop -> io:format("termino il processo~n"),
            exit(normal),
            unregister(server);
        {Term} -> io:format("~p~n",[Term])
    end,
loop().

print(Term) ->
    server ! {Term},
    ok.

stop() ->
    server ! stop,
    ok.