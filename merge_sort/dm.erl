- module (dm).                                                                                                                                                                                     
- export([main/0, startMaster/2, loopMaster/1, loopSlave/0]).                                                                                                                                      
                                                                                                                                                                                                   
main() ->                                                                                                                                                                                          
    register(master, spawn(?MODULE, startMaster, [2, []])),                                                                                                                                        
    master ! [1,2,3,456,7,36,8,45,46,5].                                                                                                                                                           
                                                                                                                                                                                                    
startMaster(1, L) ->                                                                                                                                                                                
    NewL = [spawn(?MODULE, loopSlave, []) | L],                                                                                                                                                     
    io:format("creato il processo ~p~n",[hd(NewL)]),                                                                                                                                                 
    loopMaster(NewL);                                                                                                                                                                               
                                                                                                                                                                                                    
                                                                                                                                                                                                    
startMaster(N, L)->                                                                                                                                                                             
    %inizio di tutti i processi slave                                                                                                                                                          
    NewL = [spawn(?MODULE, loopSlave, []) | L],                                                                                                                                                     
    io:format("creato il processo ~p~n",[hd(NewL)]),                                                                                                                                                 
    startMaster(N-1, NewL).                                                                                                                                                                                                
                                                                                                                                                                                                                           
loopMaster(Slaves) ->                                                                                                                                                                                                      
    receive                                                                                                                                                                                         
        {stop} -> lists:map(fun(P) -> P ! {stop} end, Slaves),                                                                                                                                                                 
                    io:format("sto terminando master e tutti i suoi slaves~n"),                                                                                                                                             
                    exit(normal);                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                                                                                        
                                                                                                                                                                                                                           
        {SlaveId, Risultato} -> io:format("master ha ricevuto il risultato : ~p da [~p]~n", [Risultato, SlaveId]),                                                                                                         
                                receive                                                                                                                                                                                    
                                    {SlaveId2, Risultato2} ->  io:format("master ha ricevuto il risultato : ~p da [~p]~n", [Risultato2, SlaveId2]),                                                                              
                                                            io:format("risultato del merge: ~p~n",[lists:merge(Risultato, Risultato2)])                                                         
                                end;                                                                                                                                                            
                                                                                                                                                                                                
        Messaggio -> io:format("Master ha ricevuto il messaggio: ~p~n",[Messaggio]),                                                                                                    
                    {Prima, Seconda} = lists:split(round(length(Messaggio)/2), Messaggio),                                                                                                                
                    lists:nth(1, Slaves) ! {self(), Prima},                  
                    lists:nth(2, Slaves) ! {self(), Seconda}                 
                                                                             
    end,                                                                                                                                                                                
                                                                                                                                                                                        
loopMaster(Slaves).                                                                                                                                                                                                        
                                                                                                                                                                                                                           
loopSlave() ->                                                                                                                                                                                                             
    receive                                                                                                                                                                                                                
        {Master, Lista} -> Master ! {self(), lists:sort(Lista)};                                                                                                                                                            
                                                                                                                                                                                                                           
        {stop} -> io:format("terminazione del processo ~p~n",[self()]),                                                                                                                                                    
                    exit(normal)                                                                                                                                                                                           
    end,                                                                                                                                                                                                                   
loopSlave().                                                           