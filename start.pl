:- consult('board.pl').
:- consult('players.pl').
:- consult('game.pl').
:- consult('graphics.pl').

% Pour plus de clarté, ce document se lit de bas en haut (en partant de la boucle de lancement du jeu) ((pas tjr, dsl, rip, mybad -- Sel))
% Le programme/jeu débute par le menu et est constitué de plusieurs tours (correspondant au tour d'un autre joueur).
% Chaque joueur peut effectuer 2 actions, sauf s'il décide d'éléminer quelqu'un (correspondant à 2 actions d'un coup)

% Nomenclature :
%   b : boucle
%   c : choix effectue
%   g : graphique/affichage
%   a : action
%   r : recherche

% ---- CHOIX PRIT PAR L'UTILISATEUR ----
c_NotImplemented :- nl,
    writeln('NOT IMPLEMENTED YET').

c_Deplacer :- c_NotImplemented.
c_Eliminer :- c_NotImplemented.
c_Controler :- c_NotImplemented.

c_ConsulterPersonnagesVivant :- 
    findall((I,Pos), personnage(I,Pos,vivant), ListePersonnages),
    g_PersonnagesVivant(ListePersonnages).

c_VoirPlateau :-
    g_NettoieEcran,
    b_VoirCasesPlateau.

c_IA :- c_NotImplemented.

c_CreationPartie(NbJoueurs):- 
    g_NbJoueurs(NbJoueurs),
    a_CreerJoueurs(NbJoueurs),
    b_Partie.

% ---- BOUCLES DE CHOIX ----
b_VoirCasesPlateau :-
    repeat,
        g_Terrain,
        g_QuestionChoisireCase,
        g_QPourQuitter, g_Repondre(Choix),
        (
            Choix == 'q' -> g_NettoieEcran, !, fail;
            case(Choix, _) -> ( % détailler les personnage sur la case Choix
                findall(I, (personnage(I,Choix,vivant), \+ policier(I)), Personnages),
                g_PersonnagesSurCase(Choix, Personnages)
            );
            g_ChoixNonExistant, fail
        ),
        g_NettoieEcranMaisAttendUnPeutQuandMeme.

b_ActionsPrincipales :- 
    repeat,
        g_Terrain,
        g_QuestionActionSouhaitee,
        g_Repondre(Choix),
        (
            Choix == exit -> halt;
            Choix == 1 -> c_Deplacer, !;
            Choix == 2 -> c_Eliminer, !;
            Choix == 3 -> c_Controler, !;
            Choix == 4 -> c_VoirPlateau;
            Choix == 5 -> c_ConsulterPersonnagesVivant;
            Choix == 6 -> c_IA;
            g_ChoixNonExistant, fail
        ),
        g_NettoieEcranMaisAttendUnPeutQuandMeme.

b_Partie :-
    r_TousLesJoueurs(ListeJoueurs),
    g_Joueurs(ListeJoueurs),
    g_DebutPartie,
    repeat,
        nth0(N, ListeJoueurs, JoueurEnCours),
        between(1, 2, I),
            g_JoueurEnCours(JoueurEnCours, N),
            g_EtatAction(I),
            b_ActionsPrincipales,
        fail.
        %N is N+1 mod 3. % lol y en a pas besoin, et de toute facon il est jaja execute (rien n'est execute apres un 'fail , _') et en faite Prolog fait le cafe tout seul pasque nth0(N,_,_) vas trouver tout seul toutes les valeurs de N possible et grace au repeat il retry depuis N=0 après avoir fait tous les indices... big brain right hear!
        
b_LancementJeu :-
    prompt(_,''), % pour enlever le '|:' dégeulasse de prolog
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

:-b_LancementJeu.
