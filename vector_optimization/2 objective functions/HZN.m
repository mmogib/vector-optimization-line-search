clear,clc
%% Read data
% this is AVHZ method
m=2;
Loop=100;
h=47;
Rloopk=zeros(Loop,h);
Rloopnf=zeros(Loop,h);
Rloopng=zeros(Loop,h);
Rloopnv=zeros(Loop,h);
Rloopt=zeros(Loop,h);
Rloopchu=zeros(Loop,h*m);
Rloophv=zeros(h,1);
for d=1:29 
    for iLoop=1:Loop
        tic;
         %%  Initialization
        nv=1;
        k=1;
        nf=1;
        ng=1;
        mu=1;
        alphamax=10^10;
        if d==1
            S1 = load('BK1.mat');
            n=2;
          %  xk=-5+(10-(-5))*rand(n,1);
        elseif d==2
            S1 = load('DGO1.mat');
            n=1;
             %xk=-10+(13-(-10))*rand(n,1);
        elseif d==3
            S1 = load('DGO2.mat');
            n=1;
        elseif d==4
           S1 = load('FF12.mat'); %FF12
            n=2;
           %  xk=-1+(1-(-1))*rand(n,1);
        elseif d==5 
            S1 = load('JOS1.mat');
            n=10;
        elseif d==6  
            S1 = load('JOS1.mat');
            n=100;
        elseif d==7  
            S1 = load('JOS1.mat');
            n=1000;
        elseif d==8
            S1 = load('MLF1.mat');
            n=1;
        elseif d==9
            S1 = load('MLF2.mat');
            n=2;
        elseif d==10
            S1 = load('T1.mat');
            n=2;
        elseif d==11
            S1 = load('T27.mat');
            n=2;
        elseif d==12
            S1 = load('T4.mat');
            n=10;
        elseif d==13
            S1 = load('T6.mat');
            n=2;
        elseif d==14
            S1 = load('T7.mat');
            n=3;
        elseif d==15
            S1 = load('SP1.mat');
            n=2;
        elseif d==16
            S1 = load('SSFYY2.mat');
            n=1;
        elseif d==17
            S1 = load('SK1.mat');
            n=1;
        elseif d==18
            S1 = load('SK2.mat');
            n=4;
        elseif d==19
            S1 = load('VU1.mat');
            n=2;
            % xk=-3+(3-(-3))*rand(n,1);
        elseif d==20
            S1 = load('MOP1.mat');
            n=1;
        elseif d==21
            S1 = load('MOP2.mat');
            n=2;
            %xk=-4+(4-(-4))*rand(n,1);
        elseif d==22
            S1 = load('MOP37.mat');
            n=2;
           %  xk=-pi+(pi-(-pi))*rand(n,1);
        elseif d==23
           S1 = load('DD1.mat');
            n=5;
          %  xk=-20+(20-(-20))*rand(n,1);
        elseif d==24
            S1 = load('TOI4.mat');
            n=4;
             %xk=-2+(5-(-2))*rand(n,1);
        elseif d==25
            S1 = load('Hil1.mat');
            n=2;
            %xk=0+(1-(0))*rand(n,1);
        elseif d==26
            S1 = load('PNR.mat');
            n=2;
           % xk=-2+(2-(-2))*rand(n,1);
        elseif d==27
            S1 = load('MMR1.mat');
            n=2;
        elseif d==28
            S1 = load('AP3.mat');
            n=2;
        elseif d==29
            S1 = load('LOV5.mat');
            n=3;
        end
      
        BP1 = struct2cell(S1);
        Mymat1 = cell2mat(BP1);
        x0=Mymat1(1:n,iLoop);
        xk=Mymat1(1:n,iLoop);
        % x0=xk;
        gd1=g1(xk,d);
        gd2=g2(xk,d);
        r1=1/max(1,norm(gd1,inf));
        r2=1/max(1,norm(gd2,inf));
        %F=[r1*f1(xk,d);r2*f2(xk,d)];
        F=[f1(xk,d);f2(xk,d)];
        nf=nf+2;
         %% Solve subproblem
        H=zeros(n+1,n+1);
        H(2:n+1,2:n+1)=eye(n);
        ff=zeros(n+1,1);
        ff(1,1)=1;
        A=[-1 r1*g1(xk,d)' ;-1 r2*g2(xk,d)'];
        ng=ng+2;
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
                % Compute the stepsize satisfying the strong Wolfe conditions
                [alphak,nf,ng]=qwolfe(xk,dk,alphak,alphamax,nf,ng,d,r1,r2);
                x1=xk+alphak*dk;
                F1=[f1(x1,d);f2(x1,d)];
                nf=nf+2;
                H=zeros(n+1,n+1);
                H(2:n+1,2:n+1)=eye(n);
                ff=zeros(n+1,1);
                ff(1,1)=1;
                A=[-1 r1*g1(x1,d)' ;-1 r2*g2(x1,d)'];
                ng=ng+2;
                b=zeros(m,1);
                xx=ones(n+1,1);
                [d1,sitak1]= quadprog(H,ff,A,b,[],[],[],[],xx);
                nv=nv+1;
                vk1=d1(2:n+1);
                fxk1vk1=d1(1);
                fxkvk1=max([r1*g1(xk,d)'*vk1,r2*g2(xk,d)'*vk1]);
                p=-fxk1vk1+fxkvk1;
                fxk1dk=max([r1*g1(x1,d)'*dk,r2*g2(x1,d)'*dk]);
                fxkdk=max([r1*g1(xk,d)'*dk,r2*g2(xk,d)'*dk]);
                gamma=max(norm(r1*g1(x1,d)-r1*g1(xk,d))^2,norm(r2*g2(x1,d)-r2*g2(xk,d))^2);
                beta=(1/(fxk1dk-fxkdk))*(p-mu*fxk1dk*gamma/(fxk1dk-fxkdk));
                betak=max(0,beta);
                dk1=vk1+betak*dk;
                fxk1dk1=max([r1*g1(x1,d)'*dk1,r2*g2(x1,d)'*dk1]);
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
            sitak=sitak1;
            % Compute initial step (k>1)
            alphak=alphak*fxkdk/fxk1dk1;
            alphak=max(alphak,0.02);
            alphak=min(alphak,100);
        end
        t=toc;
        FF1=[f1(xk,d),f2(xk,d)];
        Rloopk(iLoop,d)=k;
        Rloopnf(iLoop,d)=nf;
        Rloopng(iLoop,d)=ng;
        Rloopnv(iLoop,d)=nv;
        Rloopt(iLoop,d)=t;
        Rloopchu(iLoop,d*m-1:d*m)=FF1;
%% draw the the outline of Pareto frontiers   
%                     plot(F(1,1),F(2,1),'.k',F1(1,1),F1(2,1),'r*','MarkerSize',4);
%                     plot([F(1,1),F1(1,1)],[F(2,1),F1(2,1)],'k');
%                     %axis([0 1 0 40])
%                     xlabel({'$f_1(x)$'},'Interpreter','latex')
%                     ylabel({'$f_2(x)$'},'Interpreter','latex')
%                     title('PNR','fontname','Times New Roman','Color','k','FontSize',13)
%                     pause(0.1);
%                     hold on;
    end
 end
% 
