-module(gangaclient).
-export([change/3]).
%il primo argomento è il processo del server
%il secondo argomento il messaggio da passare
%il terzo argomento il atom che spiega cosa fare

change(Server, String, Command) ->
    Server! {self(), {String, Command}},
    receive
        %se ricevo una cosa così allora va bene e la ritorno
        {Server, Resultstring} -> Resultstring
    end.
