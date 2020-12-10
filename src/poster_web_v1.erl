-module(poster_web_v1).

-export([init/2]).

init(Req,State) ->
    #{method := Method, path := <<"/api/v1",Path/binary>>} = Req,
    case {Method,Path} of
        {<<"GET">>,<<"/user/token">>} ->
            get_user_token(Req,State);
        {<<"GET">>,<<"/posts">>} ->
            poster_post:list_posts(Req,State);
        {<<"POST">>,<<"/posts">>} ->
            check_header_json(Req,
                {poster_post,save_post_handler,[Req]}
            );
        _ ->
            not_found(Req,State)
    end.

check_header_json(Req,MFA) ->
    case cowboy_req:header(<<"content-type">>, Req) of
        <<"application/json">> ->
            {M,F,A} = MFA,
            erlang:apply(M,F,A);
        _ ->
            not_found(Req, [])
    end.

get_user_token(Req,State) ->
    { ok,
      cowboy_req:reply(
        200,
        #{"Content-Type" => "application/json"},
        <<"{\"token\": \"usernotefoundpunintended\"}">>,
        Req
      ),
      State
    }.


not_found(Req,State) ->
    { ok,
      cowboy_req:reply(404,#{},<<"not found">>,Req),
      State
    }.
