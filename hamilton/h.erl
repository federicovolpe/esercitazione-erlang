- module (h).
- export([create/0, startNode/1, hamilton/2, gray/1]).

create() ->
    Lables = ["0000","0001","0011","0010","0110","0111","0101",
"0100","1100","1101","1111","1110","1010",
"1011","1001","1000"],
    Nodes = lists:map(fun(X) -> {spawn(?MODULE, startNode, [X]), X} end, Lables),
    lists:foreach(fun({Pid, _}) -> Pid ! {init, Nodes} end, Nodes),
    {Fst, _} = hd(Nodes),
    register(fst, Fst).

hamilton(Msg, List) ->
    io:format("sending message to ~p~n",[fst]),
    fst ! {msg, Msg,  List},
    unregister(fst).

gray(0) -> [""];
gray(N) -> G = gray(N-1), [ "0"++L || L <- G ]++[ "1"++L || L <- lists:reverse(G) ].

startNode(Label) ->
    receive
        {init, Neighbors} -> 
            F = lists:filter(fun({_, L}) -> areNeighbors(Label, L)
                            end, 
                            Neighbors),
            %io:format("node ~p started ~nwith Neighbors ~p~n",[Label, F]),
            loop(Label, F)
    end.

loop(Id, Neighbors) ->
    io:format("~p is waiting~n",[Id]),
    receive
        {msg, _, [Label]} ->
            if(Label == Id)->
                  io:format("nodo finale ha ricevuto ~p~n",[Id])
            end;

        {msg, Msg, [Dest | Rest]} ->
            io:format("dest ~p == ~p?~n",[Dest, Id]),
            if(Dest == Id) ->
                io:format("~p riceve ~p~n",[Id, Msg]),
                lists:foreach(fun({Pid, _}) -> 
                                Pid ! {msg, Msg, Rest} end, Neighbors);
              true -> io:format("")
            end
    end.


areNeighbors(L1, L2) ->
    %io:format("sono vicini ~p e ~p?~n",[L1,L2]),
    areNeighbors(L1,L2, 0).

areNeighbors([H|T1],[H|T2], C) ->
    areNeighbors(T1,T2,C);

areNeighbors([H1|_],[H2|_], 1) ->
    false;
areNeighbors([_|T1],[_|T2], C) ->
    areNeighbors(T1, T2, C+1);
areNeighbors([],[], 0) ->
    false;
areNeighbors([],[], _) ->
    true.

