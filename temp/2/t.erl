- module(t).
- export([start/0]).

start() ->
    ToTemp = [
         {toC, fun(C) -> C                  end} 
        ,{toF, fun(C) -> C * 9/5 + 32       end}
        ,{toK, fun(C) -> C + 273.15         end}
        ,{toR, fun(C) -> (C + 273.15) * 9/5 end}
        ,{toD, fun(C) -> (100 - C) * 3/2    end}
        ,{toN, fun(C) -> C * 33/100         end}
        ,{toRe, fun(C) -> C * 4/5            end}
        ,{toRo, fun(C) -> C * 21/40 + 7.5    end}],

    lists:foreach(fun({Name, Fun}) -> register(Name, spawn(fun() -> loopToTemp(Fun) end)) end, ToTemp),

    FromTemp = [
         {fromC,  fun(T) -> T                  end} 
        ,{fromF,  fun(T) -> (T - 32) * 5/9       end}
        ,{fromK,  fun(T) -> T - 273.15         end}
        ,{fromR,  fun(T) -> (T * 5/9) -273.15 end}
        ,{fromDe,  fun(T) -> (- T * 2/3) - 100    end}
        ,{fromN,  fun(T) -> T * 100/33         end}
        ,{fromRe, fun(T) -> T * 5/4            end}
        ,{fromRo, fun(T) -> (T - 7.5) * 40/21    end}],

    lists:foreach(fun({Name, Fun}) -> register(Name, spawn(fun() -> loopFromTemp(Fun,"") end)) end, FromTemp).

loopToTemp(Fun) ->
    receive
        {toConvert, FromTemp, ToTemp, T, FirstLPid} ->
            % ricostruzione del nome
            io:format("second layer sending back: ~p~n",[Fun(T)]),
            FirstLPid! {converted, FromTemp, ToTemp, Fun(T)};
        
        Gargbage ->
            io:format("second received garbage: ~p~n",[Gargbage])
    end,
    loopToTemp(Fun).

loopFromTemp(Fun, ConnectedClient) -> % first layer closer to the client
    receive
        {toConvert, FromTemp, ToTemp, T, Client} ->
            % ricostruzione del nome
            io:format("first layer sending to second layer: ~p~n",[list_to_atom("to" ++ atom_to_list(ToTemp))]),
            whereis(list_to_atom("to" ++ atom_to_list(ToTemp))) ! {toConvert, FromTemp, ToTemp, Fun(T), self()},
            loopFromTemp(Fun, Client);

        {converted, FromTemp, ToTemp, T} ->
            % ricostruzione del nome
            io:format("first layer sending back: ~p~n",[T]),
            ConnectedClient ! {converted, FromTemp, ToTemp, T};
        
        Gargbage ->
            io:format("first layer received garbage: ~p~n",[Gargbage])
    end,
    loopFromTemp(Fun, ConnectedClient).

