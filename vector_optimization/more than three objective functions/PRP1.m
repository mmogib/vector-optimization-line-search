 clear,clc
%% Read data
n=50;
m=n-1; 
Loop=100; 
Rloopk=zeros(Loop,1);
Rloopnf=zeros(Loop,1);
Rloopng=zeros(Loop,1);
Rloopnv=zeros(Loop,1);
Rloopt=zeros(Loop,1);
Rloopchu=zeros(Loop,m);
for iLoop=1:Loop
 %%  Initialization
     tic;
     nv=1;
     k=1;
     nf=1;
     ng=1;
     alphamax=10^10;
     S1 = load('Toi10507.mat');
     BP1 = struct2cell(S1);
     Mymat1 = cell2mat(BP1);
     x0=Mymat1(1:n,iLoop);
     xk=Mymat1(1:n,iLoop);
     R=g(x0);
     r=[];
     for i=1:m
         r1=1/max(1,norm(R(i,1:n),inf));
         r=[r,r1];
     end
     r1=repmat(r',1,n);
  %   F=r'.*f(xk);
     nf=nf+1;
     %% Solve subproblem
     H=zeros(n+1,n+1);
     H(2:n+1,2:n+1)=eye(n);
     ff=zeros(n+1,1);
     ff(1,1)=1;
     G=g(xk).*r1;
     ng=ng+1;
     A=zeros(m,n+1);
     A(1:m,2:n+1)=G;
     h=-1*ones(m,1);
     A(1:m,1)=h;
     b=zeros(m,1);
     xx=ones(n+1,1);
     [dd,sitak]= quadprog(H,ff,A,b,[],[],[],[],xx);
     nv=nv+1;
     vk=dd(2:n+1);
     fxkvk=dd(1);
     %% Set stopping precise
     epsilon = 2.22e-16;
     %% Compute direction
     dk=vk;
     %% Compute initial step (k=1)
     alphak=1/norm(dk);
     alphak=max(alphak,1);
     alphak=min(alphak,alphamax);
     %% Main loop
    while 1
        if sitak>=-5*sqrt(epsilon)
            break
        else
          % Compute the stepsize satisfying the Wolfe conditions
          [alphak,nf,ng]=qwolfe(xk,dk,alphak,alphamax,nf,ng,r,r1,m,n);
          fxkvk=max(G*vk);
          x1=xk+alphak*dk;
          F1=r'.*f(x1);
          nf=nf+1;
          H=zeros(n+1,n+1);
          H(2:n+1,2:n+1)=eye(n);
          ff=zeros(n+1,1);
          ff(1,1)=1;
          G1=g(x1).*r1;
          ng=ng+1;
          A=zeros(m,n+1);
          A(1:m,2:n+1)=G1;
          h=-1*ones(m,1);
          A(1:m,1)=h;
          b=zeros(m,1);
          xx=ones(n+1,1);
          [d1,sitak1]= quadprog(H,ff,A,b,[],[],[],[],xx);
          nv=nv+1;
          vk1=d1(2:n+1);
          fxk1vk1=d1(1);
          fxkvk1=max(G*vk1);
          fxkdk=max(G*dk);
          ng=ng+2;
          % Compute betak
          betak=max(0,(-fxk1vk1+fxkvk1)/(-fxkvk));
          dk1=vk1+betak*dk;
          fxk1dk1=max(G1*dk1);
        end
        if  k>=5000
            k=nan;
            nf=nan;
            ng=nan;
            nv=nan;
            break
        end
        k=k+1;
        dk=dk1;
        vk=vk1;
        xk=x1;
        G=G1;
        sitak=sitak1;
      % Compute initial step (k>1)
        alphak=alphak*(fxkdk/fxk1dk1);
        alphak=max(alphak,0.02);
        alphak=min(alphak,100);
    end
    t=toc;
    FF1=f(xk)';
    Rloopk(iLoop)=k;
    Rloopnf(iLoop)=nf;
    Rloopng(iLoop)=ng;
    Rloopnv(iLoop)=nv;
    Rloopt(iLoop)=t;
    Rloopchu(iLoop,1:m)=FF1;
end

