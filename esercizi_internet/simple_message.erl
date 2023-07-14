- module(simple_message).
- export([start/0, ricevi/1]).

start() -> 
  register(media, spawn(simple_message, ricevi, [[]])).

ricevi(Numeri) -> 
  receive
    stop ->
      io:format("terminazione del processo"),
      unregister(media),
      exit(normal);
    
    Numero -> %inserisco il numero nella lista
      NewLista = [Numero | Numeri],
      io:format("media di ~p  = ~p~n",[NewLista, media(NewLista)]),
      ricevi(NewLista)

  end,
ricevi(Numeri).

media(L) ->
  lists:sum(L) / length(L).
