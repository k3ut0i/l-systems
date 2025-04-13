grule(a, [a, -, b, -, -, b, +, a, +, +, a, a, +, b, -]).
grule(b, [+, a, -, b, b, -, -, b, -, a, +, +, a, +, b]).

iter(_, [], []).
iter(F, [a|Xs], Ys) :- call(F, a, Y), iter(F, Xs, Ys1), append(Y, Ys1, Ys).
iter(F, [b|Xs], Ys) :- call(F, b, Y), iter(F, Xs, Ys1), append(Y, Ys1, Ys).
iter(F, [+|Xs], [+|Ys]) :- iter(F, Xs, Ys).
iter(F, [-|Xs], [-|Ys]) :- iter(F, Xs, Ys).

itern(_, X, X, 0).
itern(F, X, Y, N) :- N > 0, !, N1 is N-1, iter(F, X, X1), itern(F, X1, Y, N1).

gosperps(a, "len 0 rlineto ").
gosperps(b, "len 0 rlineto ").
gosperps(+, "60 rotate ").
gosperps(-, "300 rotate ").

printps(S, []) :- write(S, "stroke grestore ").
printps(S, [X|Xs]) :- gosperps(X, L), write(S, L), printps(S, Xs).

drawg(Stream, F, X0, Y0, Len, N) :- %start at (X0, Y0) with _f_ Len, N iterations.
    itern(F, [a], Z, N),
    format(Stream, "gsave~n~d ~d translate newpath 0 0 moveto~n", [X0, Y0]),
    format(Stream, "0.5 setlinewidth /len ~d def~n", [Len]),
    printps(Stream, Z).

drawgosper(Fname) :-
    open(Fname, write, Stream),
    drawg(Stream, grule, 480, 650, 4, 5),
    close(Stream).

