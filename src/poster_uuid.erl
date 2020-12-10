-module(poster_uuid).

-export([generate/0]).

generate() ->
    <<  A1:4/binary,
        A2:4/binary,
        A3:4/binary,
        A4:4/binary
    >> = crypto:strong_rand_bytes(16),
    <<B1:4/binary,B2:4/binary>> = to_hex(A2),
    <<B3:4/binary,B4:4/binary>> = to_hex(A3),
    <<(to_hex(A1))/binary,"-",B1/binary,
        "-",B2/binary,"-",B3/binary,"-",
        B4/binary,(to_hex(A4))/binary>>.

to_hex(<<
    A1:1/unit:4,
    A2:1/unit:4,
    A3:1/unit:4,
    A4:1/unit:4,
    A5:1/unit:4,
    A6:1/unit:4,
    A7:1/unit:4,
    A8:1/unit:4
>>) ->
    <<  (binhex(A1)),
        (binhex(A2)),
        (binhex(A3)),
        (binhex(A4)),
        (binhex(A5)),
        (binhex(A6)),
        (binhex(A7)),
        (binhex(A8))
    >>.
binhex(0) -> $0;
binhex(N) when N =< 5 ->
    case N of
        1 -> $1;
        2 -> $2;
        3 -> $3;
        4 -> $4;
        5 -> $5
    end;
binhex(N) when N =< 10 ->
    case N of
        6 -> $6;
        7 -> $7;
        8 -> $8;
        9 -> $9;
        10 -> $a
    end;
binhex(N) when N =< 15 ->
    case N of
        11 -> $b;
        12 -> $c;
        13 -> $d;
        14 -> $e;
        15 -> $f
    end.
