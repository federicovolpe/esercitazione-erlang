- module(dmAdvanced).                                                                                                                    
- export([main/0, startSlave/1, startMaster/0]).                                                                                                                       
                                                                                                                                                
main() ->                                                                                                                                       
    Stringa = "126735487162354",                                                                                                               
    register(master, spawn(?MODULE, startMaster, [])),                                                                                           
    master ! Stringa.                                                                                                                           
                                                                                                      
startMaster() ->                                                                                      
    process_flag(trap_exit, true),                                                                    
    loopMaster().                                                                                     
                                                                                                      
loopMaster() ->                                                                                                                                 
    receive                                                                                                                                     
        {Pid1, Soluzione1} -> io:format("ricevuto da ~p la soluzione ~p ~n",[Pid1, Soluzione1]),   
                            receive                                                                                                           
                                {Pid2, Soluzione2} ->                                                 
                                    io:format("ricevuto da ~p la soluzione ~p ~n",[Pid2, Soluzione2]),                                       
                                    io:format("soluzione elaborata dal master : ~p~n", [lists:merge(Soluzione1, Soluzione2)]),               
                                    self() ! {stop}                                                                                          
                            end;                                                                                                             
                                                                                                                                              
        {stop} -> io:format("Master ha ricevuto lo stop~n"),                                                                                                         
                        exit(killchild);                                                                                                                                        
                                                                                                                                              
        Messaggio ->                                                                                                                         
            smista(Messaggio)                                                                                                                                              
    end,                                                                                                                                       
loopMaster().                                                                                                                                   
                                                                                                                                              
%function for the beginning slave processes setup the links                                                                                   
startSlave(Master) ->                                                                                                                         
    link(Master),                                                                                                                             
    loopSlave(Master).                                                                                                                        
                                                                                                                                              
loopSlave(Master) ->                                                                                                                          
        receive                                                                                                                               
            {Master, Parziale} ->                                              
                if length(Parziale) > 1 ->                                     
                    smista(Parziale);                                          
                    true -> io:format("ritorno ~p a ~p~n", [Parziale, Master]),
                        Master ! {self(),Parziale},                            
                        self() ! stop                                       
                end;                                                           
                                                                               
            {_ , Soluzione1} ->                                                
                receive                                                        
                    {_, Soluzione2} ->                                         
                        io:format("~p ha ricevuto le soluzioni: ~p~p~n", [self(), Soluzione1, Soluzione2]),
                        Master ! {self(), lists:merge(Soluzione1, Soluzione2)} 
                        self()! stop                         
                end;                                                           
                                                                               
            Stop ->                                                            
                io:format("~p ha ricevuto il messaggio ~p~n", [self(), Stop])                                       
        end,                                                                                           
    loopSlave(Master).                                                         
                                                                                                                               
                                                                                                                                               
%function that sends two sub processes parts of the message                                                                                    
smista(S) ->                                                                                                                                   
    S1 = spawn(?MODULE, startSlave, [self()]),                                
    S2 = spawn(?MODULE, startSlave, [self()]),                                
    io:format("divido la stringa: [~p]~n", [S]),                              
    {Prima, Seconda} = lists:split(round(length(S)/2), S),                               
    io:format("prima parte: ~p, seconda parte: ~p~n", [Prima, Seconda]),                                                                          
                    S1 ! {self(), Prima},                                                                                                             
                    S2 ! {self(), Seconda}.                                                                                                  
                                                                        
                                                                        
                                                                        