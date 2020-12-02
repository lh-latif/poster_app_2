%%%-------------------------------------------------------------------
%% @doc poster_app public API
%% @end
%%%-------------------------------------------------------------------

-module(poster_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    poster_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
