- module(b).
- export([start/0]).

start() ->
    global:register_name(bank, self()),
    loop(0, 5000).

loop(GlobalCounter, Balance) ->
    receive
        {{balance, Pid}, Local, NAtm} ->
            io:format("i got balance from atm~p local: ~p global: ~p~n", [NAtm, Local, GlobalCounter]),
            Pid ! {balanceResult, Balance};

        {{withdraw, Amount}, Local, NAtm} ->
            io:format("i got withdraw of ~p from atm~p local: ~p global: ~p~n", [Amount, NAtm, Local, GlobalCounter]);
        
        {{deposit, Amount}, Local, NAtm} ->
            io:format("i got deposit of ~p from atm~p local: ~p global: ~p~n", [Amount, NAtm, Local, GlobalCounter])
        
    end,
    loop(GlobalCounter+1, Balance).
    