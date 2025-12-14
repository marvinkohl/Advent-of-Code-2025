%% -*- mode: prolog; -*-

%:- use_module(library(pio)).

main():-
    open('day01_input.txt', read, Stream),
    read_lines(Stream, Rot),
    !,
    close(Stream),
    writeln(Rot),
    length(Rot, RotLen),
    writeln(RotLen),
    count_zeros(Rot, Count),
    writeln(Count).

read_lines(Stream, []):- at_end_of_stream(Stream).
read_lines(Stream, [Rot|Next]):-
    \+ at_end_of_stream(Stream),
    read_line_to_codes(Stream, Line),
    [D|N] = Line,
    char_code(D1, D),
    number_codes(N1, N),
    rotation(D1, N1, Rot),
    read_lines(Stream, Next).

rotation('R', X, right(X)).
rotation('L', X, left(X)).

count_zeros(Rotations, Count):-
    positions(50, Rotations, Count),
    writeln(Positions),
    length(Positions, PosLen),
    writeln(PosLen).

%% Calculation Positions
positions(Position, Rotations, Count):-
    positions(Position, Rotations, 0, Count).

positions(_, [], Count, Count).
positions(Position, [Rotation|Rotations], PreCount, Count):-
    next_position(Position, Rotation, NextPosition, N),
    C is PreCount + N,
    positions(NextPosition, Rotations, C, Count).

%% next_position
next_position(0, left(X), Next, 0):-
    Next is 100-X,
    between(1, 99, Next).
next_position(Pos, Rot, Next, 0):-
    calculated_pos(Pos, Rot, Next),
    between(1, 99, Next).
next_position(Pos, right(X), 0, 1):-
    calculated_pos(Pos, right(X), 100).
next_position(Pos, left(X), 0, 1):-
    calculated_pos(Pos, left(X), 0).
next_position(Pos1, right(X), PosN, Count):-
    Pos1+X > 100,
    next_position(Pos1, right(X1), 0, 1),
    X2 is X-X1,
    next_position(0, right(X2), PosN, Count2),
    Count is 1+Count2.
next_position(Pos1, left(X), PosN, Count):-
    Pos1-X < 0,
    next_position(Pos1, left(X1), 0, 1),
    X2 is X-X1,
    next_position(0, left(X2), PosN, Count2),
    Count is 1+Count2.

calculated_pos(0, right(100), 0).
calculated_pos(0, left(100), 0).
calculated_pos(Pos, right(X), Next):- integer(Pos), integer(X), Next is Pos+X.
calculated_pos(Pos, left(X), Next):- integer(Pos), integer(X), Next is Pos-X.
calculated_pos(Pos, right(X), Next):- integer(Pos), var(X), X is Next-Pos.
calculated_pos(Pos, left(X), Next):- integer(Pos), var(X), X is Pos-Next.

valid_pos(X):- X >= 0, X =< 99.

valid_program:-
    next_position(0, left(818), _, _),
    next_position(50, left(68), 82, 1),
    next_position(52, right(48), 0, 1),
    next_position(0, right(5), 5, 0),
    next_position(0, right(100), 0, 1),
    next_position(0, left(5), 95, 0),
    count_zeros([left(68), left(30), right(48), left(5), right(60), left(55), left(1), left(99), right(14), left(82)], 6).
