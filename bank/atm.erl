- module(atm).
- export([start/1, withdraw/3, deposit/3, balance/2]).

start(NAtm) ->
    register(list_to_atom("Atm" ++ integer_to_list(NAtm)), spawn(fun() -> loop(NAtm, 0) end)),
    io:format("Atm~p spawned~n",[NAtm]).

loop(NAtm, Counter) ->
    receive
        {send, balance} ->
            DPid = global:whereis_name('MM'),
            DPid ! {Counter, {balance, self()}, NAtm},
            loop(NAtm, Counter+1);

        {send, Msg} ->
            DPid = global:whereis_name('MM'),
            DPid ! {Counter, Msg, NAtm},
            loop(NAtm, Counter+1);

        {balanceResult, X} ->
            io:format("Atm~p received balance result: ~p~n",[NAtm, X]);

        X -> 
            io:format("Atm~p received ~p~n",[NAtm, X])
    end,
    loop(NAtm, Counter).

withdraw(Dispatcher, AtmNumber, Quantity) ->
    net_adm:ping(Dispatcher),
    whereis(list_to_atom("Atm"++ integer_to_list(AtmNumber))) ! {send, {withdraw, Quantity}}.

deposit(Dispatcher, AtmNumber, Quantity) ->
    net_adm:ping(Dispatcher),
    whereis(list_to_atom("Atm"++  integer_to_list(AtmNumber))) ! {send, {deposit, Quantity}}.

balance(Dispatcher, AtmNumber) ->
    net_adm:ping(Dispatcher),
    whereis(list_to_atom("Atm"++  integer_to_list(AtmNumber))) ! {send, balance}.