-module(master).
-export([main/0,loop/0]).

main() ->
    spawn(master, loop, []).

loop() ->
    receive
        {Client,{Risultato, upper}} -> Client! {self(),string:to_upper(Risultato)}
    end,
loop().      