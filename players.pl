:- abolish(joueur, 2).

:- dynamic personnage/3.
:- dynamic joueur/2.

% Retire un element aléatoire de List1, l'associe à Elm, et List2 est List1 sans Elm.
pouet(List1, List2, Elm) :-
    length(List1, N),
    random(R),
    K is floor(N*R),
    nth0(K, List1, Elm),
    delete(List1, Elm, List2).

% Construit la liste de N joueurs à partire des personnages dans Personnages.
construireListeJoueur(Personnages, N) :-
    0 < N,
    pouet(Personnages, Personnages_1, Tueur),
    pouet(Personnages_1, Personnages_2, C1),
    pouet(Personnages_2, Personnages_3, C2),
    pouet(Personnages_3, NouveauPersonnages, C3),
    assert(joueur(Tueur, [C1, C2, C3])),
    P is N-1,
    construireListeJoueur(NouveauPersonnages, P).

% Construit la liste de N joueurs à partire des personnages vivants.
a_CreerJoueurs(N) :-
    findall(I, personnage(I,(_,_),vivant), Personnages),
    \+ construireListeJoueur(Personnages, N).

r_TousLesJoueurs(L) :- findall(joueur(X,[A,B,C]),joueur(X,[A,B,C]),L).
