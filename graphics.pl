:- dynamic personnage/3.
:- dynamic policier/1.
:- dynamic case/2.

% ---- PARTIE ECRANS AUTOMATIQUES (documenter c'est difficile) ----
:- abolish(screenStack, 1).
:- assert(screenStack([])).

% ajoute un ecran a re-afficher automatiquement quand on fait appel a g_NettoieEcran[..]
g_PushEcran(Elm) :-
    screenStack(S1), append(S1, [Elm], S2),!, % S1.push(Elm) ; S2 <- S1
    %write('@ push l\'ecran '), writeln(Elm),
    retract(screenStack(S1)), assert(screenStack(S2)). % maj du stack en memoire

% retire le dernier ecran ajouter au re-affichage automatique
g_PopEcran(Elm) :-
    screenStack(S1), append(S2, [Elm], S1),!, % Elm = S1.pop() ; S2 <- S1
    %write('@ pop l\'ecran '), writeln(Elm),
    retract(screenStack(S1)), assert(screenStack(S2)). % maj du stack en memoire

g_AffichePileEcrans :- screenStack(S), \+ g_AffichePileEcrans(S).
g_AffichePileEcrans([H|T]) :-
    %write('@ affichage de '), writeln(H),
    call(H), g_AffichePileEcrans(T).

g_NettoieEcran :- nl,
    write('\e[2J'),
    %screenStack(S), length(S, N), write('@ '), write(N), writeln(' ecrans empiles'),
    g_AffichePileEcrans.

g_NettoieEcranMaisAttendUnPeutQuandMeme :- nl,
    write('Appuyer sur entrer pour continuer.'),
    current_input(Stream), read_pending_codes(Stream, _, _), % vide le buffer du input stream (sinon ca override le get_char, wtf prolog)
    get_char(_), % attend qu'on appuie sur 'enter'
    current_input(Stream), read_pending_codes(Stream, _, _), % re-vide le buffer (si on a entrer d'autre charactères avant 'entrer') pour pas casser le pauvre interpreter qu'a l'air d'avoir deja bien du mal avec la catastrophe qu'est le language qu'on l'oblige a lire... btw ma touche 'a' commence a me lacher... et la '1' aussi...
    g_NettoieEcran.


% ---- PARTIE GRAPHIQUE (questions, affichage des reponses, des choix etc) ----
g_Titre :- nl,
    writeln('      -------------------------------- '),
    writeln('     |       10 MINUTES TO KILL       |'),
    writeln('     |       ~ A PROLOG GAME! ~       |'), 
    writeln('      -------------------------------- ').

g_QPourQuitter :- nl,
    writeln('(q pour quitter)').

g_RetourAuMenu :- nl,
    writeln('  Retour au menu  ').

g_QuestionNbJoueurs :- nl,
    write('     Combien de joueurs vont participer (2 a 4 max) ?'),
    g_QPourQuitter.

g_QuestionChoisireCase :- nl,
    write('     Choisissez une case (entrez X,Y)').

g_QuestionChoisirePersonnage :- nl,
    write('     Entrer le nom d\'un personnage').

g_Repondre(Choix) :- nl,
    write('      --> Votre choix (avec un point a la fin) : '),
    read(Choix).

g_ChoixNonExistant :- nl,
    writeln('     Erreur: ce choix n\'est pas disponible. Veuillez recommencer.').

g_NbJoueurs(NbJoueurs) :- nl,
    write('           ---- '), nl,
    write('          | -> | Cette partie a '), write(NbJoueurs), writeln(' joueurs'),
    write('           ---- '), nl.

g_Joueurs(ListeJoueurs) :-
    write('          Ces joueurs sont : '),
    writeln(ListeJoueurs).

g_DebutPartie :- nl, nl,   
    writeln('      -------------------------------- '),
    writeln('     |     QUE LA PARTIE COMMENCE !   |'),
    writeln('      -------------------------------- ').

g_JoueurEnCours(JoueurEnCours, N) :- nl,
    write('          C\'est au tour de : '), write(JoueurEnCours), write(' (joueur no '), write(N), write(')').

g_EtatAction(I) :- nl,
    write('           --------------- '), nl,
    write('          | Action no '), write(I), writeln('/2 |'),
    write('           --------------- '), nl.

g_QuestionActionSouhaitee(joueur(Tueur,_)) :- nl,
    personnage(Tueur,_,vivant),  % Si le tueur du joueur est vivant
    writeln('     Que voulez-vous faire ?'), nl, nl,
    writeln('          --> AGIR <--'), nl,
    writeln('      ---                            ---'),
    writeln('     | 1 | Deplacer un personnage   | 2 | Eliminer un personnage'),
    writeln('      ---                            ---'), 
    writeln('      ---  Controler l\'identite     '),
    writeln('     | 3 |   d\'un personnage a      '),
    writeln('      ---  l\'aide d\'un policier    '), nl, nl,
    writeln('          --> ou CONSULTER <--'), nl,
    writeln('      ---                            ---      Consulter les    '),
    writeln('     | 4 | Voir le plateau          | 5 | personnages/policiers'),
    writeln('      ---                            ---        vivants       '),
    writeln('      ---                            '),
    writeln('     | 6 | Se faire conseiller       '),
    writeln('      ---                            '),!;
    % Si le tueur à gage du joueur est vivant
    writeln('     Que voulez-vous faire ?'), nl, nl,
    writeln('          --> AGIR <--'), nl,
    writeln('      ---                            ---'),
    writeln('     | 1 | Deplacer un personnage   | 2 | Votre tueur a gage est mort'),
    writeln('      ---                            ---'), 
    writeln('      ---  Controler l\'identite     '),
    writeln('     | 3 |   d\'un personnage a      '),
    writeln('      ---  l\'aide d\'un policier    '), nl, nl,
    writeln('          --> ou CONSULTER <--'), nl,
    writeln('      ---                            ---      Consulter les    '),
    writeln('     | 4 | Voir le plateau          | 5 | personnages/policiers'),
    writeln('      ---                            ---        vivants       '),
    writeln('      ---                            '),
    writeln('     | 6 | Se faire conseiller       '),
    writeln('      ---                            ').

g_PersonnagesVivant(ListePersonnages) :- nl,
    writeln(ListePersonnages).

g_PersonnagesSurCase(Pos, ListePersonnages) :- nl,
    length(ListePersonnages, N),
    (N == 1 , Pluriel = '' ,!; Pluriel = 's'),
    write('Le'), write(Pluriel), write(' personnage'), write(Pluriel), write(' sur la case '), write(Pos),
    (N == 1 , write(' est :') ,!; write(' sont :')),
    g_PersonnagesVivant(ListePersonnages).

g_VousAvezChoisiDeplacer(Pers, Pos) :- nl,
    write('     Vous avez choisi de deplacer "'), write(Pers),
    write('" qui est en position : '), writeln(Pos).

g_PersoSeDeplacerEn(Pers, Pos, Position) :- nl,
    write('     Le prsonnage "'), write(Pers),
    write('" se deplace de '), write(Pos),
    write(' jusqu\'en '), writeln(Position).

g_PositionPermetPasTuer(Victime) :- nl,
    write('     La position de votre tueur a gage ne vous permet pas de tuer '), write(Victime), writeln('...').

g_PersonnageEstMort(Victime) :- nl,
    write('     Le personnage "'), write(Victime), writeln('" est mort.').

% ---- PARTIE PLATEAU ----
% +----+
% | Px | -> 'P' si ya un policier, 'x' si c'est une case sniper
% | 42 | -> nombre de personnages sur la case (policiers non comptes)
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
        L == 0, ( % if (ligne 0 
            case((X,Y2), _), % ET case au dessu exist)
            write('+----') ,!
        ) ; ( % else
            case((X2,Y), _), % if (case a gauche existe)
                ( L == 0, write('+') ,!; write('|') ) ,!
            ; % else (le + c'est pour les angles bas-droit des extemitées)
                L == 0,case((X2,Y2), _), write('+') ,!; write('.')
        ), write('....')
    ).

% affiche une case si elle existe, sinon une case vide
displCase(Pos, L) :-
    case(Pos, EstSniper),   % if (il existe une case a Pos) {
        displCaseExist(Pos, L, EstSniper) ,!
    ;                       % } else
        displCaseVide(Pos, L).

% affiche les numéros sur le côté gauche
displNumLigne(J, L) :-
    ( L == 1,
        format('~|~` t~d~2+', [ J ]), write('   ') ,!
    ;
        write('     ')
    ).

% affiche les numéros en haut
displNumColonnes(N) :-
    write('   X '),
    between(0, N, I),
        format('~|~` t~d~3+', [ I ]), write('  '),
    fail.

trouveTailleTerrain(TaillX, TaillY) :-
    findall(X, case((X,_), _), ListX),
    findall(Y, case((_,Y), _), ListY),
    max_list(ListX, TaillX),
    max_list(ListY, TaillY).

% verticalement : permière coordonnée (numéro colonne)
displTerrain() :-
    trouveTailleTerrain(MaxX, MaxY),

    % les limites sont +1 pour afficher le contours bas et droite des cases au bord bas droit du terrain
    LimX is MaxX+1, LimY is MaxY+1,

    nl, write('  '), \+ displNumColonnes(MaxX),
    nl, write('   Y '),

    between(0, LimY, J),
        % scanlines (chaque case fait 3 lignes)
        between(0, 2, L),
            nl, write('  '),
            % comme on va jusqu'a taille+1, on skip dès qu'on a atteint la limite
            ( J == LimY, write('     ') ,!; displNumLigne(J, L) ),
            between(0, LimX, I),
                displCase((I, J), L),
            I == LimX,
        L == 2,
    J == LimY.

g_Terrain :-
    \+ displTerrain(), nl.

g_AnnoncerMeurtre(I,Pos,Policier) :-
    nl,
    writeln(' -----------------'),
    write(' C\'est terrible ! '),
    write(I),write(' est mort sur la case ('),write(Pos),writeln(') !'),
    g_PolicierPresent(Policier).

g_PolicierPresent(policierPasPresent) :- 
    nl,
    write('Aucun policier ne c\'est rendu sur place, evacuez tous les temoins de cette barbarie puis deplacer un policier.'),
    nl.

g_PolicierPresent(Policier) :-
    Policier \= policierPasPresent,
    nl,
    write('Le policier '),write(Policier),write(' c\'est rendu sur place, evacuez tous les temoins de cette barbarie.'),
    nl.
