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
    mu=1;
    c=0.4;
    ita=0.01;
    a=0;
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
    %F=r'.*f(xk);
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
    hh=-1*ones(m,1);
    A(1:m,1)=hh;
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
         end
         k=k+1;
         epsiki=10^99;
         ss=0;
         %% Inner loop
         while 1
             % Compute the stepsize satisfying the Wolfe conditions
             [alphak,nf,ng]=qwolfe2(xk,dk,alphak,alphamax,epsiki,nf,ng,r,r1,m,n);
             fxkvk=max(G*vk);
             xki=xk+alphak*dk;
             F1=f(xki);
             nf=nf+1;
             H=zeros(n+1,n+1);
             H(2:n+1,2:n+1)=eye(n);
             ff=zeros(n+1,1);
             ff(1,1)=1;
             G1=g(xki).*r1;
             ng=ng+1;
             A=zeros(m,n+1);
             A(1:m,2:n+1)=G1;
             hh=-1*ones(m,1);
             A(1:m,1)=hh;
             b=zeros(m,1);
             xx=ones(n+1,1);
             [d1,sitaki]= quadprog(H,ff,A,b,[],[],[],[],xx);
             nv=nv+1;
             if sitaki>=-5*sqrt(epsilon)
                 a=1;
                 break
             end
             vki=d1(2:n+1);
             fxkivki=d1(1);
             fxkvki=max(G*vki);  
             p=-fxkivki+fxkvki;     
             fxkidk=max(G1*dk);    
             fxkivk=max(G1*vk);               
             q=fxkivk-fxkvk;       
             fxkdk=max(G*dk);     
             % Compute betak
             itak=-1/(norm(dk)*min(ita,norm(vk)));
             betakiHZ=(1/(fxkidk-fxkdk))*(p-mu*fxkidk*((p+q)/(fxkidk-fxkdk)));
             betaki=max(betakiHZ,itak);
             dki=vki+betaki*dk;
             fxkidki=max(G1*dki);           
             if fxkidki<= c*fxkivki
                 break
             elseif betaki<0
                 h=max(G1*(-dk));           
                 betaki=(1-c)*fxkivki/h;
                 dki=vki+betaki*dk;
                 break
             else
               ss=ss+1;
             end
             if ss>100
                  break
              end
              epsiki=min(-0.75*(1-c)*fxkivki/betaki,fxkidk/2);
        end 
         if  k>=5000
             k=nan;
             nf=nan;
             ng=nan;
             nv=nan;
             break
         end
         if a==1    
             break
         end
         dk=dki;
         vk=vki;
         xk=xki;
         G=G1;
         fxk1dk1=max(G*dk);  
         % Compute initial step (k>1)
         alphak=alphak*fxkdk/fxk1dk1;
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


