:- consult('board.pl').
:- consult('players.pl').
:- consult('game.pl').
:- consult('graphics.pl').

% Pour plus de clarté, ce document se lit de bas en haut (en partant de la boucle de lancement du jeu) ((pas tjr, dsl, rip, mybad -- Sel))
% Le programme/jeu débute par le menu et est constitué de plusieurs tours (correspondant au tour d'un autre joueur).
% Chaque joueur peut effectuer 2 actions, sauf s'il décide d'éliminer quelqu'un (correspondant à 2 actions d'un coup)

% Nomenclature :
%   b : boucle
%   c : choix effectue
%   g : graphique/affichage
%   a : action
%   r : recherche

% ---- CHOIX PRIT PAR L'UTILISATEUR ----
c_NotImplemented :- nl,
    writeln('NOT IMPLEMENTED YET').

f_Deplacable(Pers, Pos) :- nl,
    repeat,
        writeln('Quel personnage deplacer ? : (entrer le nom du personnage / q pour quitter)'),
        g_Repondre(Pers),
        (
            personnage(Pers,Pos,Vie), Vie=vivant -> nl, write('Vous avez choisi de deplacer "'),write(Pers),write('" qui est en position : '), write(Pos),nl,nl, !;
            Pers = q -> nl, writeln('  Retour au menu  '), !;
            g_ChoixNonExistant
        ),
    \+ fail,
    Pers \= q,
    personnage(Pers,_,Vie),
    Vie=vivant.
    
c_Deplacer(Pers, Pos) :- nl,
repeat,
    write('A quelle position deplacer '),write(Pers),write(' ? : (entrer la position sous forme (X,Y))'),nl,
        g_Repondre(Position),
        (
            a_Deplacer(Pers,Position) -> nl, write('Vous avez choisi de déplacer "'),write(Pers),write('" qui est en position : '), write(Pos),write(' a la position position : '), write(Position),nl, !;
            g_ChoixNonExistant
        ),
    fail.

c_Eliminer(joueur(Tueur,_)) :- 
    nl,
    repeat,
    writeln('Quel personnage tuer ? : (entrer le nom du personnage)'),
        g_Repondre(Victime),
        (
            a_Tuer(Tueur,Victime) -> nl, write('Le personnage "'),write(Victime),write('" est mort.'),nl, !;
            g_ChoixNonExistant
        ),
    fail.

f_TueurIncapable(joueur(Tueur,_)) :-
    \+ personnage(Tueur,_,vivant), write('Votre tueur a gage est mort donc plus de bain de sang possible'),!;
    \+ r_Tuable(Tueur,_),
    write('La position de votre tueur a gage ne vous permet pas de tuer quelqu\'un ...'),!;
    false.

c_Controler :- c_NotImplemented.

c_ConsulterPersonnagesVivant :- 
    findall((I,Pos), personnage(I,Pos,vivant), ListePersonnages),
    g_PersonnagesVivant(ListePersonnages).

c_VoirPlateau :-
    g_NettoieEcran,
    \+ b_VoirCasesPlateau. % les c_.. doivent toujours renvoyer vrai, mais les boucles repeat..fail finissent toujours par faux (note : !=break)

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
            Choix == 'q' -> !;
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
            Choix == exit -> halt;
            Choix == 1, f_Deplacable(Pers, Pos) -> c_Deplacer(Pers, Pos), !;
            Choix == 2, \+ f_TueurIncapable(JoueurEnCours) -> c_Eliminer(JoueurEnCours), !;
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
        between(1, 2, I),
            g_PushEcran(g_EtatAction(I)),
            g_PushEcran(g_Terrain),
            b_ActionsPrincipales(JoueurEnCours),
            g_PopEcran(_), % retire l'affichage du terrain
            g_PopEcran(_), % retire l'affichage du compteur de tour précédent
        I == 2, % (la suite n'est execute que si on arrive à I == 2)
        g_PopEcran(_), % retire l'affichage du nom du joueur précédent
    fail.
        %N is N+1 mod 3. % lol y en a pas besoin, et de toute facon il est jaja execute (rien n'est execute apres un 'fail , _') et en fait Prolog fait le cafe tout seul pasque nth0(N,_,_) vas trouver tout seul toutes les valeurs de N possible et grace au repeat il retry depuis N=0 après avoir fait tous les indices... big brain right hear!
        
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
