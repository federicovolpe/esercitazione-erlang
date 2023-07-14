%module for an implementation of an interface
- module(echo).
- export([start/0, print/1, stop/0]).
- import(ping_pong, [loop/0]).

start()->
  %function that initializes the server
  register(server, spawn(ping_pong, loop, [])).

print(Term) ->
  %function that prints whatever has been recived 
  io:format("invio: ~p~n",[Term]),
  ok.

stop() -> 
  server ! stop,
  ok.
