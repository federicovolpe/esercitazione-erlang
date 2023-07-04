- module(ring).
- export([start/3, create/3]).

%M = numero di nodi dell'anello
%N = numero di messaggi che si vogliono inviare
% l'ultimo nodo che viene creato si collega al primo
%spawn è una funzione che ritorna il Pid del processo creato
%register registra il processo creato e gli affida un nome

start(M,N,Msg) -> 
    register(ring_fst, spawn(?MODULE, create, [N,1,self()])),
    io:format("uuueeeee uagliuu[~p]~n",[whereis(rring_fst)]),
    %inizia la creazione del sistema
    receive
        ready -> ok 
        after 5000 -> exit(timeout)
    end,
    msg_dispatcher(M,1,Msg),
    ring_fst!stop,
ok.

msg_dispatcher(M, M, Msg) -> ring_fst!{Msg,M,1};
msg_dispatcher(M, N, Msg) -> ring_fst!{Msg,N,1}, msg_dispatcher(M,N+1,Msg).

create(1, Who, Starter) ->
    %starter è il pid che è stato dato dalla prima create
    Starter ! ready, %viene sbloccato
    io:format("created [~p] as ~p connected to ~p~n",[self(),Who,ring_fst]),
    %loop last prende il primo processo e il numero del processo
    loop_last(ring_fst, Who);

%caso generico in cui un processo parla con il prossimo
create(N, Who, Starter) ->
        Next = spawn(?MODULE, create,[N-1, Who +1, Starter]),
    io:format("created [~p] as ~p connected to ~p~n", [self(),Who, Next]),
        loop(Next, Who).

%creazione delle funzioni di loop
%hanno la semplice funzione di prendere un messaggio e passarlo
loop(Next, Who) ->
    receive
    {Msg, N, Pass} = M ->
        io:format("[~p] got {~p ~p} for the ~p time~n",[Who, Msg, N, Pass]),
        io:format("[~p] is ~p alive? ~p~n",[Who, Next, erlang:is_process_alive(Next)]),
            Next ! {Msg, N, Pass},
        io:format("[~p] sent ~p to [~p] ~n", [Who, M, Next]),
            loop(Next, Who);
    stop -> 
        io:format("~p got {stop}~n",[Who]),
        io:format("[~p] is ~p alive? ~p~n",[Who, Next, erlang:is_process_alive(Next)]),    
            Next ! stop,
        io:format("[~p] sent {stop} to [~p]~n", [Who, Next]),
        io:format("Actor ~p stops. ~n", [Who]);
%per essere sicuri che tutto funzioni
    Other -> io:format("abbiamon cazzo depro blema: ~p~n",[Other])
end.

loop_last (Next,Who) ->
    receive
    {Msg,N,Pass} = M ->
        io:format("[~p] got {~p ~p} for the ~p time ultimo giroo!~n",[Who, Msg, N, Pass]),
        io:format("[~p] is ~p alive? ~p ultimo giroo!~n",[Who, Next, erlang:is_process_alive(whereis(Next))]),
            Next ! {Msg,N,Pass+1},
        io:format("[~p] sent ~p to [~p] ultimo giroo! ~n", [Who, M, Next]),
            loop_last(Next,Who);
    stop ->
    io:format("~p got {stop} ultimo giro!~n",[Who]),    
        exit(normal),
        unregister(ring_fst),
    io:format("[~p] sent {stop} to [~p]~n",[Who, ring_fst]),
    io:format("actor ~p stops ultimo giro!~n",[Who]);

    Other -> io:format("abbiamon cazzo depro blema: ~p~n",[Other])
end.