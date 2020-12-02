-module(poster_pgo).

-export([start_link/0]).

pgo_config() ->
    #{  pool_size => 10,
        host => "localhost",
        port => 5432,
        user => "",
        password => "",
        database => ""
    }.

start_link() ->
    pgo_pool:start_link(default, pgo_config()).
