-module(poster_webserver).

-export([start_link/0]).

start_link() ->
    cowboy:start_clear(
        poster_webserver_cowboy,
        [{port, 8080}],
        #{env => #{dispatch => dispatcher()}}
    ).


dispatcher() ->
    cowboy_router:compile([
        {'_', [ {"/", poster_web, []},
                {"/api/v1/[...]", poster_web_v1, []}
              ]
        }
    ]).
