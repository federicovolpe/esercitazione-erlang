-module(arithmetic_parser).
-export([parse_expression/1, test/0]).

test() ->
    parse_expression("2+3+4+(5+7)-8").

% il parser chiama se stesso creando una lista
parse_expression(Expression) ->
    parse_expression(Expression, []).

% se la lista è finita restituisce il risultato estraendolo dalla pila
parse_expression([], Stack) ->
    {Result, []} = pop(Stack, []),
    Result;

% caso nel cui si trova il simbolo ~ allora dopo si troverà un numero 
parse_expression([H | T], Stack) when H == $~ ->
    parse_expression(T, [{minus, undefined} | Stack]); %creazione della tupla con minus

    % parser di una espressione nel caso si icontri un simbolo 
parse_expression([H | T], Stack) when H == $+; H == $-; H == $*; H == $/ ->
Operator = parse_operator(H),
parse_expression(T, [{Operator, undefined} | Stack]);

% parser nel caso si incontri una parentesi aperta
parse_expression([H | T], Stack) when H == $( ->
parse_expression(T, [{brace, undefined} | Stack]);

% parser nel caso si incontri una parentesi chiusa
parse_expression([H | T], Stack) when H == $) ->
{ExpressionStack, RestStack} = pop_until_brace(Stack, []),
ParsedExpression = parse_expression_list(ExpressionStack, []),
parse_expression(T, [ParsedExpression | RestStack]);

% caso generico se si tratta di un numero o se si tratta di un simbolo
parse_expression([H | T], Stack) ->
    case is_digit(H) of
        true -> 
            NumberString = parse_number([H | T], []), % ricavo del numero completo
            Number = list_to_integer(NumberString), % trasformazione del numero da stringa a integer
            parse_expression(T, [{num, Number} | Stack]); % aggiunta all'espressione del numero trovato
        false ->
            parse_expression(T, Stack) % se non è un numero allora continuo il parsing senza fare niente
    end.



% in qualsiasi altro caso ritorno un messaggio di errore
%parse_expression(_, _) ->
    %{error, "Invalid expression"}.

% parsing di un numero 
parse_number([H | T], Acc) ->
    case is_digit(H) of
        true -> parse_number(T, [H | Acc]);
        false -> lists:reverse(Acc)
    end;

parse_number(_, Acc) ->
    lists:reverse(Acc).

parse_operator($+) -> plus;
parse_operator($-) -> minus;
parse_operator($*) -> multiply;
parse_operator($/) -> divide.

pop_until_brace([], Acc) ->
    {Acc, []};
pop_until_brace([{brace, undefined} | T], Acc) ->
    {Acc, T};
pop_until_brace([H | T], Acc) ->
    pop_until_brace(T, [H | Acc]).

pop([{Op, undefined} | Rest], Stack) ->
    {{Op, parse_expression_list(Stack, [])}, Rest};
pop(_, _) ->
    {error, "Invalid expression"}.

parse_expression_list(Stack, Acc) ->
    {Result, Rest} = pop(Stack, []),
    case Rest of
        [] -> Result;
        _ -> parse_expression_list(Rest, [Result | Acc])
    end.

is_digit(Char) ->
    case Char of
        $0 -> true;
        $1 -> true;
        $2 -> true;
        $3 -> true;
        $4 -> true;
        $5 -> true;
        $6 -> true;
        $7 -> true;
        $8 -> true;
        $9 -> true;
        _ -> false
    end.