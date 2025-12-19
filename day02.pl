%% -*- mode: prolog; -*-

valid_program:-
    invalid_id('55'),
    invalid_id('6464'),
    invalid_id('123123'),
    invalid_id('0101'),
    valid_id('101'),
    invalid_ids(range(11,22), [11, 22]),
    invalid_ids(range(95,115), [99]),
    invalid_ids(range(998,1012), [1010]),
    invalid_ids(range(1188511880,1188511890), [1188511885]),
    invalid_ids(range(222220,222224), [222222]),
    invalid_ids(range(1698522,1698528), []),
    invalid_ids(range(446443,446449), [446446]),
    invalid_ids(range(38593856,38593862), [38593859]),
    added_up_ids([11,22,99,1010,1188511885,222222,446446,38593859], 1227775554),
    added_up_ids_in_file("day02_test_input.txt", 1227775554).

invalid_id(Number):-
    integer(Number),
    number_string(Number, String),
    invalid_id(String).
invalid_id(Atom):-
    atom(Atom),
    atom_string(Atom, String),
    invalid_id(String).
invalid_id(Number):-
    string(Number),
    string_length(Number, Len),
    Len mod 2 =:= 0,
    Half is Len / 2,
    sub_string(Number, 0, Half, Half, X),
    sub_string(Number, Half, Half, 0, X).

valid_id(X):- \+ invalid_id(X).
