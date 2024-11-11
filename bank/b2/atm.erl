- module(atm).
- export([start/1, deposit/3, withdraw/3, balance/2]).

start(NAtm) ->
    AtmName = list_to_atom("ATM" ++ integer_to_list(NAtm)),
    io:format("atm ~p started with name ~p~n",[NAtm, AtmName]),
    register(AtmName, spawn(fun() -> atmLoop(NAtm, 0) end)).

atmLoop(NAtm, Local) ->
    receive
        {send, balance} ->
            io:format("ATM~p received send ~p~n",[NAtm, balance]),
            global:whereis_name(dispatcher) ! {NAtm, {balance, self()}, Local},
            atmLoop(NAtm, Local+1);

        {balanceRes, Balance} ->
            io:format("ATM~p received balance ~p~n",[NAtm, Balance]);

        {send, Op} ->
            io:format("ATM~p received send ~p~n",[NAtm, Op]),
            global:whereis_name(dispatcher) ! {NAtm, Op, Local},
            atmLoop(NAtm, Local+1)
    end,
    atmLoop(NAtm, Local).

deposit(DispatcherNode, NAtm, Quantity) ->
    net_adm:ping(DispatcherNode),
    whereis(list_to_atom("ATM" ++ integer_to_list(NAtm))) ! {send, {deposit, Quantity}}.

withdraw(DispatcherNode, NAtm, Quantity) ->
    net_adm:ping(DispatcherNode),
    whereis(list_to_atom("ATM" ++ integer_to_list(NAtm))) ! {send, {withdraw, Quantity}}.

balance(DispatcherNode, NAtm) ->
    net_adm:ping(DispatcherNode),
    whereis(list_to_atom("ATM" ++ integer_to_list(NAtm))) ! {send, balance}.
