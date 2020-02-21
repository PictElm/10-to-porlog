:-abolish(personnage,3).
:-abolish(policier,3).
:-abolish(case,2).


%personnage(identifiant,(x,y),QuiL'aTué?).
:-assert(personnage(a,(0,3),vivant)). % vivant ou lettre pour avoir index du killer
:-assert(personnage(b,(1,3),vivant)).
:-assert(personnage(c,(1,2),vivant)).
:-assert(personnage(d,(1,1),vivant)).
:-assert(personnage(e,(2,0),vivant)).
:-assert(personnage(f,(2,1),vivant)).
:-assert(personnage(g,(2,3),vivant)).
:-assert(personnage(h,(2,4),vivant)).
:-assert(personnage(i,(2,5),vivant)).
:-assert(personnage(j,(1,5),vivant)).
:-assert(personnage(k,(3,1),vivant)).
:-assert(personnage(l,(3,2),vivant)).
:-assert(personnage(m,(3,3),vivant)).
:-assert(personnage(n,(3,4),vivant)).
:-assert(personnage(o,(4,2),vivant)).
:-assert(personnage(p,(4,3),vivant)).

%case((X,Y),EstCaseSniper).
:-assert(case((0,3),true)).
:-assert(case((1,3),false)).
:-assert(case((1,2),true)).
:-assert(case((1,1),false)).
:-assert(case((2,0),true)).
:-assert(case((2,1),false)).
:-assert(case((2,3),false)).
:-assert(case((2,4),false)).
:-assert(case((2,5),true)).
:-assert(case((1,5),false)).
:-assert(case((3,1),true)).
:-assert(case((3,2),false)).
:-assert(case((3,3),true)).
:-assert(case((3,4),true)).
:-assert(case((4,2),true)).
:-assert(case((4,3),false)).

% personnage(identifiantPolicier,(x,y),QuiL'aTué) : positionné en -1,-1 au début du jeu car pas sur le plateau
:-assert(personnage(p1,nonPose,vivant)).
:-assert(personnage(p2,nonPose,vivant)).
:-assert(personnage(p3,nonPose,vivant)).
:-assert(personnage(p4,nonPose,vivant)).
:-assert(personnage(p5,nonPose,vivant)).
:-assert(personnage(p6,nonPose,vivant)).
:-assert(personnage(p7,nonPose,vivant)).
:-assert(personnage(p8,nonPose,vivant)).

:-assert(policier(p1)).
:-assert(policier(p2)).
:-assert(policier(p3)).
:-assert(policier(p4)).
:-assert(policier(p5)).
:-assert(policier(p6)).
:-assert(policier(p7)).
:-assert(policier(p8)).

