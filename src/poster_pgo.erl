-module(poster_pgo).

-export([start_link/0]).

pgo_config() ->
    {ok, Config} =
        application:get_env(poster, pgo_config),
    Config.

start_link() ->
    pgo_pool:start_link(default, pgo_config()).
