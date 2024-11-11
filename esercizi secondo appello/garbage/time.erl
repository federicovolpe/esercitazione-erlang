% Write the function time:swedish_date() which returns a 
% string containing the date in swedish YYMMDD %
-module(time).
-export([main/0]).
ricomponi(T,2) ->
    T;
ricomponi([H|T],Len) ->
    if(Len > 2) -> ricomponi(T,Len-1);
    true -> list_to_integer([H|T])
end.

aggiungi(X) ->
    io:format("appesa : ~p~n",[lists:append([0],X)]),
    lists:append([0],X).

spezza({Y,M,D}) ->
    if(is_string(M)) ->
        Ml= integer_to_list(M);true -> Ml = M  end,
        io:format("string mese : ~p~n",[list_to_integer(M)]),
    if(is_integer(D)) ->
        Dl= integer_to_list(D);true -> Dl = D  end,
        %io:format("lista giorno : ~p~n",[Dl]),
    if 
    (Y > 999 and is_integer(Y)) -> 
        Yl= integer_to_list(Y),
        io:format("ye sono qui Yl = ~p~p Y = ~p~p ~n",[Yl,is_integer(Yl),Y,is_integer(Y)]),
        spezza({ricomponi(Yl,length(Yl)),M,D});
        true -> Yl = Y
    end, 
    if
    (M < 10) -> 
        io:format("mese modificato : ~p~n",[aggiungi(Ml)]);
        true -> Ml
    end,
    if
    (D < 10) -> 
        aggiungi(Dl);
        true -> Dl
    end,
    {Yl,Ml,Dl}.

main() ->
    io:format("hello world~n"),
    spezza(date()).
