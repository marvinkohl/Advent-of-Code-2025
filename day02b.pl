%% -*- mode: prolog; -*-

main(Result):-
    valid_program,
    writeln("Program is valid"), !,
    added_up_ids_in_file("day02_input.txt", Result).

valid_program:-
    invalid_id('55'),
    invalid_id('6464'),
    invalid_id('123123'),
    invalid_id('0101'),
    invalid_id('12341234'),
    invalid_id('123123123'),
    invalid_id('1212121212'),
    invalid_id('1111111'),
    valid_id('101'),
    writeln("invalid_id/1 is valid"), !,
    invalid_ids(range(11,22), [11, 22]),
    invalid_ids(range(95,115), [99, 111]),
    invalid_ids(range(998,1012), [999, 1010]),
    invalid_ids(range(1188511880,1188511890), [1188511885]),
    invalid_ids(range(222220,222224), [222222]),
    invalid_ids(range(1698522,1698528), []),
    invalid_ids(range(446443,446449), [446446]),
    invalid_ids(range(38593856,38593862), [38593859]),
    invalid_ids(range(565653, 565659), [565656]),
    invalid_ids(range(824824821,824824827), [824824824]),
    invalid_ids(range(2121212118,2121212124), [2121212121]),
    writeln("invalid_ids/2 is valid"), !,
    added_up_ids([11,22,99,111,999,1010,1188511885,222222,446446,38593859,565656,824824824,2121212121], 4174379265),
    writeln("added_up_ids/2 is valid"), !,
    added_up_ids_in_file("day02_test_input.txt", 4174379265),
    writeln("added_up_ids_in_file/2 is valid"), !.

added_up_ids_in_file(File, Sum):-
    file_ranges(File, Ranges),
    maplist(invalid_ids, Ranges, InvalidIdsLists),
    append(InvalidIdsLists, InvalidIds),
    added_up_ids(InvalidIds, Sum).

%% Reading Files
%%
file_ranges(File, Ranges):-
    open(File, read, Stream),
    stream_ranges(Stream, Ranges),
    !,
    close(Stream).

stream_ranges(Stream, []):- at_end_of_stream(Stream).
stream_ranges(Stream, Ranges):-
    \+ at_end_of_stream(Stream),
    read_line_to_codes(Stream, Codes),
    codes_ranges(Codes, CodesRanges),
    stream_ranges(Stream, RestRanges),
    append(CodesRanges, RestRanges, Ranges).

codes_ranges([], []).
codes_ranges(Codes, [range(N1, N2)|RestRanges]):-
    char_code('-', SepCode),
    char_code(',', Sep2Code),
    append([N1Codes, [SepCode], N2Codes, [Sep2Code], RestCodes], Codes),
    number_codes(N1, N1Codes),
    number_codes(N2, N2Codes),
    codes_ranges(RestCodes, RestRanges).
codes_ranges(Codes, [range(N1, N2)]):-
    char_code('-', SepCode),
    append([N1Codes, [SepCode], N2Codes], Codes),
    number_codes(N1, N1Codes),
    number_codes(N2, N2Codes).

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
    sub_string(Number, 0, Len, RestLen, X),
    Len > 0,
    sub_string(Number, Len, RestLen, 0, RestString),
    repeated_string(X, RestString).

%% repeated_string(SubString, String)
repeated_string(X, X).
repeated_string(X, Xs):-
    sub_string(Xs, 0, _, 0, X).
repeated_string(X, Xs):-
    sub_string(Xs, 0, Len, RestLen, X),
    sub_string(Xs, Len, RestLen, 0, RestString),
    repeated_string(X, RestString).

valid_id(X):- \+ invalid_id(X).

%% invalid_ids
invalid_ids(Range, Result):-
    invalid_ids(Range, [], Result).

invalid_ids(range(X, X), Acc, Result):-
    valid_id(X),
    reverse(Acc, Result).
invalid_ids(range(X, X), Acc, Result):-
    invalid_id(X),
    reverse([X|Acc], Result).
invalid_ids(range(X, Y), Acc, Result):-
    X =\= Y,
    valid_id(X),
    Z is X + 1,
    invalid_ids(range(Z, Y), Acc, Result).
invalid_ids(range(X, Y), Acc, Result):-
    X =\= Y,
    invalid_id(X),
    Z is X + 1,
    invalid_ids(range(Z, Y), [X|Acc], Result).

%% added_up_ids
added_up_ids(Input, Result):-
    added_up_ids(Input, 0, Result).

added_up_ids([], Result, Result).
added_up_ids([X|Xs], Acc, Result):-
    Y is Acc + X,
    added_up_ids(Xs, Y, Result).
