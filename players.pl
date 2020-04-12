:- abolish(joueur, 2).

:- dynamic personnage/3.
:- dynamic joueur/2.
:- dynamic dernierTour/0.

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

% ===== j'me met là mais c'est pour par avois de problème de git blabla pouêt =====

% fail si la partie n'est pas encore finit, success otherwise (à utiliser juste après le tour du joueur N)
% @param N   l'indice dans la liste des joueur de celui qui vient de jouer (base 1)
r_EstPartieFinie(N) :-
    % si la condition suivante à déjà été vérifié (ie y a le flag)
    %   alors la partie s'arrete si le N est le dernier joueur
    dernierTour,
    r_TousLesJoueurs(ListeJoueurs),
    length(ListeJoueurs, K),
    N is K-1
    ;
    % trouver si \exists un joueur tq/ \forall ses cibles, bah elles sont mortes
    %   dans ce cas, mettre un flag : la partie fini à la fin du tour
    joueur(_, Cibles),
    forall(member(I, Cibles), ( personnage(I, _, S), S \== vivant )),
    assert(dernierTour),
    g_AttentionDernierTour,
    !,fail
    ;
    % vérifier si la liste de joueur de tueur T encore en vie est vide
    %   dans ce cas, la partie fini imédiatement
    findall(T, ( joueur(T, _), personnage(T, _, vivant) ), []).
