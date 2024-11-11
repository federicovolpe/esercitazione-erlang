-module(factors).
-export([factors/1]). %factors/2 non è esportato quindi non può essere chiamato
factors(Value) -> factors(Value, 2). %inizio a trovare i fattori iniziando a dividere per 2
factors(1, _) -> []; %quando il numero è arrivato a 1 allora non ho più altri divisori

factors(Value, Factor) when Value rem Factor =:= 0 -> %se è divisibile per il divisore
    [Factor | factors(Value div Factor, Factor)];%aggiungo il fattore nella lista e richiamo la funzione

factors(Value, Factor) -> %se non è divisibile
    factors(Value, Factor + 1). %richiamo la funzione ma con un divisore maggiorato

