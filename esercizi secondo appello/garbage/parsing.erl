-module(parsing).
-export([parse/2,push/2,pop/1]).

%implementazione di uno stack
push(L,X) ->
    lists:append(L,[X]).

primo([H|_]) -> H.
pop(L) ->
    {primo(lists:reverse(L)),lists:droplast(L)}.

parseparentesis(Buffer) -> %ho trovato una parentesi chiusa
%svuoto le ultime 3 posizioni del buffer
    Secondo = element(1,pop(Buffer)),
    Buffer1 = element(2,pop(Buffer)),
    Operatore = element(1,pop(Buffer1)),
    Buffer2 = element(2,pop(Buffer1)),
    Primo = element(1,pop(Buffer2)),
    Buffer4 = element(2,pop(Buffer2)),
    Buffer3 = element(2,pop(Buffer4)),
        io:format("operazione trovata = ~p ~p ~p~n",[Primo,Operatore,Secondo]),
    case (Operatore) of
        43 -> Risultato = (Primo-48) + (Secondo-48);
        45 -> Risultato = (Primo-48) - (Secondo-48);
        42 -> Risultato = (Primo-48) * (Secondo-48);
        47 -> Risultato = (Primo-48) / (Secondo-48)
    end,
    push(Buffer3, Risultato+48).
parse(Buffer,[]) -> Buffer;

parse(Buffer,[H|T]) ->
    io:format("ho trovato : ~p~n",[H]),
    if(H == 41) -> NewBuffer = parseparentesis(Buffer);
    true -> NewBuffer = push(Buffer, H)
end,
    parse(NewBuffer,T).
    