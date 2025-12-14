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
    positions(50, Rotations, Positions),
    writeln(Positions),
    length(Positions, PosLen),
    writeln(PosLen),
    zeros_in_positions(Positions, Count).

%% Calculation Positions
positions(Position, Rotations, Positions):-
    positions(Position, Rotations, [], Positions).

positions(Position, [], PrevPositions, Positions):-
    reverse([Position|PrevPositions], Positions).
positions(Position, [Rotation|Rotations], PrevPositions, Positions):-
    next_position(Position, Rotation, NextPosition),
    positions(NextPosition, Rotations, [Position|PrevPositions], Positions).

%% Count zeros
zeros_in_positions(Positions, Count):-
    zeros_in_positions(Positions, 0, Count).

zeros_in_positions([], Count, Count).
zeros_in_positions([Position|Positions], AccCount, Count):-
    Position =:= 0,
    NextCount is AccCount+1,
    zeros_in_positions(Positions, NextCount, Count).
zeros_in_positions([Position|Positions], AccCount, Count):-
    Position > 0,
    zeros_in_positions(Positions, AccCount, Count).

%% next_position
next_position(Position, right(X), Next):-
    Next1 is Position + X,
    constrain_position(Next1, Next).
next_position(Position, left(X), Next):-
    Next1 is Position - X,
    constrain_position(Next1, Next).

constrain_position(X, X):- X >= 0, X =< 99.
constrain_position(X, Y):- X < 0, Z is X + 100, constrain_position(Z, Y).
constrain_position(X, Y):- X > 99, Z is X - 100, constrain_position(Z, Y).
