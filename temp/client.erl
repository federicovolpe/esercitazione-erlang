-module(client).
- export([convert/5]).

convert(from, TempSource, to, Destination, Temp) ->
    TempDest = list_to_atom("to" ++ atom_to_list(Destination)),
    TempStart = list_to_atom("from" ++ atom_to_list(TempSource)),
    
    io:format("invio a ~p~n", [TempStart]);
    whereis(TempStart) ! {toConvert, Temp, TempDest, self()},

    waitAnswer(Temp, TempSource, Destination).

waitAnswer(OriginalTemp, TempSource, Destination) ->
    receive
        {answer, T} -> 
            io:format("~p°~p are equivalent to ~p°~p~n", [OriginalTemp, TempSource, T, Destination]);

        G -> io:format("error client recieved ~p ~n", [G])
    end.