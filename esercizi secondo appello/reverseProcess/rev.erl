%create a program that can reverse a string char by char generating processes
- module (rev).                                                        
- export ([start/1, masterCreate/1, slaves/2]).                                                  
                                                                       
start(S) ->                                                             
    register(master, spawn(?MODULE, masterCreate, [S])).               
                                                                       
masterCreate(S) ->                                                     
    spawn(?MODULE, slaves, [self(), S]),                                                 
    loopMaster().                                                      
                                                                       
slaves(Prev, [H | T]) -> % creates all the slaves                      
    spawn(?MODULE, slaves, [self(), T]),                                      
    loopSlave(Prev, H);                                                
                                                                       
slaves(Prev, F) -> % Just send an empty message to the previous process          
     Prev ! {result, F}.                                                      
                                                                       
                                                                       
loopMaster() -> % needs to wait for the result                         
    receive                                                            
        {result, R} ->                                                 
            io:format("risultato finale: ~p~n",[R]),                   
            exit(normal);                                              
                                                                       
        Other ->                                                       
            io:format("messaggio inaspettato al Master ~p~n", [Other]) 
    end,                                                               
    loopMaster().                                                        
                                                                         
loopSlave(Prev, X) -> % waits for a message with the answer              
    receive                                                              
        {result, R} ->                                                   
            io:format("risultato parziale: ~p~n",[R]),                 
            Prev ! {result, R ++ [X]},                                     
            exit(normal);                                              
                                                                       
        Other ->                                                         
            io:format("messaggio inaspettato a ~p: ~p~n",[self(), Other])
    end,                                                               
    loopSlave(Prev, X).                                                
                                                                         