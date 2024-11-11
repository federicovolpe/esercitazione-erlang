- module (area).
- export ([area/0]).

area() ->
    receive
    {Pidc,{rectangle, N}} -> 
        io:format("io (~p) ho inviato a ~p ~p~n",[self(),Pidc, N*N]),
        Pidc ! {self(),N*N};
    {Pidc,{rectangle, X, Y}} -> 
        io:format("io (~p) ho inviato a ~p ~p~n",[self(),Pidc, X*Y]),
        Pidc ! {self(),X*Y}
    end,
area().