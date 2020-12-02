-module(poster_post).

-export([list_post/0]).


list_post() ->
    pgo:query(
        "SELECT CAST(id AS varchar), title, "
        "content, user_id, created_at, updated_at FROM post"
    ).
