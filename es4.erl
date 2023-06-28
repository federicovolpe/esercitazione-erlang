- module(es4).
- export([server/0]).

start() ->
    PidS = spawn(es4, server,[]),
    ok.


server() ->
    receive
        {Client,Content} -> io:format("~p~n", [Content]), Client ! ok
    end,
server().