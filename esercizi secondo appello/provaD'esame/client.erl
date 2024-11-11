-module(client).
-export([start/1, close/0]).

is_palindrome(S) ->
    %spezza l'input in due parti uguali
    Pari = string:len(S) rem 2 == 0,
    if(Pari) ->
        Half = string:len(S)/2,
        Prima = string:sub_string(S, 0, Half),
        Seconda = string:sub_string(S, Half, string:len(S));
    true -> % se l'input è dispari allora arrotondo per eccesso
        Half = string:len(S)/2 + 1,
        Prima = string:sub_string(S, 0, Half),
        Seconda = string:sub_string(S, Half-1, string:len(S))
    end,

    mm1 ! {self(), Prima}, % invio la prima metà al primo middleman
    mm2 ! {self(), string:reverse(Seconda)}. % invio la seconda metà al secnondo middleman ma in modo reverse
    
start(S) ->
    register(server, spawn(server, create, [])),
    register(mm1, spawn(mm, create, [])),
    register(mm2, spawn(mm, create, [])),
    is_palindrome(S)
    .



close() ->
    mm1    ! stop,
        unregister(mm1),
    mm2    ! stop,
        unregister(mm2),
    server ! stop,
        unregister(server).