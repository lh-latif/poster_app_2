-module(poster_post).

-export([save_post_handler/1]).
-export([list_posts/2]).

save_post_handler(Req0) ->
    {Req, Data} = validate_body(Req0,<<"">>),
    Result =
        case validate_schema(Data) of
            {ok, [Content, Title]} ->
                poster_post_io:save_post(1, Title, Content);
            Error ->
                Error
        end,
    case Result of
        NewPost when is_map(NewPost) ->
            io:format("~p~n",[NewPost]),
            { ok,
              cowboy_req:reply(
                200, #{}, "ok", Req
              ),
              []
            };
        Any ->
            io:format("~p~n",[Any]),
            { ok,
              cowboy_req:reply(
                422, #{}, "error", Req
              ),
              []
            }
    end.

validate_body(Req, Data) ->
    case cowboy_req:read_body(Req) of
        {ok, Data1, Req1} ->
            {Req1, validate_data(<<Data/binary,Data1/binary>>)};
        {next, Data2, Req2} ->
            validate_body(Req2, <<Data/binary,Data2/binary>>)
    end.

validate_data(Data) ->
    case jsone:try_decode(Data,[{object_format, proplist}]) of
        {error, _} ->
            error;
        {_, DecodedData, _} ->
            {ok, DecodedData}
    end.
validation_schema() ->
    [   {name, [is_string, {my_validator, need_one}]},
        {title, [is_string, {title_validator, validate, [{min, 3}, nil]}]},
        {content, [is_string]}
    ].

schema_validator([{Key, ListVal}, Rest]) ->
    if
        (1 == 1) ->
            [ validate_list(0, ListVal, ok) ];
        true ->
            nil
    end.


validate_list(Val, [Head|Rest], Status) ->
    Result = case Head of
        {Mode, Module, Fun, Opt} when (Mode == keep) or ((Status == ok) and (Mode == skip) and true) ->
            Module:Fun(Val,Opt);
        {Mode, Module, Fun} when Mode == keep ->
            Module:Fun(Val)
    end,
    case Result of
        skip ->
            skip;
        ok ->
            ok;
        {error, Message} ->
            Message
    end.

validate_schema(error) ->
    {error, "data_not_valid"};
validate_schema({ok, Data}) ->
    {Left, Right} = lists:foldl(
        fun({Key, Test}, {Left0, Right0}) ->
            case Test() of
                {error, Msg} ->
                    {[{Key, Msg} | Left0], Right0};
                {ok, Value} ->
                    {Left0 , [Value | Right0]}
            end
        end,
        {[],[]},
        [ { title,
            fun() ->
                case proplists:get_value(<<"title">>, Data) of
                    undefined ->
                        {error, "not found"};
                    Value ->
                        {ok, Value}
                end
            end
          },
          { content,
            fun() ->
                case proplists:get_value(<<"content">>, Data) of
                    undefined ->
                        {error, "not found"};
                    Value ->
                        {ok, Value}
                end
            end
          }
        ]
    ),
    case Left == [] of
        true ->
            {ok, Right};
        _ ->
            {error, jsone:encode(Left)}
    end.


list_posts(Req,State) ->
    #{rows := Posts} = poster_post_io:list_post(),
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
