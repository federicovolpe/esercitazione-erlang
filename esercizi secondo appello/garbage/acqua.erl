-module(acqua).
-export([main/0]).

main() ->
    Array =[1,2,1,2,3,1,4,1],
    io:format("quantità di acqua contenuta nell'array: ~p~n",[Array]),
    calcola(array).

calcola(Calcolati,[H|T]) ->
    if (H == ) ->
        .
    v<?php

function get_role($username, $password) {
  include("conf/conf.php");
  
  //Collegarsi al db
  $conn_string = "host=" . $host .  " dbname=" . $db . " user=" . $user . " password=" . $password;
  $conn = pg_connect($conn_string);
  
  //lanciare la funzione
  $sql = "SELECT role FROM appuser WHERE username = $1 AND password  = $2";
  $params = array(
    $username,
    md5($password)
)
  $resource = pg_prepare($conn, "get_user_role", $sql);
  $resource = pg_execute($conn, "get_user_role", $params);
  
  //ritorno della funzione
  $role = null;
  if ($row = pg_fetch_assoc($resource)) {
    $role = $row['role'];
  }

  return $role;
}

?>