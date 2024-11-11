- module(client).
- export([convert/5]).

convert(from, FromTemp, to, ToTemp, T) ->
    NameFromTemp = list_to_atom("from"++ atom_to_list(FromTemp)),
    whereis(NameFromTemp) ! {toConvert, FromTemp, ToTemp, T, self()},
    waitAnswer(T).

waitAnswer(TOriginal) ->
    receive
        {converted, FromTemp, ToTemp, T} ->
            % ricostruzione del nome
            io:format("~p~p -> client received : ~p~p~n",[TOriginal, FromTemp, T, ToTemp]);
        
        Gargbage ->
            io:format("client received garbage: ~p~n",[Gargbage])
    end.