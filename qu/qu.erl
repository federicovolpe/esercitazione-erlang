- module(qu).
- export([new_queue/0, push/2, pop/1, loop/1]).

%funzione che ritorna il pid di un processo queue
new_queue() ->
  spawn(qu, loop, [[]]).

%funzione che aggiunge un valore alla fine della queue
push(Pid, Value) ->
  Pid ! {add, Value}.

%function that pops from the first item of the queue
pop(Pid) ->
  Pid ! pop.

loop(L) ->
  receive
    {push, Value} -> NewL = [Value | L],

                     loop(NewL);
    
    pop -> io:format("ricavato ~p~n",[hd(L)]),
           NewL = tl(L),
           loop(NewL)
  end,

loop(L).
