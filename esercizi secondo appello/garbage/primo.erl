%programma che converte una tupla da celsius a farenheit e viceversa%

-module(primo).
-export([main/0]).

farenheitOcelsius({F, farenheit}) ->
    {celsius, F/3};

farenheitOcelsius({C, celsius}) ->
    {farenheit, C*3}.


main()->
    Risultato = farenheitOcelsius({928,farenheit}),
    io:format("risultato: ~p ~n", [Risultato]).

