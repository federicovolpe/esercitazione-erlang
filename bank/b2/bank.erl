- module(bank).
- export([start/0]).

start() ->
    global:register_name(bank, self()),
    bankLoop(5000, 0),
    io:format("bank started~n").

bankLoop(Balance, Global) ->
    receive
        {_, {balance, AtmPid}, Local} ->
            io:format("bank received : balance local: ~p  global: ~p~n",[Local, Global]),
            AtmPid ! {balanceRes, Balance};

        {_, {Op, Quantity}, Local} ->
            io:format("bank received : ~p of ~p local: ~p  global: ~p~n",[Op, Quantity, Local, Global]),
            case Op of
                deposit ->
                    bankLoop(Balance + Quantity, Global+1);
                withdraw ->
                    bankLoop(Balance - Quantity, Global+1)
            end;
 

        Other ->
            io:format("bank received garbage: ~p~n",[Other])
    end, 
    bankLoop(Balance, Global).