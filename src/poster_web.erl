-module(poster_web).

-export([init/2]).

init(Req0,State) ->
    Req = cowboy_req:reply(
        200,
        #{<<"content-type">> => <<"text/html">>},
        <<"Hello World">>,
        Req0
    ),
    {ok,Req,State}.
