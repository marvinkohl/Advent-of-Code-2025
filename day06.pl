%% -*- mode: prolog; -*-

:- module(day06,
          [file_grand_total/2,
           file_problems/2,
           line_numbers/2,
           problem_result/2
          ]).

:- ensure_loaded("day05").

%% file_grand_total(+File:string, -GrandTotal:integer) is semidet
%
%  True if GrandTotal is the sum of all problem results in the File.

file_grand_total(File, GrandTotal):-
    file_problems(File, Problems),
    maplist(problem_result, Problems, Results),
    foldl(plus, Results, 0, GrandTotal).

%% file_problems(+File:string, -Problems:list) is semidet
%
%  True if Problems are a list of all problems in the File.

file_problems(File, Problems):-
    open(File, read, Stream),
    stream_lines(Stream, Lines),
    close(Stream),
    !,
    lines_problems(Lines, [], Problems).

lines_problems([L1|Ls], [], Problems):-
    line_numbers(L1, LineNumbers),
    !,
    length(LineNumbers, Len),
    length(Acc, Len),
    maplist([X,Y]>>(X=[Y]), Acc, LineNumbers),
    lines_problems(Ls, Acc, Problems).
lines_problems([L1|Ls], A1, Problems):-
    A1 \= [],
    line_numbers(L1, LineNumbers),
    !,
    maplist([X,Y,Z]>>(Z=[X|Y]), LineNumbers, A1, A2),
    lines_problems(Ls, A2, Problems).
lines_problems([L], Acc, Problems):-
    line_operations(L, Operations),
    !,
    maplist([X,Y,Z]>>(reverse(Y, R), X=problem(R, Z)), Problems, Acc, Operations).

line_operations(Line, Operations):-
    normalize_space(string(Normalized), Line),
    split_string(Strings, Normalized),
    maplist(atom_string, Operations, Strings).

%% split_string(-Split:list, +String:string)

split_string(Split, String):-
    sub_string(String, PreSpaceLen, 1, PostSpaceLen, " "),
    !,
    sub_string(String, 0, PreSpaceLen, _, X1),
    Split = [X1|Xs],
    sub_string(String, _, PostSpaceLen, 0, RestString),
    split_string(Xs, RestString).
split_string([String], String).

%% line_numbers(+Line:string, -Numbers:list) is semidet
%
%  True if Numbers is a list of all integers in Line.

line_numbers(Line, Numbers):-
    normalize_space(string(Normalized), Line),
    line_numbers_normalized(Normalized, Numbers).

line_numbers_normalized(Line, Numbers):-
    sub_string(Line, NumberLen, 1, PostSpaceLen, " "),
    !,
    sub_string(Line, 0, NumberLen, _, NumberString),
    number_string(N1, NumberString),
    sub_string(Line, _, PostSpaceLen, 0, RestLine),
    Numbers = [N1|Ns],
    line_numbers_normalized(RestLine, Ns).
line_numbers_normalized(Line, [Number]):-
    number_string(Number, Line).

%% problem_result(+Problem, -Result:integer) is det
%
%  True if Result is the calculated number of the Problem.

problem_result(problem(Numbers, '*'), Result):-
    !,
    foldl(product, Numbers, 1, Result).
problem_result(problem(Numbers, '+'), Result):-
    !,
    foldl(plus, Numbers, 0, Result).

product(N1, N2, Product):-
    Product is N1 * N2.
