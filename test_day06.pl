%% -*- mode: prolog; -*-

:- module(test_day06, []).
:- use_module(day06).

:- begin_tests(day06).

test(problem_result, Result == 33210):-
    problem_result(problem([123, 45, 6], '*'), Result).
test(problem_result, Result == 490):-
    problem_result(problem([328, 64, 98], '+'), Result).

test(file_problems,
     Result == [problem([123, 45, 6], '*'),
                problem([328, 64, 98], '+'),
                problem([51, 387, 215], '*'),
                problem([64, 23, 314], '+')
               ]
    ) :-
    file_problems("day06_test_input.txt", Result).

test(line_numbers,
     Result == [24, 8, 51, 3]
    ) :-
    line_numbers(" 24  8 51  3", Result).

test(file_grand_total,
     Result == 4277556
    ):-
    file_grand_total("day06_test_input.txt", Result).

:- end_tests(day06).
