:- consult('board.pl').
:- consult('players.pl').
:- consult('game.pl').
:- consult('graphics.pl').

% Pour plus de clarté, ce document se lit de bas en haut (en partant de la boucle de lancement du jeu)
% Le programme/jeu débute par le menu et est constitué de plusieurs tours (correspondant au tour d'un autre joueur).
% Chaque joueur peut effectuer 2 actions, sauf s'il décide d'éliminer quelqu'un (correspondant à 2 actions d'un coup)

% Nomenclature :
%   b : boucle
%   c : choix effectue
%   g : graphique/affichage
%   a : action
%   r : recherche
%   f : Martin

% ---- CHOIX PRIT PAR L'UTILISATEUR ----
c_NotImplemented :- nl,
    writeln('NOT IMPLEMENTED YET').

f_Deplacable(Pers, Pos) :- nl,
    g_NettoieEcran,
    repeat,
        nl, write('Quel personnage deplacer ?'),
        g_QuestionChoisirePersonnage,
        g_QPourQuitter,
        g_Repondre(Pers),
        (
            personnage(Pers,Pos,Vie), Vie=vivant -> g_PushEcran(g_VousAvezChoisiDeplacer(Pers, Pos)), !;
            Pers = q -> g_RetourAuMenu, !;
            g_ChoixNonExistant, g_NettoieEcranMaisAttendUnPeutQuandMeme
        ),
    Pers \= q,
    personnage(Pers,_,Vie),
    Vie=vivant.

c_Deplacer :- nl,
    f_Deplacable(Pers, Pos),
    \+ b_ActionDepacer(Pers, Pos).

b_ActionDepacer(Pers, Pos) :-
    g_NettoieEcran,
    repeat,
        nl, write('A quelle position deplacer '), write(Pers),
        g_QuestionChoisireCase,
        nl,
        g_Repondre(Position),
        (
            a_Deplacer(Pers, Position) -> g_PopEcran(_), % retire 'g_VousAvezChoisiDeplacer'
                                          g_PersoSeDeplacerEn(Pers, Pos, Position), !;
            g_ChoixNonExistant, g_NettoieEcranMaisAttendUnPeutQuandMeme
        ),
    fail.

c_Eliminer(joueur(Tueur,_)) :- 
    \+ f_TueurIncapable(Tueur),
    b_ActionEliminer(Tueur).

b_ActionEliminer(Tueur) :-
    g_NettoieEcran,
    repeat,
        nl, writeln('Quel personnage tuer ?'),
        g_QuestionChoisirePersonnage,
        g_QPourQuitter,
        g_Repondre(Victime),
        (
            Victime = q -> g_RetourAuMenu, ATuer = false, !;
            \+ r_Tuer(Tueur, Victime), g_PositionPermetPasTuer(Victime), ATuer = false ;
            a_Tuer(Tueur, Victime) -> g_PersonnageEstMort(Victime), ATuer = true, !;
            g_ChoixNonExistant, g_NettoieEcranMaisAttendUnPeutQuandMeme, ATuer = false
        ),
    Victime \= q,
    ATuer = true.

f_TueurIncapable(Tueur) :-
    \+ personnage(Tueur,_,vivant), g_PlusDeTueur, !;
    \+ r_Tuable(Tueur,_), g_PositionPermetPasTuer('quelqu\'un'), !;
    victime(_,_,_), nl,writeln('Vous ne pouvez faire qu\'une victime par tour'),!; % Une seule victime possible par tour
    false.

c_Controler :- c_NotImplemented.

c_ConsulterPersonnagesVivant :- 
    findall((I,Pos), personnage(I,Pos,vivant), ListePersonnages),
    g_PersonnagesVivant(ListePersonnages).

c_VoirPlateau :-
    g_NettoieEcran,
    \+ b_VoirCasesPlateau.

c_IA :-
    writeln('Un conseil ? Ne fait pas du Porlog !').

c_CreationPartie(NbJoueurs):- 
    g_NbJoueurs(NbJoueurs),
    a_CreerJoueurs(NbJoueurs),
    b_Partie.

% ---- BOUCLES DE CHOIX ----
b_VoirCasesPlateau :-
    repeat,
        g_QuestionChoisireCase,
        g_QPourQuitter,
        g_Repondre(Choix),
        (
            Choix = q -> g_RetourAuMenu, !;
            case(Choix, _) -> (
                findall(I, (personnage(I,Choix,vivant), \+ policier(I)), Personnages),
                g_PersonnagesSurCase(Choix, Personnages),
                g_NettoieEcranMaisAttendUnPeutQuandMeme
            );
            g_ChoixNonExistant, g_NettoieEcranMaisAttendUnPeutQuandMeme
        ),
    fail.

b_ActionsPrincipales(JoueurEnCours) :-
    repeat,
        g_NettoieEcranMaisAttendUnPeutQuandMeme,
        g_QuestionActionSouhaitee(JoueurEnCours),
        g_Repondre(Choix),
        (
            (Choix == exit ; Choix == q) -> halt;
            Choix == 1 -> c_Deplacer, !;
            Choix == 2 -> c_Eliminer(JoueurEnCours), !;
            Choix == 3 -> c_Controler, !;
            Choix == 4 -> c_VoirPlateau;
            Choix == 5 -> c_ConsulterPersonnagesVivant;
            Choix == 6 -> c_IA;
            g_ChoixNonExistant
        ),
    fail.

b_Partie :-
    r_TousLesJoueurs(ListeJoueurs),
    g_Joueurs(ListeJoueurs),
    g_DebutPartie,
    repeat,
        nth0(N, ListeJoueurs, JoueurEnCours),
        g_PushEcran(g_JoueurEnCours(JoueurEnCours, N)),
        a_EvacuerZone,   %%%% -------------------- Peut etre mieux le placer, l'affichage est pas ouf
        between(1, 2, I),
            g_PushEcran(g_EtatAction(I)),
            g_PushEcran(g_Terrain),
            \+ b_ActionsPrincipales(JoueurEnCours),
            g_PopEcran(_), % retire l'affichage du terrain
            g_PopEcran(_), % retire l'affichage du compteur de tour précédent
        I == 2, % (la suite n'est execute que si on arrive à I == 2)
        g_PopEcran(_), % retire l'affichage du nom du joueur précédent
    fail.

b_LancementJeu :-
    prompt(_,''), % pour enlever le '|:' dégeulasse de prolog
    g_PushEcran(g_Titre),
    g_NettoieEcran,
    repeat,
        g_QuestionNbJoueurs,
        g_Repondre(Choix),
        (
            % Ce qui est inséré doit être un chiffre entier de 2 à 4 sinon on reboucle
            integer(Choix), Choix > 1, Choix < 5 -> c_CreationPartie(Choix), !;
            Choix == 'q' -> halt;
            g_ChoixNonExistant, fail
        ).

:- %guitracer, trace,
   b_LancementJeu.
