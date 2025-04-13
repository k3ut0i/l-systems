kochquad1(f, "len 0 rlineto ").
kochquad1(+, "90 rotate ").
kochquad1(-, "270 rotate ").

kq1rule(f, [f, +, f, -, f, -, f, +, f]).
kq2rule(f, [f, +, f, -, f, -, f, f, +, f, +, f, -, f]).

% iter([], []).
% iter([f|Xs], [f, +, f, -, f, -, f, +, f | Ys]) :- iter(Xs, Ys).
% iter([+|Xs], [+|Ys]) :- iter(Xs, Ys).
% iter([-|Xs], [-|Ys]) :- iter(Xs, Ys).

iter(_, [], []).
iter(F, [f|Xs], Ys) :- call(F, f, Y), iter(F, Xs, Ys1), append(Y, Ys1, Ys).
iter(F, [+|Xs], [+|Ys]) :- iter(F, Xs, Ys).
iter(F, [-|Xs], [-|Ys]) :- iter(F, Xs, Ys).

itern(_, X, X, 0).
itern(F, X, Y, N) :- N > 0, !, N1 is N-1, iter(F, X, X1), itern(F, X1, Y, N1).

printps(S, []) :- write(S, "stroke grestore ").
printps(S, [X|Xs]) :- kochquad1(X, L), write(S, L), printps(S, Xs).

draw(Stream, F, X0, Y0, Len, N) :- %start at (X0, Y0) with _f_ Len, N iterations.
    itern(F, [f], Z, N),
    format(Stream, "gsave~n~d ~d translate newpath 0 0 moveto~n", [X0, Y0]),
    format(Stream, "/len ~d def~n", [Len]),
    printps(Stream, Z).

drawquad1(Fname) :-
    open(Fname, write, Stream),
    draw(Stream, kq1rule, 20, 600, 18, 3),
    draw(Stream, kq1rule, 20, 300, 6, 4),
    draw(Stream, kq1rule, 20, 20, 2, 5),
    close(Stream).

drawquad2(Fname) :-
    open(Fname, write, Stream),
    draw(Stream, kq2rule, 20, 710, 128, 1),
    draw(Stream, kq2rule, 20, 440, 32, 2),
    draw(Stream, kq2rule, 20, 165, 8, 3),
    close(Stream).
