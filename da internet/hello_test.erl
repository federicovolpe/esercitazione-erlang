- module(hello_test).
- export([test_hello/0]).

test_hello() ->
    H = spawn(hello, hello,[]),
    test_hello(10, H). % H è pari al pid
 
 
 test_hello(N, H) when N > 0 ->
    H ! {hello, self()}, % invio del messaaggio a se stesso
    receive
        {reply, C} ->
            io:format("Received ~w~n", [C]),
            test_hello(N-1, H)
    end;

 test_hello(_, _) ->
     io:format("My work is done").