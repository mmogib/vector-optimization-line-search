
function Rloopps=purity(P1,P2,P3)
% Pi: Approximation of Pareto set obtained by a slover for a problem, i=1,2

%P3: $F_p$ be an approximation to the true Pareto front of problem $p$, 
% calculated by first forming $\cup_{z\in Z}F_{p,z}$ and then removing from this set any dominated points.
% $Z$ be the set of solvers.

s=2;
Rloop=zeros(1,s);
Rloopps=zeros(1,s);
SS1=size(P1,1);
SS2=size(P2,1);
SS3=size(P3,1);
Z1=intersect(P1,P3,'rows'); %compute PF_ps与PF_p的交
a=size(Z1,1);
Z2=intersect(P2,P3,'rows'); %compute PF_ps与PF_p的交
b=size(Z2,1);
tps1=a/SS3;
tps2=b/SS3;
Rloop(1,1:s)=[tps1,tps2];
tp1_=1/tps1;
tp2_=1/tps2;
Rloopps(1,1:s)=[tp1_,tp2_];
end
