-module(ringFun).                                                                                                                                                           
-export([start/3, create/1, loop/2, loopLast/2]).                                                                                                                           
                                                                                                                                                                          
% Ng -> number of round                                                                                                                                                     
% ArrOfF -> array of functions                                                                                                   
% Input                                                                                                                                              
start(Ng, _, Input) ->                                                                  
    Funzioni = [fun(X) -> X + 1 end,                                                    
                fun(X) -> X + 2 end,                                                    
                fun(X) -> X + 3 end],                                                                                                                                                        
    register(first, spawn(?MODULE, create, [Funzioni])),                                                                                                                          
    first! {Input, Ng}.                                                                                                              
                                                                                                                                 
create([H|T]) -> % function that connects this process with the next one                
    if(length(T) == 0) ->                                                                                                      
        io:format("~nC - il nodo ~p, comunica con ~p, con funzione ~p",[self(), first, H]),                                                                                                             
        loopLast(first, H);                                                             
    true ->                                                                             
        Next = spawn(?MODULE, create, [T]),                                                                                                                                      
        io:format("~nC - il nodo ~p comunica con ~p, con funzione ~p", [self(), Next, H]),                                                                                        
        loop(Next, H)                                                                   
    end.                                                                                                                                                    
                                                                                                                                                                                                                                                                                                    
                                                                                                                                                                                
loop(Next, Function) -> %receive a message an passes to the next processes                                                                                                      
    receive                                                                                                                                                                     
        {Input, Ng} ->                                                                                                                                                          
            io:format("~nM - ~p ha ricevuto un msg , giro n: ~p",[self(), Ng]), 
            Res = Function(Input),                                                                                           
            io:format("~n-- invio ~p a ~p",[Res, Next]),                                                                                                                                
            timer:sleep(2000),                                                                                                                                                  
            Next ! {Res, Ng};                                                                                                                                                 
                                                                                                                                                                                
        stop ->                                                                                                                                                                 
                io:format("~nT - il processo ~p termina",[self()]),                                                                 
                Next ! stop,                                                                  
                exit(normal)                                                                                                                      
    end,                                                                                      
    loop(Next, Function).                                                                     
                                                                                              
loopLast(Next, Function) -> % also counts the number of turns                                 
    receive                                                                                   
        {Input, 1} -> % if the last round is over apply the function and return the input     
                Res = Function(Input),                                                        
                io:format("~nT - ~p terminato, ---------------- RISULTATO : ~p -----------------", [self(), Res]),        
                Next ! stop;                                                                  
                                                                                              
        {Input, Ng} ->                                                                        
                io:format("~nM - ~p dice: concluso il ~p giro", [self(), Ng]),                  
                Res = Function(Input),                                                                                           
                io:format("~n-- invio ~p a ~p",[Res, Next]),                                                                                                                                
                timer:sleep(2000),                                                                                                                                                  
                Next ! {Res, Ng-1};                                                           
                                                                                              
        stop ->                                                                               
                io:format("~nT - il processo ~p termina",[self()]),                                              
                exit(normal)                                                 
    end,                                                                      
    loopLast(Next, Function).                                                                      