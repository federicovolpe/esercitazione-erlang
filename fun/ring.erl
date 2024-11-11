- module (ring).
- export([start/2, send_message/1, send_message/2, stop/0]).

start(Nactors, Functions) ->
    register(first, spawn(fun() -> create(Nactors, Functions) end)).

create(1, Functions) ->
    io:format("creating last 1 ~p connected to ~p~n",[self(), whereis(first)]),
    loopLast(whereis(first), hd(Functions));
create(N, Functions) ->
    Next = spawn(fun() -> create(N-1, tl(Functions)) end),
    io:format("creating ~p ~p connected to ~p~n",[N, self(), Next]),
    loop(Next,  hd(Functions)).

loopLast(Next, Fun) ->
    receive
        {msg, Msg, Times} when Times < 2 ->
            io:format("result : ~p~n",[Fun(Msg)]);

        {msg, Input, Times} ->
            Next ! {msg, Fun(Input), Times-1};

        Other -> 
            io:format("received garbaged ~p~n", [other])
    end,
    loopLast(Next, Fun).

loop(Next, Fun) ->
    receive
        {msg, Input, Times} ->
            Next ! {msg, Fun(Input), Times};

        Other -> 
            io:format("received garbaged ~p~n", [other])
    end,
    loop(Next, Fun).

send_message(Msg) ->
    whereis(first) ! {msg, Msg, 1}.

send_message(Msg, Times) ->
    whereis(first) ! {msg, Msg, Times}. 

stop() ->
    unregister(first).