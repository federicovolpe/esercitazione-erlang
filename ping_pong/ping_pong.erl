- module(ping_pong).
- export([loop/0]).

loop() ->
  receive
    stop -> io:format("spegnimento del server"),
            exit(normal);

    Term -> io:format("ricevuto il messaggio: ~p~n",[Term])

  end,

loop().
