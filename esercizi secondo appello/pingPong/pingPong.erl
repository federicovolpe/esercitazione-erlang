-module (pingPong).
-export ([start/1,ping/0, pong/0]).

start(Ngiri) ->
    register(ping, spawn(?MODULE, ping, [])),
    register(pong, spawn(?MODULE, pong, [])),
    ping ! Ngiri.

ping() ->
    receive
        0 -> %terminate the execution
            io:format("terminating the execution"),
            pong ! stop,
            exit(normal);
        N -> 
            io:format("ping ~p ~n", [N]),
            pong ! N
    end,
ping().

pong() ->
    receive
        stop -> 
            exit(normal);
     
        N -> %sends back the message
            io:format("pong ~p ~n", [N]),
            ping ! N - 1

    end,
pong().
