%% -*- mode: prolog; -*-

main(Result):-
    valid_program,
    total_file_output_joltage("day03_input.txt", Result).

valid_program:-
    maximum_bank_joltage("987654321111111", 98),
    maximum_bank_joltage("811111111111119", 89),
    maximum_bank_joltage("234234234234278", 78),
    maximum_bank_joltage("818181911112111", 92),
    writeln("maximum_bank_joltage/2 is valid"), !,
    total_file_output_joltage("day03_text_input.txt", 357),
    writeln("total_file_output_joltage/2 is valid"), !.

maximum_bank_joltage(Bank, Joltage):-
    bank_joltage(Bank, Joltage),
    \+ (bank_joltage(Bank, X), X > Joltage).

bank_joltage(Bank, Joltage):-
    sub_string(Bank, Pos1, 1, _, C1),
    sub_string(Bank, Pos2, 1, _, C2),
    Pos2 > Pos1,
    string_concat(C1, C2, JoltageAsString),
    number_string(Joltage, JoltageAsString).
