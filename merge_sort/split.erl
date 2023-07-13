- module(split).                                            
- export([main/0]).                                         
                                                            
main() ->                                                   
    S = "a",                                 
    if length(S) > 1 -> io:format("la stringa verrebbe divisa");            
        true -> io:format("la stringa verrebber restituita")                    
    end.                                                    