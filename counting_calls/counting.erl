- module(counting).                                           
- export([main/0, loop/1]).                                                  
                                                                              
main() ->                                                                     
    register(server, spawn(?MODULE, loop, [[]])).                               
                                                                              
loop(Richieste) ->                                                            
    receive                                                                   
        stop -> io:format("termino il processo server");                      
                                                                              
        Richiesta -> io:format("effettuata una richiesta al server"),         
                    NRichieste = aggiungi(Richieste, Richiesta), 
                    io:format("richieste : ~p~n",[NRichieste]),               
                    loop(NRichieste)                                           
    end,                                           
                                                   
loop(Richieste).                                                               
                                                                               
%funzione che aggiunge la richiesta alla lista di richieste                    
% Richieste is a list of tuples {Richiesta, N}                                 
aggiungi([], Richiesta) ->                                                    
    [{Richiesta, 1}];                                                           
                                                                              
aggiungi([{Richiesta, N} | T], Richiesta) ->                                 
    [{Richiesta, N+1} | T];                        
                                                   
aggiungi([H | T], Richiesta) ->                    
    [H | aggiungi(T, Richiesta)].                               