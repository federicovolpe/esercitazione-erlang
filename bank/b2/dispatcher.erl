- module(dispatcher).
- export([start/1]).

start(NodeBank) ->
    case net_adm:ping(NodeBank) of
        pong -> 
            io:format("dispatcher connected to the bank~n"),
            global:register_name(dispatcher, self()),
            dispatcherLoop([]);
        pang -> 
            io:format("EEE -- node bank not found~n")
    end.

dispatcherLoop(AtmDispatchers) ->
    receive
        {NAtm, Op, NLocal} ->
            io:format("d received message from: ~p~n",[NAtm]),
            case lists:keyfind(NAtm, 1, AtmDispatchers) of
                {_, DPid} -> 
                    DPid ! {NAtm, Op, NLocal};
                _ -> 
                    NDisp = length(AtmDispatchers) + 1,
                    NewDisp = spawn(fun() -> atmDispatcherLoop(NDisp) end),
                    NewDisp ! {NAtm, Op, NLocal},
                    dispatcherLoop([{NDisp, NewDisp} | AtmDispatchers])
            end;

        Other ->
            io:format("d received garbage: ~p~n",[Other])
    end,
    dispatcherLoop(AtmDispatchers).

atmDispatcherLoop(NDispatcher) ->
    receive
        {NAtm, Op, NLocal} ->
            io:format("MM~p dealt with message ~p~n",[NDispatcher, NLocal]),
            global:whereis_name(bank) ! {NAtm, Op, NLocal}
    end,
    atmDispatcherLoop(NDispatcher).
