- module(client_general).
- export([richiesta/2]).
richiesta(PidServer,Op) ->
    PidServer ! {Op, self()},
    receive
        {result,X} -> X
    end,
richiesta(ci,ao).
%richiesta(PidServer,X,Y,Op) ->
 %   PidServer ! {}
  %  receive
   %     {}
    %end.