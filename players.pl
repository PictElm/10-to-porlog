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

% ---- FIN DE PARTIE ----

% fail si la partie n'est pas encore finit, success otherwise (à utiliser juste après le tour du joueur N)
% @param N   l'indice dans la liste des joueur de celui qui vient de jouer (base 0 -- je crois)
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
    !,
    % si c'est déjà le dernier joueur à jouer
    %   du coup la partie finie effectivement immédiatement
    r_TousLesJoueurs(ListeJoueurs),
    length(ListeJoueurs, K),
    N is K-1 % si c'est pas le dernier, ici ça fail et du coup ça finit pas la partie
    ;
    % vérifier si la liste de joueur de tueur T encore en vie est vide
    %   dans ce cas, la partie fini imédiatement
    findall(T, ( joueur(T, _), personnage(T, _, vivant) ), []).


% SCORE BLABLA

% nombre de personnage avec le status `Stat` parmis la liste précisée (`[Cible|Autres]`)
nombrePersoAvecStatus(_, [], 0) :- !.
nombrePersoAvecStatus(Stat, [Cible|Autres], N) :-
    nombrePersoAvecStatus(Stat, Autres, P),
    (
        personnage(Cible, _, Stat), % if (Cible.status = Stat)
            N is P + 1              %     return N = P+1;
        ,!;                         % else
            N is P                  %     return N = P;
    ).

% nombre de cibles tués parmis la liste donnée
nombreEliminations(Tueur, Parmis, Nb) :- nombrePersoAvecStatus(Tueur, Parmis, Nb).

% nombre de tueurs révélé par ce joueur parmis tous les tueurs (..contrôlés par un joueur)
nombreArrestations(JoueurN, Persos, Nb) :- nombrePersoAvecStatus(JoueurN, Persos, Nb).

% @param JoueurN   numero du joueur (base 0)
% @return Score    score du joueur
r_ScoreJoueur(JoueurN, Score) :-
    r_TousLesJoueurs(ListeJoueurs),
    findall(T, joueur(T, _), ListeTueurs),
    findall(I, ( personnage(I, _, _), \+ joueur(I, _) ), ListeInnocents),
    findall(P, policier(P), ListePoliciers),
    % side note: tous ce qui est juste au dessus est 'global' (as in la même chose) à tous les calculs de score pour chq joueurs.. voilà.. just FYI..
    % (à la limite on peut le sortire de la fonction et mettre tous ces Liste[..] en @param)

    nth0(JoueurN, ListeJoueurs, joueur(Tueur, Cibles)),

    (personnage(Tueur, _, vivant), PtsStatusTueur = 2 ,!; PtsStatusTueur = 0), % +2 pts si tueur non arreté ni eliminé
    nombreEliminations(Tueur, Cibles, NombreEliminations), % chq élimination d'une cible compte pour 1 pt
    nombreArrestations(JoueurN, ListeTueurs, NombreArrestations), % chq arrestation compte pour 1 pt
    nombreEliminations(Tueur, ListeTueurs, NombreElimAdversaires), % chq élimination d'un tueur compte pour 3 pts
    nombreEliminations(Tueur, ListeInnocents, NombreElimInnocents), % chq élimination d'un innocent prend 1 pts
    nombreEliminations(Tueur, ListePoliciers, NombreElimPolicers), % chq élimination d'un policier prend.. beaucoup de pts, pourquoi tu ferait ça ?!

    Score is PtsStatusTueur +1* NombreEliminations +1* NombreArrestations +3* NombreElimAdversaires -1* NombreElimInnocents -1337* NombreElimPolicers.
