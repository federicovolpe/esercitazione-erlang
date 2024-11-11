-module(server).
-export([create/0,loop/1]).

create() -> %funzione che crea il processo server
    register(server, spawn(?MODULE, loop,[[0,0,0,0,0]])).

    aggiornalista(Lista, Nuova = [], I){
        
    }

loop(Contatore) ->
    receive
        dummy0 -> %restituisco ok
            NewContatore = [lists:nth(0, Contatore)+1,lists:nth(1, Contatore),lists:nth(2, Contatore),lists:nth(3, Contatore),lists:nth(4, Contatore)],
            loop(NewContatore);
        dummy1 -> %restituisco ok
            NewContatore = lists:nth(1, Contatore),lists:nth(1, Contatore)+1,lists:nth(2, Contatore),lists:nth(3, Contatore),lists:nth(4, Contatore),
            loop(NewContatore);
        dummy2 -> 
            NewContatore = [lists:nth(0, Contatore),lists:nth(1, Contatore),lists:nth(2, Contatore)+1,lists:nth(3, Contatore),lists:nth(4, Contatore)],
            loop(NewContatore);
        dummy3 -> 
            NewContatore = [lists:nth(0, Contatore),lists:nth(1, Contatore),lists:nth(2, Contatore),lists:nth(3, Contatore)+1,lists:nth(4, Contatore)],
            loop(NewContatore);
        dummy4 -> 
            NewContatore = [lists:nth(0, Contatore),lists:nth(1, Contatore),lists:nth(2, Contatore),lists:nth(3, Contatore),lists:nth(4, Contatore)+1],
            loop(NewContatore);
        tot -> 
            io:format("~p~n",[lists:sum(Contatore)]),
            loop(Contatore); %ritorna il numero di chiamate che sono state fatte
        kill -> unregister(server),exit(normal);
        Other -> 
            io:format("~pnon è una funzione supportata~n",[Other]),
        loop(Contatore)
    end.