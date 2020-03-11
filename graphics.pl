% +----+
% | Px |
% | 42 |
% +----+

displCaseExist(Pos, L, EstSniper) :-
    L == 0,               %   if (L == 0) première ligne
        write('+----') ,!
    ; L == 1,               %   if (L == 1) ligne ?policier et ?sniper
        write('| '),
        ( personnage(Perso, Pos, vivant), policier(Perso),
            write('P') ,!
        ;
            write(' ')
        ),
        ( EstSniper == true,
            write('x') ,!
        ;
            write(' ')
        ),
        write(' ') ,!
    ; L == 2,               %   if (L == 2) ligne nombre de perso
        findall(I, (personnage(I,Pos,vivant), \+ policier(I)), Personnages),
        length(Personnages, Nombre),
        write('| '),
        format('~|~` t~d~2+', [ Nombre ]),
        write(' ').

displCaseVide((X,Y), L) :-
    X2 is X-1, Y2 is Y-1,
    (
        L == 0, (
            case((X,Y2), _),
            write('+----') ,!
        ) ; (
            case((X2,Y), _),
                ( L == 0, write('+') ,!; write('|') ) ,!
            ;
                L == 0,case((X2,Y2), _), write('+') ,!; write('.')
        ), write('....')
    ).

displCase(Pos, L) :-
    case(Pos, EstSniper),   % if (il existe une case a Pos) {
        displCaseExist(Pos, L, EstSniper) ,!
    ;                       % } else
        displCaseVide(Pos, L).

displNumLigne(J, L) :-
    ( L == 1,
        format('~|~` t~d~3+', [ J ]), write('  ') ,!
    ;
        write('     ')
    ).

displNumColonnes(N) :-
    write('     '),
    between(0, N, I),
        format('~|~` t~d~3+', [ I ]), write('  '),
    fail.

trouveTailleTerrain(MaxX, MaxY) :-
    findall(X, case((X,_), _), ListX),
    findall(Y, case((_,Y), _), ListY),
    max_list(ListX, MaxX),
    max_list(ListY, MaxY).

% verticalement : permière coordonnée (numéro colonne)
d_Terrain() :-
    trouveTailleTerrain(MaxX, MaxY),
    LimX is MaxX+1, LimY is MaxY+1,
    write(MaxX), nl, write(MaxY), nl,

    \+ displNumColonnes(MaxX), nl,

    between(0, LimY, J),
        between(0, 2, L),
            nl,
            ( J == LimY, write('     ') ,!; displNumLigne(J, L) ),
            between(0, LimX, I),
                displCase((I, J), L),
            fail,
        fail,
    fail.

da() :- d_Terrain().

d_Detail(Pos) :-
    case(Pos, _),
    findall(I, (personnage(I,Pos,vivant), \+ policier(I)), Personnages),
    write('Les personnages sur la case '), write(Pos), write(' sont :'), nl,
    write(Personnages).
