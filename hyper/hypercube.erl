- module(hypercube).
- export([create/0, hamilton/2, gray/0]).

create() ->
    Pids = lists:map(fun(Label) -> {Label, spawn(fun() -> start(Label) end)} end, gray()),
    lists:foreach(fun({_, Pid}) -> Pid ! {neighbors, Pids} end, Pids),
    {_, First} = hd(Pids),
    io:format("registering first as : ~p~n",[First]),
    register(first, First).

start(Label) ->
    receive 
        {neighbors, Neighbors} ->
            RealNeighbors = lists:filter(fun({L2, _}) -> areNeighbors(Label, L2) end, Neighbors),
            io:format("~p neighbors: ~p~n", [Label, RealNeighbors]),
            loop(Label, RealNeighbors)
    end.

loop(Label, Neighbors) ->
    receive
        {msg, Msg, []} ->
            io:format("received last: ~p~n", [Msg]);

        {msg, Msg, [H|T]} -> 
            io:format("~p received msg ~n", [Label]),

            case (lists:keyfind(H, 1, Neighbors)) of
                {_, Pid} -> Pid ! {msg, {src, Label, msg, Msg}, T};
                false -> io:format("error wrong path: ~p is not neighbors with ~p~n", [Label, H])
            end;

        Other -> 
            io:format("~p received garbage: ~p~n", [Label, Other])
    end,
    loop(Label, Neighbors).

hamilton(Msg, [H|T]) ->
    io:format("sending ~p to ~p~n", [{msg, {"0000", msg, Msg}, T}, H]),
    first ! {msg, {src, "0000", msg, Msg}, T}.

areNeighbors(L1, L2) ->
    lists:foldl(fun({C1, C2}, Acc) -> if (C1 == C2) -> Acc;
                                      true -> Acc + 1 
                                      end
                end, 0, lists:zip(L1, L2)) == 1.

gray() ->
    ["0000", "0001", "0011", "0010"
    ,"0110", "0111", "0101", "0100"
    ,"1100", "1101", "1111", "1110"
    ,"1010", "1011", "1001", "1000"].

%     List = ["0001", "0011", "0010", 
%             "0110", "0111", "0101", "0100", 
%             "1100", "1101", "1111", "1110", 
%             "1010", "1011", "1001", "1000"].