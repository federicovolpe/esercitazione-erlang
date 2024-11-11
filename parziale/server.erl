- module(server).
- export([start/0]).

start() ->
    {_, Hostname} = inet:gethostname(),
    NodeClient = list_to_atom("client@" ++ Hostname) ,
    io:format("server starting client on ~p...~n",[NodeClient]),

    :global:register_name(client, spawn(NodeClient, client, start, [])),
    io:format("registered !").
