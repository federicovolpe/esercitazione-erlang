- module (reverse).                                              
- export ([main/0]).                                            
                                                                
main() ->                                                       
    %implementare un reverse di una lista                       
    S = [1,2,3,4,5],                                            
    io:format("reverse della lista : ~p~n", [reverse(S,[])]),       
    io:format("ricerca elemento 5: ~p~n",[find(5, S)]),         
    io:format("ricerca elemento 6: ~p~n",[find(6, S)]),         
    io:format("cancellazione elemento 2: ~p~n", [delete(2, S)]).                                
                                                                
reverse([H | T], Acc) ->                                        
    reverse(T, [H | Acc]);                                      
                                                                
reverse([], Acc) ->                                             
    Acc.                                                        
                                                                
find(X, [X | _]) ->                                             
    {found, X};                                                 
                                                                
find(X, []) ->                                                  
    {not_found, X};                                             
                                                                
find(X, [_ | T]) ->                                             
    find(X, T).                                                 
                                                                
delete(X, L) ->                                                 
    delete(X, L, []).                                           
                                                                
delete(_, [], Accum) ->                                         
    Accum;                                                      
                                                                
delete(X, [X | T], Accum) ->                                    
    delete(fine, T, Accum);                                     
                                                                
delete(X, [H | T], Accum) ->                                    
    delete(X, T , Accum ++ [H]).                                 
                                                                