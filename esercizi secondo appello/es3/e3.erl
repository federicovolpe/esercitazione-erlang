-module(e3).
-export([main/0,create/2]).

main() ->
    %registro il primo processo
    register(primo, spawn(e3, create, [self(),3])),
    %faccio partire il messaggio dal primo processo
    primo! {self(), 0,pass}.


create(_,1) -> %non creo nessun processo ma una funzione che collega l'ultimo creato con il primo
    io:format("process [~p] up comunica con [~p]~n",[self(),whereis(primo)]),    
    loopFinale(primo);
create(_,N) -> %funzione che crea unprocesso
    Pid = spawn(?MODULE, create,[self(),N-1]),%creo un processo con il precedente nodo
    io:format("process [~p] up comunica con [~p]~n",[self(),Pid]), %chiamata ricorsiva per creare il prossimo processo
    loop(Pid).

loop(Succ) ->%loop di un processo generico
    receive
        %ricevo uno stop, mando il messaggio e termino il processo
        stop -> 
                Succ ! {stop},
                io:format("sto terminando il processo : ~p~n",[self()]),
                exit(normal);
        %ricevo un messaggio lo passo se non sono arrivato a 4 nel messaggio
        {_,Msg,pass} ->
                io:format("~p ha ricevuto ~p, lo manda a ~p~n",[self(),Msg,Succ]),
                Succ ! {self(),Msg,pass}
        end,
    loop(Succ).

loopFinale(Prossimo) ->
    receive
        stop -> 
            io:format("sto terminando il processo : ~p~n",[self()]),
            exit(normal);
        {_,Msg,pass} ->
            Passato = Msg > 3,
            case (Passato) of
                true -> Prossimo! {stop};%devo cancellare il nodo iniziale che è stato registrato
                false -> 
                    io:format("~p ha ricevuto ~p, lo manda a ~p~n",[self(),Msg,Prossimo]),
                    Prossimo! {self(),Msg+1,pass}
            end
    end,
loopFinale(Prossimo).