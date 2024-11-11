- module(s).
- export([startsys/0, unreg/0]).

% prendono la misura in celsius e la convertono
loopToT(F) ->
    receive
        {toConvert, FrClient, ScaleD, C} ->
            io:format("sending solution: ~p to ~p~n",[F(C), FrClient]),
            FrClient ! {converted, ScaleD, F(C)};
        
        Other -> io:format("received garbage: ~p~n",[Other])

    end,
    loopToT(F).

loopToC(F, Client) ->
    receive
        {toConvert, NClient, ScaleD, C} ->
            io:format("~p asking to convert: ~p C~n",[self(), F(C)]),
            list_to_atom("to"++ atom_to_list(ScaleD)) ! {toConvert, self(), ScaleD, F(C)},
            loopToC(F, NClient);

        {converted, ScaleD, T} ->
            io:format("received converted: ~p~p~n",[T, ScaleD]),
            Client ! {converted, ScaleD, T}
    end,
    loopToC(F, Client).

firstRow() ->
    ListTo = [
            {toC, fun(C) -> C end},
            {toF, fun(C) -> C * 9/5 + 32 end},
            {toK, fun(C) -> C + 273.15 end},
            {toR, fun(C) -> (C + 273.15) * 9/5 end},
            {toDe, fun(C) -> (100 - C) * 3/2 end},
            {toN, fun(C) -> C *33/100 end},
            {toRe, fun(C) -> C *4/5 end},
            {toRo, fun(C) -> C * 21/40 +7.5 end}],
    
    lists:foreach(fun({Name, F}) -> register(Name, spawn(fun() -> loopToT(F) end)),
                io:format("registe, ~p~n", [Name]) end, ListTo).

secondRow() ->
    ListFrom = [
        {fromC, fun(T) -> T end},                 {fromF, fun(T) -> (T - 32) * 5/9 end},
        {froR, fun(T) -> (T * 5/9) + 273.15 end}, {fromDe, fun(T) -> - ((T * 2/3) -100) end},
        {fromN, fun(T) -> T * 100/ 33 end},       {fromRe, fun(T) -> T * 5/4 end},
        {fromRo, fun(T) -> (T -7.5) * 40/21 end}, {fromK, fun(T) -> T - 273.15 end}],

    lists:foreach(fun({Name, F}) -> register(Name, spawn(fun() -> loopToC(F,"") end)),
                io:format("registe, ~p~n", [Name]) end, ListFrom).

startsys() ->
    firstRow(),
    secondRow().

unreg() ->
    ListTo = [toC,toF,toR,toDe,toN,toRe,toRo],
    ListFrom = [fromC,fromF,froR,fromDe,fromN,fromRe,fromRo],
    lists:foreach(fun(Name) -> unreg(Name) end, ListTo),
    lists:foreach(fun(Name) -> unreg(Name) end, ListFrom).

unreg(Name) ->
    Reg = lists:member(Name, registered()),
    io:format("~p is registered? ~p~n",[Name, Reg]),
    if Reg -> unregister(Name);
    true -> f end.