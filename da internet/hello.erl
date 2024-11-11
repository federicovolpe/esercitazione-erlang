- module(hello).
- export([hello/0]).

hello() ->
    receive
        {hello, Server} -> Server ! {reply,self()}
    end,
hello().