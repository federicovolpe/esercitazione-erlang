- module(theProcessRing).
- export([start/1,crea/2]).

% obiettivo: creare un programma che crea:
% N processi 
% M messaggi lanciati dal primo processo 
% Messaggio

% comando che inizializza gli N processi
start(N) ->
    %registrazione del primo nodo dell'anello
    io:format("questo processo : ~p ~n", [self()]),
    register(primo, spawn(?MODULE, crea, [N, self()])),% collegamento con il primo processo, ogni processo sarà collegato al successivo
    receive
        {Ultimo, pronto} -> % do' all'ultimo l'indirizzo del primo per agganciare l0'anello
                            Ultimo ! {primo}
        after 3000 -> exit(timeout)
    end,
    % inizio a mandare il messaggio
    primo ! {self(), "ciao"}. 

% funzione che inizializza gli N processi
% crea un processo e lo mette nella lista in input
% tiene sempre il collegamento con il processo madre cosi da poter segnalare quando il processo di creazione è finito

% creazione dell'ultimo nodo, particolare perchè dovrà inviare i messaggi al primo
crea(1, Madre) ->
    Madre ! {self(), pronto},
    % recezione del pid del primo 
    receive
        {primo} -> io:format("creato il processo ~p collegato a  ~p ~n",[self(), primo]),
                    loop(primo)
    end;
crea(N, Madre) ->
    Prossimo = spawn(theProcessRing, crea, [N-1,Madre]), %creazione di un nuovo processo
    io:format("creato il processo ~p collegato a ~p ~n",[self(), Prossimo]),
    loop(Prossimo). % chiamata ricorsiva alla funzione

% funzione con la quale i processi vengono messi in attesa di un messaggio
loop(Prossimo) ->
    receive
        {Mittente, Messaggio} -> io:format("ho ricevuto il messaggio ~p da ~p ~n",[Messaggio, Mittente]);
                    % Mittente ! {Messaggio};
        Other -> io:format("messaggio di errore~n")
    end,
loop(Prossimo).