- module(tempsys).
- export([startsys/0]).

startsys() ->
    ToTemp = [
     {toF , fun(C) -> C * 9/5 + 32       end}
    ,{toC , fun(C) -> C         end}
    ,{toK , fun(C) -> C + 273.15         end}
    ,{toR , fun(C) -> (C + 273.15) * 9/5 end}
    ,{toDe , fun(C) -> (100 - C) * 3/2    end}
    ,{toN , fun(C) -> C * 33/100         end}
    ,{toRe , fun(C) -> C * 4/5            end}
    ,{toRo , fun(C) -> C * 21/40 + 7.5    end}
    ],

    lists:foreach(fun({Name, Fun}) -> register(Name, spawn(fun() -> 
                                    io:format("~p up and running~n", [Name]),
                                    toTempLoop(Fun) end)) end, ToTemp),

    FromTemp = [
     {fromF , fun(T) -> (T - 32) * 5/9        end}
    ,{fromC , fun(T) -> T         end} 
    ,{fromK , fun(T) -> T - 273.15         end}
    ,{fromR , fun(T) -> (T * 5/9) - 273.15 end}
    ,{fromDe , fun(T) -> -(T * 2/3) + 100    end}
    ,{fromN , fun(T) -> T / (33/100)         end}
    ,{fromRe , fun(T) -> T / (4/5)            end}
    ,{fromRo , fun(T) -> (T - 7.5) / (21/40)     end}
    ],

    lists:foreach(fun({Name, Fun}) -> register(Name, spawn(fun() -> 
                                        io:format("~p up and running~n", [Name]),
                                        fromTempLoop(Fun, "") end)) end, FromTemp).

fromTempLoop(Fun, Client) ->
    receive
        {toConvert, T, DestinationTemp, Source} ->
            %io:format("first layer received ~p~n",[T]),
            whereis(DestinationTemp) ! {toConvert, Fun(T), self()},
            fromTempLoop(Fun, Source);

        {answer, T} ->
            %io:format("first layer received answer ~p~n",[T]),
            Client ! {answer, T};
        
        G -> io:format("error first layer recieved ~p ~n", [G])
    end,
    fromTempLoop(Fun, "").

toTempLoop(Fun) ->
    receive
        {toConvert, C, Source} ->
            %io:format("second layer received ~p~n",[C]),
            Source ! {answer, Fun(C)};

        G -> io:format("error second layer recieved ~p ~n", [G])
    end,
    toTempLoop(Fun).