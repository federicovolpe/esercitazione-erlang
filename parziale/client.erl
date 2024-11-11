- module(client).
- export([start/0]).

start() ->
    group_leader(whereis(user), self()),
    io:format("starting client...~n"),
    loop().

loop() ->
    receive
        Message -> 
            io:format("client received : ~p~n",[Message])
    end,
    loop().
