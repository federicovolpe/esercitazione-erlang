- module(matrix).
- export([mproduct/2]).

mproduct(M1, M2) ->
    register(master, self()),
    M2T = transpose(M2),
    Rows = lists:map(fun({Row, Id}) -> spawn(fun() -> loopRow(Id, Row) end) end, 
            lists:zip(M1, lists:seq(1, length(M1)))),
    Cols = lists:map(fun({Col, Id}) -> spawn(fun() -> loopCol(Id, Col, length(M1), []) end) end, 
            lists:zip(M2T, lists:seq(1, length(M2T)))),
    
    % invio a tutte le righe tutte le colonne a cui inviare 
    lists:foreach(fun(RowPid) -> RowPid ! {columns, Cols} end, Rows),
    
    % aspetto la ricezione della soluzione
    collectSolutions(1, length(Cols), []). 

collectSolutions(IdCol, TotalCols, Acc) ->
    receive
        {IdCol, Result} when IdCol == TotalCols ->
            lists:map(fun(R) -> lists:reverse(R) end, transpose([lists:reverse(Result) | Acc]));

        {IdCol, Result} ->
            io:format("master received col: ~p~n", [lists:reverse(Result)]),
            collectSolutions(IdCol +1, TotalCols, [lists:reverse(Result) | Acc])
    end.

loopRow(Id, Row) ->
    % io:format("row ~p is active~n",[Id]),
    receive
        {columns, Cols} ->
            lists:foreach(fun(PidCol) -> PidCol ! {row, Row, Id} end, Cols);

        Other ->
            io:format("row ~p received garbage ~p~n", [Id, Other])
    end.

loopCol(Id, Col, TotalRows, Acc) ->
    % io:format("col ~p is active~n",[Id]),
    receive
        {row, Row, TotalRows} ->
            io:format("col ~p returning ~p~n", [Id, [mult(Col, Row)| Acc]]),
            whereis(master) ! {Id, [mult(Col, Row)| Acc]};
        
        {row, Row, IdRow} ->
            io:format("col ~p x row ~p = ~p~n", [Id, IdRow, mult(Col, Row)]),
            loopCol(Id, Col, TotalRows, [mult(Col, Row) | Acc])
    end.
    


transpose([[]|_]) ->
    [];
transpose(M) ->
    [lists:map(fun(Row) -> hd(Row) end, M) | 
    transpose(lists:map(fun(Row) -> tl(Row) end, M))].

mult(L1, L2) ->
    lists:foldl(fun({E1, E2}, Acc) -> Acc + E1 * E2 end, 0, lists:zip(L1, L2)).


% [[1,1,1],[2,2,2],[3,3,3]]
% [[1,1,2],[0,1,-3]], [[1,2,0],[1,5,-2],[1,1,1]]