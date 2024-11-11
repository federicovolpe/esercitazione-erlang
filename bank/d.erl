- module(d).
- export([start/1]).

start(BankHostName) ->
    io:format("ping result: ~p~n",[net_adm:ping(BankHostName)]),
    case net_adm:ping(BankHostName) of
        pong ->
            global:register_name('MM', self()),
            loop([]);
        pang ->
            io:format("not starting pang")
    end.

loop(Dispatchers) -> 
    io:format("dispatcher waiting..."),
    receive
        {Counter, Operation, NAtm} ->
            Found = lists:keyfind(NAtm, 1, Dispatchers),
            case Found of
                {DNum, DPid} -> 
                    io:format("forwarding message to Dispatcher n ~p ~p~n",[DNum, DPid]),
                    DPid ! {Counter, Operation, NAtm};

                _ ->
                    io:format("creating new dispatcher n ~p~n",[NAtm]),
                    Ndisp = NAtm,
                    NewD = spawn(fun() -> dispatcherLoop(Ndisp) end),
                    NewD ! {Counter, Operation, NAtm},
                    loop([{Ndisp, NewD} | Dispatchers])
            end;
        Other -> 
            io:format("dispatcher received garbage : ~p~n", [Other])
    end,
    loop(Dispatchers).

dispatcherLoop(DNum) ->
    receive
        {Counter, Msg, NAtm} ->
            io:format("im MM~p and i dealt with message ~p~n",[DNum, Counter]),
            global:whereis_name(bank) ! {Msg, Counter, NAtm}
    end,
    dispatcherLoop(DNum).
