-module(slave).
-export([chiedi/3]).

chiedi(Server, Stringa, Comando) ->
    Server!{self(),{Stringa,Comando}},
    receive
        {Server, Result} -> Result
end.