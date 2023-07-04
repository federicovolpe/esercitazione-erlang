- module(theProcessRing).
- export([start/3,crea/2]).

% obiettivo: creare un programma che crea:
% N processi 
% M messaggi lanciati dal primo processo 
% Messaggio

% comando che inizializza gli N processi
start(N, M, Messaggio) ->
    %registrazione del primo nodo dell'anello
    io:format("questo processo : ~p ~n", [self()]),
    register(primo, spawn(?MODULE, crea, [N, self()])),% collegamento con il primo processo, ogni processo sarà collegato al successivo
    receive
        {Ultimo, pronto} -> % do' all'ultimo l'indirizzo del primo per agganciare l0'anello
                            Ultimo ! {primo}
        after 3000 -> exit(timeout)
    end,
    
    % inizio a mandare il messaggio
    % composto da il messaggio e il numero di volte che questo deve fare il giro 
    primo ! {Messaggio, M}. 

% funzione che inizializza gli N processi
% crea un processo e lo mette nella lista in input
% tiene sempre il collegamento con il processo madre cosi da poter segnalare quando il processo di creazione è finito

% creazione dell'ultimo nodo, particolare perchè dovrà inviare i messaggi al primo
crea(1, Madre) ->
    Madre ! {self(), pronto},
    % recezione del pid del primo 
    receive
        {primo} -> io:format("creato il processo ~p collegato a  ~p ~n",[self(), primo]),
                    loopUltimo(primo)
    end;
crea(N, Madre) ->
    Prossimo = spawn(theProcessRing, crea, [N-1,Madre]), %creazione di un nuovo processo
    io:format("creato il processo ~p collegato a ~p ~n",[self(), Prossimo]),
    loop(Prossimo). % chiamata ricorsiva alla funzione

% funzione con la quale i processi vengono messi in attesa di un messaggio
loop(Prossimo) ->
    receive
        {Messaggio, Ngiri} -> io:format("il processo ~p ha ricevuto il messaggio ~p ,mancano ancora ~p giri ~n",[self(), Messaggio, Ngiri]),
                                Prossimo ! {Messaggio, Ngiri};
        stop -> io:format("il processo ~p sta terminando ~n",[self()]),
                Prossimo ! stop,
                exit(self())
    end,
loop(Prossimo).

% funzione che definisce il loop dell'ultimo nodo, in tutto e per tutto uguale agli altri
% se non per il fatto che tiene il conto di quante volte il messaggio abbia fatto il giro dei processi
loopUltimo(Primo) -> 
    receive
        {Messaggio, 1} -> % termino i giri
                io:format("il processo ~p ha ricevuto il messaggio ~p ,inizio della terminazione dei processi ~n",[self(), Messaggio]), 
                io:format("il processo ~p invia il messaggio di terminazione~n",[self()]),
                Primo ! stop;

        {Messaggio, Ngiri} -> io:format("il processo ~p ha ricevuto il messaggio ~p ,mancano ancora ~p giri ~n",[self(), Messaggio, Ngiri]),
                                Primo ! {Messaggio, Ngiri-1};

        stop -> io:format("il processo ~p sta terminando ~n",[self()]),
                exit(self())
    end,
loopUltimo(Primo).
