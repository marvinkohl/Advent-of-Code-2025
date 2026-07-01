%% -*- mode: prolog; -*-

:- module(day06,
          [file_grand_total/2,
           problem_result/2
          ]).

%% file_grand_total(+File:string, -GrandTotal:integer) is semidet
%
%  True if GrandTotal is the sum of all problem results in the File.

%% problem_result(+Problem, -Result:integer) is det
%
%  True if Result is the calculated number of the Problem.

problem_result(problem(Numbers, '*'), Result):-
    foldl(product, Numbers, 1, Result).
problem_result(problem(Numbers, '+'), Result):-
    foldl(plus, Numbers, 0, Result).

product(N1, N2, Product):-
    Product is N1 * N2.
