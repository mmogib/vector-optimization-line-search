
function Rloopps=purity(P1,P2,P3)
% P1: Approximation of Pareto set, P=paretofront(F1);
% P2: Approximation of Pareto set, P=paretofront(F2);
% F1: a solution set found by a solver on a problem.
% F2: a solution set found by a solver on a problem.

%P3: $F_p$ be an approximation to the true Pareto front of problem $p$, 
% calculated by first forming $\cup_{z\in Z}F_{p,z}$ and then removing from this set any dominated points.
% $Z$ be the set of solvers.

s=2;
Rloop=zeros(1,s);
Rloopps=zeros(1,s);
SS1=size(P1,1);
SS2=size(P2,1);
Z1=intersect(P1,P3,'rows'); %compute PF_ps与PF_p的交，s=1
a=size(Z1,1);
Z2=intersect(P2,P3,'rows'); %compute PF_ps与PF_p的交，s=1
b=size(Z2,1);
tps1=a/SS1;
tps2=b/SS2;
Rloop(1,1:s)=[tps1,tps2];
tp1_=1/tps1;
tp2_=1/tps2;
Rloopps(1,1:s)=[tp1_,tp2_];
end