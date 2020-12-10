-module(poster_post_io).

-export([list_post/0]).
-export([save_post/3]).


list_post() ->
    pgo:query(
        "SELECT CAST(id AS varchar), title, "
        "content, user_id, created_at, updated_at FROM post"
    ).

save_post(UserId, Title, Content) ->
    pgo:query(
        "INSERT INTO post(id, user_id, title, content) "
        "VALUES ($1, $2, $3, $4)",
        [poster_uuid:generate(), UserId, Title, Content]
    ).
