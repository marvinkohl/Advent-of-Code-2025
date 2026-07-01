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
