- module(fibonacci_client).
- export([operatore/3]).

operatore(Server,N,Op) ->
    Server ! {self(),N,Op}, % dice al server indicato presentandosi, cosi il server sa a chi rivolgersi
    receive
        {Server, Risultato} -> Risultato %riceve la risposta dal server e la restituisce all'operatore 
    end.