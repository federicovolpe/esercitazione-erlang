(*funzione che moltiplica per due tutti gli elementi di una lista*)
 
let rec moltiplica (lista : int list) =
match lista with
|[] -> []
|h :: t -> h*2 :: moltiplica t
;;

let moltiplica(lista: int list) =
List.map(fun x -> x * 2) lista;;

(*data una lista ritorna solo i numeri pari*)

let pari (lista: int list) =
  List.filter(fun x -> x mod 2 = 0) lista;;

(*data una lista di coppie ritornare 
   quelle dove il secondo valore è maggiore di 65*)
let cityweather = [("pittsburgh", 50), ("new york", 53), 
("charlotte",68), ("miami", 78)];;

let rec filtra(lista : 'a list) =
match lista with
|[] -> []
|h :: t -> if h.snd > 65 then h :: filtra t 
            else filtra t