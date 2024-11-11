- module(r).
- export([start/2, send_message/1, send_message/2, stop/0]).

start(N, Functions) ->
    register(first, spawn(fun() -> spawn_ring(N, Functions) end)).

spawn_ring(1, [H| _]) ->
    io:format("spawned ~p-~p connected to ~p~n",[1, self(), whereis(first)]),
    last_node(H, whereis(first));

spawn_ring(N, [H | T]) ->
    Next = spawn(fun() -> spawn_ring(N-1, T) end),
    io:format("spawned ~p-~p connected to ~p~n",[N, self(), Next]),
    node(H, Next).

last_node(Fun, Next) ->
    receive
        {stop} ->
            io:format("~p stopping~n",[self()]);

        {msg, Input, Times} when Times < 2 ->
            io:format("~p got the answer~n~p~n",[self(), Fun(Input)]);

        {msg, Input, Times} ->
            Next ! {msg, Fun(Input), Times-1};
        
        Other ->
            io:format("~p received other: ~p~n",[self(), Other])
    end,
    last_node(Fun, Next).

node(Fun, Next) ->
    receive
        {stop} ->
            io:format("~p stopping~n",[self()]),
            Next ! {stop};

        {msg, Input, Times} ->
            io:format("~p got message ~p~n",[self(), Input]),
            Next ! {msg, Fun(Input), Times};
        
        Other ->
            io:format("~p received other: ~p~n",[self(), Other])
    end,
    node(Fun, Next).

send_message(Input) ->
    whereis(first) ! {msg, Input, 1}.

send_message(Input, Times) ->
    whereis(first) ! {msg, Input, Times}.

stop() ->
    whereis(first) ! {stop},
    unregister(first).