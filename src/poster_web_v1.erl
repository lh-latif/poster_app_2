-module(poster_web_v1).

-export([init/2]).

init(Req,State) ->
    #{method := Method, path := <<"/api/v1",Path/binary>>} = Req,
    case {Method,Path} of
        {<<"GET">>,<<"/user/token">>} ->
            get_user_token(Req,State);
        {<<"GET">>,<<"/posts">>} ->
            list_posts(Req,State);
        _ ->
            not_found(Req,State)
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

list_posts(Req,State) ->
    #{rows := Posts} = poster_post:list_post(),
    % io:format("~p~n", [Posts]),
    { ok,
      cowboy_req:reply(
        200,
        #{"Content-Type" => "application/json"},
        jsone:encode(lists:map(fun map_post/1, Posts)),
        Req
      ),
      State
    }.

map_post({Id, Title, Content, UserId, InsertedAt, UpdatedAt}) ->
    [ {<<"id">>, Id},
      {<<"title">>, Title},
      {<<"content">>, Content},
      {<<"user_id">>, UserId},
      {<<"inserted_at">>, InsertedAt},
      {<<"updated_at">>, UpdatedAt}
    ].


not_found(Req,State) ->
    { ok,
      cowboy_req:reply(404,#{},<<"not found">>,Req),
      State
    }.
