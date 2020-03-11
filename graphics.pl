% +----+
% | Px |
% | 42 |
% +----+

displCase(Pos, L) :-
    case(Pos, EstSniper),   % if (il existe une case a Pos) {
    ( L == 0,               %   if (L == 0) première ligne
        write('+----+') ,!
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
        write(' |') ,!
    ; L == 2,               %   if (L == 2) ligne nombre de perso
        findall(I, (personnage(I,Pos,vivant), \+ policier(I)), Personnages),
        length(Personnages, Nombre),
        write('| '),
        format('~|~` t~d~2+', [ Nombre ]),
        write(' |') ,!
    ;
        write('+----+')
    ) ,!
    ;                       % } else
        write('      ').

displNumLigne(J, L) :-
    ( L == 1,
        format('~|~` t~d~3+', [ J ]), write('   ') ,!
    ;
        write('      ')
    ).

displNumColonnes() :-
    write('      '),
    between(0, 5, I),
        format('~|~` t~d~3+', [ I ]), write('   '),
    fail.

% verticalement : permière coordonnée (numéro colonne)
d_Terrain() :-
    \+ displNumColonnes(), nl,
    between(0, 5, J),
        between(0, 3, L),
            nl,
            displNumLigne(J, L),
            between(0, 5, I),
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
