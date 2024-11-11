-module(thunks).
-export([from/1, first/1, is_prime/1, primes/0]).
%
%crea una potenziale lista che parte da K e va avanti all'infinito
from(K) -> [K|fun()->from(K+1)end].

%devo crearmi la funzione filter
filter(_,[]) -> []; %se sono arrivato alla fine della lista allora ritorno nulla
filter(Pred,[H|Tl]) -> % se ho una funzione e una lista in ingresso
  case Pred(H) of %funzione sulla testa della lista
    true -> [H|fun() -> filter(Pred,Tl()) end]; %se si verifica creo la lista e i restanti elementi che verificano
    false -> filter(Pred,Tl) %altrimenti la lista che ritorno non ha la testa
  end.

%significa setacciare
sift(Divisore, Lista) -> %filtra la lista tenendo i numeri che non sono divisibili
                         %utilizza la filter creata in precendenza
    filter(fun(N) -> N rem Divisore /= 0 end, Lista).

%significa setaccio
sieve([H|Tl]) -> %presa una lista compone la lista
    [H|fun() -> sieve %composizione della lista ..
                    (sift(H,Tl())) %tolgo dalla lista gli elementi che sono divisibili per H
                    end].

% This generates the list of prime numbers.
primes() -> sieve(from(2)).

is_prime(N) -> is_prime(N, primes()).%se chiamo su un numero allora chiamo sul numero e la lista di primi
is_prime(N, [N|_])           -> true;%se il numero è la testa della lista di primi -> true
is_prime(N, [M|TL]) when M<N -> is_prime(N, TL()); %se sono arrivato ad un punto della lista dove 
%i numeri sono troppo grandi allora false altrimenti faccio la chiamata ricorsiva
is_prime(_,_)                -> false.

%funzione che mostra i primi N numeri
%funzione fine a se stessa
first(N) -> first(N, primes()).
first(0, _) -> []; %se voglio vedere i primi 0 numeri allora []
first(N, [X|P]) -> [X|first(N-1, P())]. % se chiamo first su n e la lsita allora ritorno la lista
%formata dalla testa e gli altri n-1numeri