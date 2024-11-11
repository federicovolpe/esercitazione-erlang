-module(mm).                                                
- export([start/1, init/2, rec/1, mm/3]).                             
                                                            
start(S) ->                                                 
    Sender = spawn(?MODULE, init, [S, 0]),                  
    Receiver = spawn(?MODULE, rec, [Sender]),               
    register(mm1, spawn(?MODULE, mm, [Sender, Receiver, 1])),                      
    register(mm2, spawn(?MODULE, mm, [Sender, Receiver, 2])).
                                                            
init (S, X) ->                                              
    if (X < 3) ->                                           
        receive                                             
            ok -> init(S, X+1)                              
        end;                                                
    true ->                                                 
        send(S)                                             
end.                                                        
                                                            
send(S) ->                                       
    L= lists:split(3, S).
   % mm1 ! L1,                                    
   % mm2 ! L2.                                    
                                                 
mm(Sender, Receiver, Id) ->                      
    Sender ! ok,                                 
    loopmm(Receiver, Id).                        
                                                 
loopmm(Receiver, Id) ->                          
    receive                                      
        L -> Receiver ! {Id, lists:reverse(L)}   
    end.                                         
                                                 
rec(Sender) ->                                   
    Sender ! ok,                                                    
    looprec().                                                    
                                                                     
looprec() ->                                                          
    receive                                                       
        {X, ResX} ->                                              
            receive                                               
                {Y, ResY} ->                                      
                    if (X < Y) ->                                   
                        io:format("risultato : ~p~n",[ ResX ++ ResY]);    
                    true ->                                           
                        io:format("risultato : ~p~n",[ ResY ++ ResX])
                    end                                   
            end                                                       
    end.                                                             
                                                                      
                                                                      
                                                                      
                                                                      
                                                                      