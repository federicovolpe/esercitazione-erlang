- module(riconosci).
- export( [get_when/2] ).

%esercizio: scrivere una funzione che dato un set di dati
% e una funzione booleana separi i primi dati che rispettano
% la funzione dal resto

get_when(P,[Ch|Rest]) ->
    case P(Ch) of
        true ->
            {Succeeds, Remainder} = get_when(P,Rest),
            {[Ch,Succeeds], Remainder};
        false ->
            {[],[Ch|Rest]}
        end;

get_when(_P,[]) ->
    {[],[]}.
%funzione(X) ->
% X rem 2 == 0.
